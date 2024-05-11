import { plainToClass } from 'class-transformer';
import { validate } from 'class-validator';
import { NextFunction, Request, Response } from 'express';
import { ActivityMemberStatus, GuestInput, SeachActivityInputs, SearchType } from '../../dto/activity.dto';
import { Activity } from '../../models/activities/activitieModel';
import { Event } from '../../models/activities/eventModel';
import { Guest } from '../../models/activities/Guests';
import { Meeting } from '../../models/activities/meetingModel';
import { Training } from '../../models/activities/TrainingModel';
import { Member } from '../../models/Member';
import { ConfirmGuestPartGuestEmail, participationEmail, sendAbsenceEmail, sendAddGuestEmail, sendPresenceEmail } from '../../utility/NotificationEmailUtility';
import { getGuestInfo, getMembersInfo } from '../../utility/role';


export const GetActivityByid= async (req: Request, res: Response, next: NextFunction) => {
    try {
      const id = req.params.id;
      const activitie = await Activity.findById(id);
      if (activitie) {
        res.json(activitie);
      } else {
        res.status(404).json({ message: "No event found with this id" });
      }
    } catch (error) {
      console.error('Error retrieving event by id:', error);
      next(error);
    }
    
  }
 export  const getActivityMembers = async (req:Request, res:Response) => {
    const { activityId } = req.params; // Assuming you're sending activityId as a route parameter
  
    try {
      // Find the activity document by its ID
      const activity = await Activity.findById(activityId);
      if (!activity) {
        return res.status(404).json({ message: "Activity not found" });
      }
  const formated=await Promise.all(activity.Participants.map(async(partipant)=>({
    member:await getMembersInfo(partipant.memberid),
    status:partipant.status
  })))
      // Return the members array from the activity document
      res.status(200).json( formated);
    } catch (error) {
      console.error(error);
      res.status(500).json({ message: "Internal server error" });
    }
  };
 export  const changeMemberStatus = async (req:Request, res:Response) => {
    const { activityId, memberId, status } = req.body; // Assuming you're sending activityId, memberId, and status in the request body
  
    try {
      const eventInputs=plainToClass(ActivityMemberStatus,req.body)
      // Validate the inputs
      const errors = await validate(eventInputs, { validationError: { target: false } });
      if (errors.length > 0) {
        return res.status(400).json({ message: 'Invalid input', errors });
      }
      // Find the activity document by its ID
      const activity = await Activity.findById(activityId);
      if (!activity) {
        return res.status(404).json({ message: "Activity not found" });
      }
  
      // Find the index of the member within the activity's members array
      const memberIndex = activity.Participants.findIndex(member => member.memberid.equals(memberId));
      if (memberIndex === -1) {
        return res.status(404).json({ message: "Member not found in activity" });
      }
  const member=await Member.findById(memberId)
      // Update the status of the member based on the status provided in the request body
      activity.Participants[memberIndex].status = status;
      if (member){
        if (status === 'absent' && member && member.Points >= activity.ActivityPoints) {
          member.Points -= activity.ActivityPoints;
          await member.save();
          sendAbsenceEmail(member.language, member.email, activity.name);
        } else if (status === 'present' && member) {
          console.log("ddddd")
          member.Points += activity.ActivityPoints;
          await member.save();
          sendPresenceEmail(member.language, member.email, activity.name, activity.ActivityPoints);
        }

}
      // Save the updated activity document
      await activity.save();
  
      // Return a success response
      res.status(200).json({ message: "Member status updated successfully" });
    } catch (error) {
      console.error(error);
      res.status(500).json({ message: "Internal server error" });
    }
  };
  
  export const GetActivityByname= async (req: Request, res: Response, next: NextFunction) => {
    try {
      const eventInputs=plainToClass(SeachActivityInputs,req.body)
      // Validate the inputs
      const errors = await validate(eventInputs, { validationError: { target: false } });
      if (errors.length > 0) {
        return res.status(400).json({ message: 'Invalid input', errors });
      }
      let activitie;
      if (eventInputs.type==SearchType.Training){
         activitie = await Training.find({ name: { $regex: eventInputs.name, $options: 'i' }});
      }
      else if (eventInputs.type==SearchType.Event){
          activitie = await Event.find({ name: { $regex: eventInputs.name, $options: 'i' } });
      }
      else if (eventInputs.type==SearchType.Meeting){
          activitie = await Meeting.find({ name: { $regex: eventInputs.name, $options: 'i' }});
      }
      else{
        activitie = await Activity.find({ name: { $regex: eventInputs.name, $options: 'i' } });
      }
      if (activitie.length>0) {
        res.json(activitie);
      } else {
        res.status(404).json({ message: "No event found with this name" });
      }
    } catch (error) {
      console.error('Error retrieving event by name:', error);
      next(error);
    }
    
  }

  export const AddParticipantToActivity = async (req: Request, res: Response, next: NextFunction) => {
    const member=req.member
    if (member){
    try {
      const eventId = req.params.id;
  
  
      console.log(eventId)
      // Find the event by ID
      const event = await Activity.findById(eventId);
      console.log(event)
  
      if (!event) {
        return res.status(404).json({ message: 'Event not found' });
      }
const FoundedMember=await Member.findById(member._id)
      // Check if the participant is already added
      const existingMemberIndex = event.Participants.findIndex(member => member.memberid.equals(FoundedMember?.id));
      if (existingMemberIndex !== -1) {
        return res.status(400).json({ message: "Member already exists in activity" });
      }
  
      // Add the member to the activity's members array
      event.Participants.push({ memberid: FoundedMember?.id, status: 'pending' }); // Assuming the default status is 'pending'
  
   await FoundedMember?.Activities.push(event)   // Save the updated event
      const updatedEvent = await event.save();
      const updatedMember = await FoundedMember!.save();
participationEmail(event.name,event.ActivityBeginDate,event.ActivityAdress,FoundedMember?.language||'fr',FoundedMember!.email,FoundedMember!.firstName)  
      // Respond with the updated event
      res.status(200).json({ message: 'Participant added to the event', activity: updatedEvent,FoundedMember:updatedMember?.Activities });
    } catch (error) {
     res.status(500).json({ message: 'Error adding participant to the event' });
    }}
  };
  export const RemoveParticipant = async (req: Request, res: Response, next: NextFunction) => {
    const member=req.member
    if (member){
    try {
      const eventId = req.params.id;
      const participantId = member._id;
  
      // Find the event by ID
      const event = await Activity.findById(eventId);
  
      if (!event) {
        return res.status(404).json({ message: 'Event not found' });
      }
  
      // Find the participant by ID
      const participant = await Member.findById(participantId);
  
      if (!participant) {
        return res.status(404).json({ message: 'Participant not found' });
      }
  
      // Check if the participant is added to the event
      const memberIndex = event.Participants.findIndex(member => member.memberid.equals(participantId));
      if (memberIndex === -1) {
        return res.status(404).json({ message: "Member not found in activity" });
      }
  
      // Remove the member from the activity's members array
      event.Participants.splice(memberIndex, 1);
  
      participant.Activities=participant.Activities.filter((activity)=>activity._id.equals(eventId))
      // Remove the participant from the Participants array
  
      // Save the updated event
      const updatedEvent = await event.save();
  await participant.save()
      // Respond with the updated event
      res.json({ message: 'Participant removed from the event', activity: updatedEvent });
    } catch (error) {
       res.status(500).json({message:'Error removing participant from event:', error});
      next(error);
     } }
  };
  export const deleteActivity= async (req:Request, res:Response, next:NextFunction) => {
    try {
      const TrainingId = req.params.id;

      // Check if the event exists
      const train = await Activity.findById(TrainingId);
      if (!train) {
        return res.status(404).json({ error: 'Training not found' });
      }

      // Delete the event
      await train.deleteOne();

      res.status(204).json({message:"deleted successully"}); // 204 No Content indicates a successful deletion
    } catch (error) {
      console.error('Error deleting event:', error);
      next(error);
    }
  };


  export const addGuest=async(req:Request,res:Response)=>{

    try {
      const eventInputs=plainToClass(GuestInput,req.body)
      // Validate the inputs
      const errors = await validate(eventInputs, { validationError: { target: false } });
      if (errors.length > 0) {
        return res.status(400).json({ message: 'Invalid input', errors });
      }

      // find guest by email 
      let guest = await Guest.find({email:eventInputs.email})
      if (guest.length>0){
        return res.status(409).json({ message: 'Guest already exists' });
      }
      const {activityId}=req.params
      const activity=await Activity.findById(activityId)
      if (!activity){
        return res.status(404).json({message:"Activity not found"})
      }
      const newguest=new Guest({
        name:eventInputs.name,
        email:eventInputs.email,
        phone:eventInputs.phone
      
      }  )

      await newguest.save()
      
      
      activity.guests.push({ guest: newguest?.id, status: 'pending' }); // Assuming the default status is 'pending'
  

      await activity.save()
      sendAddGuestEmail(newguest.email,activity.name,newguest.name,activity.ActivityAdress,activity.ActivityBeginDate)
      res.status(200).json({message:"Guest added successfully",guest:newguest})
        
    
      
    } catch (error) {
      console.error('Error adding guest to activity:', error);
      res.status(500).json({ message: "Internal server error" });
      
    }
  }
  export const addGuestToAct=async(req:Request,res:Response)=>{

    try {
   
  const {activityId,guestId}=req.params
      // find guest by email 
      let guest = await Guest.findById(guestId)

    
      const activity=await Activity.findById(activityId)
      if (!activity){
        return res.status(404).json({message:"Activity not found"})
      }
      //check if al ready exists
      if (activity.guests.includes(
        (guest: any)=>guest.guest.equals(guestId)
      )){
        return res.status(409).json({ message: 'Guest already exists' });
      }
     
        
      activity.guests.push({ guest: guest!.id, status: 'present' }); // Assuming the default status is 'pending'
  
      await activity.save()
      sendAddGuestEmail(guest!.email,activity.name,guest!.name,activity.ActivityAdress,activity.ActivityBeginDate)
      res.status(200).json({message:"Guest added successfully"})
        
    
      
    } catch (error) {
      console.error('Error adding guest to activity:', error);
      res.status(500).json({ message: "Internal server error" });
      
    }
  }


  export const getAllGuestsOfActivity = async (req: Request, res: Response) => {
    try {
      const { activityId } = req.params;
      const activity = await Activity.findById(activityId).populate('Guests');
      if (!activity) {
        return res.status(404).json({ message: 'Activity not found' });
      }
      const formated=await Promise.all(activity.guests.map(async(partipant)=>({
        guest:await getGuestInfo(partipant.guest),
        status:partipant.status
      })))

      res.status(200).json( formated );
    
    } catch (error) {
      console.error('Error fetching guests of activity:', error);
      res.status(500).json({ message: 'Internal server error' });
    }
  };
    export const getAllGuests = async (req: Request, res: Response) => {
    try {

      const guests = await Guest.find();
      res.status(200).json( guests );
    
    } catch (error) {
      console.error('Error fetching guests :', error);
      res.status(500).json({ message: 'Internal server error' });
    }
  };
  
  // Function to update guest information
  export const updateGuest = async (req: Request, res: Response) => {
    try {
      const { guestId } = req.params;
      const guestInputs = plainToClass(GuestInput, req.body);
      // Validate the inputs
      const errors = await validate(guestInputs, { validationError: { target: false } });
      if (errors.length > 0) {
        return res.status(400).json({ message: 'Invalid input', errors });
      }
      const guest = await Guest.findById(guestId);
      if (!guest) {
        return res.status(404).json({ message: 'Guest not found' });
      }
      guest.name = guestInputs.name;
      guest.email = guestInputs.email;
      guest.phone = guestInputs.phone;
      await guest.save();
      res.status(200).json({ message: 'Guest updated successfully', guest });
    } catch (error) {
      console.error('Error updating guest:', error);
      res.status(500).json({ message: 'Internal server error' });
    }
  };
  
  // Function to delete a guest
  export const deleteGuest = async (req: Request, res: Response) => {
    try {
      const { guestId,activityId } = req.params;
      const guest = await Guest.findByIdAndDelete(guestId);
      if (!guest) {
        return res.status(404).json({ message: 'Guest not found' });
      }
      const activity=await Activity.findById(activityId);
      if (!activity){
        return res.status(404).json({ message: 'activity not found' });
      }
      const guestIndex = activity.guests.findIndex(guest => guest.guest.equals(guestId));
      if (guestIndex === -1) {
        return res.status(404).json({ message: 'Guest not found in activity' });
      }
      activity.guests.splice(guestIndex, 1);
      await activity.save()



   
      res.status(204).json({ message: 'Guest deleted successfully' });
    } catch (error) {
      console.error('Error deleting guest:', error);
      res.status(500).json({ message: 'Internal server error' });
    }
  };
  
  // Function to update guest confirmation status
  export const updateGuestConfirmation = async (req: Request, res: Response) => {
    try {
      const { guestId,activityId } = req.params;
      
      const { confirmed } = req.body;
      console.log(confirmed)
      const guest = await Guest.findById(guestId);
      if (!guest) {
        return res.status(404).json({ message: 'Guest not found' });
      }
      const activity=await Activity.findById(activityId)
      if (!activity){
        return res.status(404).json({ message: 'activity not found' });
      }
      const guestIndex = activity.guests.findIndex(guest => guest.guest.equals(guestId));
      if (guestIndex === -1) {
        return res.status(404).json({ message: 'Guest not found in activity' });
      }
      activity.guests[guestIndex].status = confirmed;
      await guest.save();
        await activity.save();
      if (confirmed=='present'){
      ConfirmGuestPartGuestEmail(guest.email,activity.name,guest.name,activity.ActivityAdress,activity.ActivityBeginDate)}
      res.status(200).json({ message: 'Guest confirmation updated successfully', guest });
    } catch (error) {
      console.error('Error updating guest confirmation:', error);
      res.status(500).json({ message: 'Internal server error' });
    }
  };
  