import { plainToClass } from 'class-transformer';
import { NextFunction, Request, Response } from 'express';

import { MeetingField, MeetingInputs } from '../../dto/activity.dto';
import { Member } from '../../models/Member';

import { validate } from 'class-validator';
import { Meeting, } from '../../models/activities/meetingModel';

//&Public


export const getAllmeetings = async (req: Request, res: Response, next: NextFunction) => {
  try {
    // Fetch all meetings and sort them by ActivityBeginDate in ascending order
    const meetings = await Meeting.find().sort({ ActivityBeginDate: -1 });

    // Format and send the meetings in the response
    const formattedmeetings = meetings.map<MeetingField>((meeting) => ({
      _id: meeting._id,
      name: meeting.name,
      Director: meeting.Director,
Agenda:meeting.Agenda,
   
     
      ActivityBegindate: meeting.ActivityBeginDate,
      ActivityEnddate: meeting.ActivityEndDate,
      description: meeting.description,

      ActivityPoints: meeting.ActivityPoints,
      categorie: meeting.categorie,
  
 
      participants: meeting.Participants,
      
    }));

    res.json({ meetings: formattedmeetings });
  } catch (error) {
    console.error('Error retrieving all meetings:', error);
    next(error);
  }
};


//&Private

export const addmeeting = async (req: Request, res: Response, next: NextFunction) => {
  try {
      // Extract data from the request body
      const meetingInputs = plainToClass(MeetingInputs, req.body);
    
      

      // Validate the inputs
      const errors = await validate(meetingInputs, { validationError: { target: false } });
if (errors.length > 0) {
  return res.status(400).json({ message: 'Input validation failed', errors });
}

      // Create a meeting document
      const newMeeting = new Meeting({
          name: meetingInputs.name,
          description: meetingInputs.description,
          ActivityBeginDate: meetingInputs.ActivityBeginDate,
        Agenda:meetingInputs.agenda,
        Director:meetingInputs.Director,
          categorie: meetingInputs.categorie,
ActivityPoints: meetingInputs.ActivityPoints,
       Participants:[]
      });

      // Add the meeting to the database
      const savedMeeting = await newMeeting.save();

      res.json(savedMeeting);
  } catch (error) {
      console.error('Error adding meeting:', error);
      next(error);
  }
};

