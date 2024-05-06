import { plainToClass } from 'class-transformer';
import { NextFunction, Request, Response } from 'express';

import { MeetingField, MeetingInputs } from '../../dto/activity.dto';
import { Member } from '../../models/Member';

import { validate } from 'class-validator';
import { Meeting, } from '../../models/activities/meetingModel';
import { getMembersInfo, getPermissionIdsByRelated } from '../../utility/role';
import { sendNewEventEmail } from '../../utility/NotificationEmailUtility';

//&Public


export const getAllmeetings = async (req: Request, res: Response, next: NextFunction) => {
  
  
  try {
    // Fetch all meetings and sort them by ActivityBeginDate in ascending order
    const meetings = await Meeting.find().sort({ ActivityBeginDate: -1 });
    const permission=await getPermissionIdsByRelated(["Meetings"])

    // Format and send the meetings in the response
    const formattedmeetings = meetings.map<MeetingField>((meeting) => ({
      _id: meeting._id,
      name: meeting.name,
      Director: meeting.Director,
Agenda:meeting.Agenda,
       IsPart:meeting.Participants.some((member) => member._id.equals(req.body.id)),

   
     
      ActivityBegindate: meeting.ActivityBeginDate,
      ActivityEnddate: meeting.ActivityEndDate,
      description: meeting.description,

      ActivityPoints: meeting.ActivityPoints,
      categorie: meeting.categorie,
  
 
      participants: meeting.Participants,
      
    }));

    res.json({         Permissions:permission,
      meetings: formattedmeetings });
  } catch (error) {
    console.error('Error retrieving all meetings:', error);
    next(error);
  }
};


//&Private
export const updateMeeting = async (req: Request, res: Response, next: NextFunction) => {
  try {
    // Extract data from the request body
    const meetingInputs = plainToClass(MeetingInputs, req.body);

    // Validate the inputs
    const errors = await validate(meetingInputs, { validationError: { target: false } });
    if (errors.length > 0) {
      return res.status(400).json({ message: 'Input validation failed', errors });
    }

    const meetingId = req.params.id;

    // Find the existing meeting by ID
    const existingMeeting = await Meeting.findById(meetingId);

    if (!existingMeeting) {
      return res.status(404).json({ message: 'Meeting not found' });
    }

    // Update the existing meeting properties
    existingMeeting.name = meetingInputs.name;
    existingMeeting.description = meetingInputs.description;
    existingMeeting.ActivityBeginDate = meetingInputs.ActivityBeginDate;
    existingMeeting.Agenda = meetingInputs.agenda;
    existingMeeting.Director = meetingInputs.Director;
    existingMeeting.categorie = meetingInputs.categorie;
    existingMeeting.ActivityPoints = meetingInputs.ActivityPoints;
    existingMeeting.Price = meetingInputs.price;

    // Save the updated meeting
    const updatedMeeting = await existingMeeting.save();

    res.json(updatedMeeting);
  } catch (error) {
    console.error('Error updating meeting:', error);
    next(error);
  }
};

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
        price:meetingInputs.price,
        
          categorie: meetingInputs.categorie,
ActivityPoints: meetingInputs.ActivityPoints,
       Participants:[]
      });

      // Add the meeting to the database
      const savedMeeting = await newMeeting.save();
      const members=await Member.find().select(["email","language"])
   
 
 members.forEach((member)=>{
 
   sendNewEventEmail(savedMeeting.name,savedMeeting.ActivityBeginDate,savedMeeting.ActivityAdress,member.language,member.email,"meeting",savedMeeting.Agenda,"")
 })
 
      res.json(savedMeeting);
  } catch (error) {
      console.error('Error adding meeting:', error);
      next(error);
  }
};

export const getmeetingById = async (req: Request, res: Response, next: NextFunction) => {
  try {
    const id = req.params.id;
  const Permissions=await getPermissionIdsByRelated(["Meetings"])

    const meeting = await Meeting.findById(id);
    if (meeting) {
      res.json({
        _id: meeting._id,
        name: meeting.name,
        Director: await findParticipentById(meeting.Director),
       Agenda:meeting.Agenda,
     
             IsPart:meeting.Participants.some((member) => member._id.equals(req.body.id)),

        ActivityBegindate: meeting.ActivityBeginDate,
       
        description: meeting.description,
  
        ActivityPoints: meeting.ActivityPoints,
        categorie: meeting.categorie,
        Permissions:Permissions,
       
      
        participants: await getMembersInfo(meeting.Participants.map(member=>member.memberid)),
        
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

          
       IsPart:meeting.Participants.some((member) => member._id.equals(req.body.id)),
              
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

 // Import your Member model


