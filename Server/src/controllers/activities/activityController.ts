import { NextFunction, Request, Response } from 'express';
import { Activity } from '../../models/activities/activitieModel';
import { Member } from '../../models/Member';
import { participationEmail } from '../../utility/NotificationEmailUtility';


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
  export const GetActivityByname= async (req: Request, res: Response, next: NextFunction) => {
    try {
      const name = req.params.name;
      const activitie = await Activity.findOne({name});
      if (activitie) {
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
      if (event.Participants.includes(member._id)) {
        return res.status(400).json({ message: 'Participant is already added to the event' });
      }
await FoundedMember?.Activities.push(event)
      // Add the participant to the Participants array
      await event.Participants.push(member);

      // Save the updated event
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
      const isParticipantAdded = event.Participants.some((member) => member._id.equals(participantId));
  
      if (!isParticipantAdded) {
        return res.status(400).json({ message: 'Participant is not added to the event' });
      }
  participant.Activities=participant.Activities.filter((activity)=>activity._id.equals(eventId))
      // Remove the participant from the Participants array
      event.Participants = event.Participants.filter((member) => !member._id.equals(participantId));
  
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