export const getmeetingById = async (req: Request, res: Response, next: NextFunction) => {
  try {
    const id = req.params.id;
    const meeting = await Meeting.findById(id);
    if (meeting) {
      res.json({
        _id: meeting._id,
        name: meeting.name,
        Director: await findParticipentById(meeting.Director),
       Agenda:meeting.Agenda,
     
       
        ActivityBegindate: meeting.ActivityBeginDate,
       
        description: meeting.description,
  
        ActivityPoints: meeting.ActivityPoints,
        categorie: meeting.categorie,
       
      
        participants: meeting.Participants,
        
      });
    } else {
      res.status(404).json({ message: "No meeting found with this id" });
    }
  } catch (error) {
    console.error('Error retrieving meeting by id:', error);
    next(error);
  }
  
}
const findParticipentById=async (id:string)=>{
  const member=await Member.findById(id)
  if (member){
    return member.firstName
  }
  return null
}
export const getmeetingByName = async (req: Request, res: Response, next: NextFunction) => {
  try {
    const name = req.params.name;
    const meeting = await Meeting.findOne
    ({name:name});
    if (meeting) {
      res.json(meeting);
    } else {
      res.status(404).json({ message: "No meeting found with this name" });
    }
  } catch (error) {
    console.error('Error retrieving meeting by name:', error);
    next(error);
  }

}
export const getmeetingByDate = async (req: Request, res: Response, next: NextFunction) => {
  try {
    const date = req.params.date;
    const meeting = await Meeting.findOne
    ({ActivityBeginDate:date});
    if (meeting) {
      res.json(meeting);
    } else {
      res.status(404).json({ message: "No meeting found with this date" });
    }
  } catch (error) {
    console.error('Error retrieving meeting by date:', error);
    next(error);
  }}


  export const uploadImage= async (req: Request, res: Response, next: NextFunction) => {
    try {
    const   id=req.params.id
      // Find the meeting
      const meeting = await Meeting.findById(id);

      if (!meeting) return res.status(401).send("No such meeting")
      const images: Express.Multer.File[] = req.files as Express.Multer.File[];
  console.log(images)
      // Convert images to base64
      const base64Images = images.map((image) => image.buffer.toString('base64'));
  
      // Add the images to the meeting
      meeting.CoverImages.push(...base64Images);
  
      // Save the meeting
      const savedmeeting = await meeting.save();
  
      res.json(savedmeeting);
    } catch (error) {
      console.error('Error uploading image:', error);
      next(error);
    }
  }
  export const GetmeetingsOfWeekend = async (req: Request, res: Response, next: NextFunction) => {
    try {
      const currentDate = new Date();
      const currentDay = currentDate.getDay();

      // Calculate the first day of the week (Monday)
      const firstDayOfWeek = new Date(currentDate.getFullYear(), currentDate.getMonth(), currentDate.getDate() - currentDay + (currentDay === 0 ? -6 : 1));

      // Calculate the last day of the week (Sunday)
      const lastDayOfWeek = new Date(currentDate.getFullYear(), currentDate.getMonth(), currentDate.getDate() - currentDay + 7);

      const meetingsOfWeek = await Meeting.find({
          ActivityBeginDate: { $gte: firstDayOfWeek, $lte: lastDayOfWeek },
      });

      if (meetingsOfWeek.length > 0) {
          const formattedMeetings = meetingsOfWeek.map<MeetingField>((meeting) => ({
              _id: meeting._id,
              name: meeting.name,
              Director: meeting.Director,
           Agenda:meeting.Agenda,
              ActivityBegindate: meeting.ActivityBeginDate,
         
              description: meeting.description,
              ActivityPoints: meeting.ActivityPoints,
              categorie: meeting.categorie,
          
              
              participants: meeting.Participants,
            
          }));

          res.json({ meetings: formattedMeetings });
      } else {
          res.json({ message: "No meetings found for this week" });
      }
  } catch (error) {
      console.error('Error retrieving meetings of the week:', error);
      next(error);
  }
  };
  export const AddParticipantTomeeting = async (req: Request, res: Response, next: NextFunction) => {
    const member=req.member
    if (member){
    try {
      const meetingId = req.params.idmeeting;
   
  
      console.log(meetingId)
      // Find the meeting by ID
      const meeting = await Meeting.findById(meetingId);
      console.log(meeting)
  
      if (!meeting) {
        return res.status(404).json({ message: 'meeting not found' });
      }

      // Check if the participant is already added
      if (meeting.Participants.includes(member._id)) {
        return res.status(400).json({ message: 'Participant is already added to the meeting' });
      }
  
      // Add the participant to the Participants array
      await meeting.Participants.push(member);
  
      // Save the updated meeting
      const updatedmeeting = await meeting.save();
  
      // Respond with the updated meeting
      res.status(200).json({ message: 'Participant added to the meeting', meeting: updatedmeeting });
    } catch (error) {
     res.status(500).json({ message: 'Error adding participant to the meeting' });
    }}
  };
 // Import your Member model

export const RemoveParticipantFrommeeting = async (req: Request, res: Response, next: NextFunction) => {
  const member=req.member
  if (member){
  try {
    const meetingId = req.params.idmeeting;
    const participantId = member._id;

    // Find the meeting by ID
    const meeting = await Meeting.findById(meetingId);

    if (!meeting) {
      return res.status(404).json({ message: 'meeting not found' });
    }

    // Find the participant by ID
    const participant = await Member.findById(participantId);

    if (!participant) {
      return res.status(404).json({ message: 'Participant not found' });
    }

    // Check if the participant is added to the meeting
    const isParticipantAdded = meeting.Participants.some((member) => member._id.equals(participantId));

    if (!isParticipantAdded) {
      return res.status(400).json({ message: 'Participant is not added to the meeting' });
    }

    // Remove the participant from the Participants array
    meeting.Participants = meeting.Participants.filter((member) => !member._id.equals(participantId));

    // Save the updated meeting
    const updatedmeeting = await meeting.save();

    // Respond with the updated meeting
    res.json({ message: 'Participant removed from the meeting', meeting: updatedmeeting });
  } catch (error) {
     res.status(500).json({message:'Error removing participant from meeting:', error});
    next(error);
   } }
};
