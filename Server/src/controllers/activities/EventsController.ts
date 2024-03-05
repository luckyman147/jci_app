import { plainToClass } from 'class-transformer';
import { NextFunction, Request, Response } from 'express';

import { EventInputs, EventOftheMonthField } from '../../dto/activity.dto';
import { Member } from '../../models/Member';


import { Event } from '../../models/activities/eventModel';

//&Public


export const getAllEvents = async (req: Request, res: Response, next: NextFunction) => {
  try {
    // Fetch all events and sort them by ActivityBeginDate in ascending order
    const events = await Event.find().sort({ ActivityBeginDate: -1 });
if (events.length>0) {
    // Format and send the events in the response
    const formattedEvents = events.map<EventOftheMonthField>((event) => ({
      _id: event._id,
      name: event.name,
      LeaderName: event.LeaderName,

      ActivityPoints: event.ActivityPoints,
      description: event.description,
      categorie: event.categorie,
      IsPaid: event.IsPaid,
      price: event.price,
      registrationDeadline: event.registrationDeadline,
      
      ActivityBegindate: event.ActivityBeginDate,
      ActivityEnddate: event.ActivityEndDate,
      ActivityAdress: event.ActivityAdress,
 
      participants: event.Participants,
      CoverImages: event.CoverImages,
    }));

    res.status(200).json({ events: formattedEvents });}
    else{
      res.status(400).json({message:"No events found"})
    }
  } catch (error) {
    res.status(500).json({Error : error});

  }
};
export const GetEventsOfWeekend = async (req: Request, res: Response, next: NextFunction) => {
  try {
    const currentDate = new Date();
    const currentDay = currentDate.getDay();
    const firstDayOfWeekend = new Date(currentDate.getFullYear(), currentDate.getMonth(), currentDate.getDate() + (5 - currentDay));
    const lastDayOfWeekend = new Date(currentDate.getFullYear(), currentDate.getMonth(), currentDate.getDate() + (8 - currentDay));
console.log(firstDayOfWeekend)
console.log(lastDayOfWeekend)
console.log(currentDate)
    const eventsOfWeekend = await Event.find({
      ActivityBeginDate: { $gte: firstDayOfWeekend, $lte: lastDayOfWeekend },
    }).sort({ ActivityBeginDate: -1 });

    if (eventsOfWeekend.length > 0) {
      const formattedEvents = eventsOfWeekend.map<EventOftheMonthField>((event) => ({
        _id: event._id,
        name: event.name,
        LeaderName: event.LeaderName,
  
        ActivityPoints: event.ActivityPoints,
        description: event.description,
        categorie: event.categorie,
        IsPaid: event.IsPaid,
        price: event.price,
        registrationDeadline: event.registrationDeadline,
        
        ActivityBegindate: event.ActivityBeginDate,
        ActivityEnddate: event.ActivityEndDate,
        ActivityAdress: event.ActivityAdress,
   
        participants: event.Participants,
        CoverImages: event.CoverImages,
      }));
      res.status(200).json({ events: formattedEvents });
    } else {
      res.status(400).json({ message: "No events found for this weekend" });
    }
  } catch (error) {
    console.log('Error retrieving events of the weekend:', error);
    next(error);
  }
};
export const GetEventsOfMonth= async (req:Request,res:Response,next:NextFunction)=> {

    try {
        const currentDate = new Date();
        const firstDayOfMonth = new Date(currentDate.getFullYear(), currentDate.getMonth(), 1);
        const lastDayOfMonth = new Date(currentDate.getFullYear(), currentDate.getMonth() + 1, 0);
    
        const eventsOfMonth = await Event.find({
          ActivityBeginDate: { $gte: currentDate },
        
        }).sort({ ActivityBeginDate: 1 }).limit(3);
     
    if (eventsOfMonth) {   
        const formattedEvents = eventsOfMonth.map<EventOftheMonthField>((event) => ({
          _id: event._id,
          name: event.name,
          LeaderName: event.LeaderName,
    
          ActivityPoints: event.ActivityPoints,
          description: event.description,
          categorie: event.categorie,
          IsPaid: event.IsPaid,
          price: event.price,
          registrationDeadline: event.registrationDeadline,
          
          ActivityBegindate: event.ActivityBeginDate,
          ActivityEnddate: event.ActivityEndDate,
          ActivityAdress: event.ActivityAdress,
     
          participants: event.Participants,
          CoverImages: event.CoverImages,

          }));
          console.log(formattedEvents);
        res.status(200).json({ events: formattedEvents });
    
    }
    else{
        res.status(400).json({message:"No events found for this month"})
    }
      } catch (error) {
        console.error('Error retrieving events of the month:', error);
        next(error);
      }


}

//&Private

export const addEvent = async (req: Request, res: Response, next: NextFunction) => {
  try {
    // Extract data from the request body
    const eventInputs=plainToClass(EventInputs,req.body)

    
    // Create an Event document
    const newEvent = new Event({
      
      name: eventInputs.name,
      description: eventInputs.description,
      ActivityBeginDate: eventInputs.ActivityBeginDate,
      ActivityEndDate: eventInputs.ActivityEndDate,
      ActivityAdress: eventInputs.ActivityAdress,
      registrationDeadline: eventInputs.registrationDeadline,
      categorie: eventInputs.categorie,
      IsPaid: eventInputs.IsPaid,
      ActivityPoints:0,
     
      Participants: [],
      LeaderName: eventInputs.LeaderName,

      
      
      
      CoverImages: [], // Convert images to base64
    });

    // Add the event to the database
    const savedEvent = await newEvent.save();

    res.json(savedEvent);
  } catch (error) {
    console.error('Error adding event:', error);
    next(error);
  }}

  export const updateEvent = async (req: Request, res: Response, next: NextFunction) => {
    try {
      const eventId = req.params.id;
  
      // Find the existing event by ID
      const existingEvent = await Event.findById(eventId);
  
      if (!existingEvent) {
        return res.status(404).json({ message: 'Event not found' });
      }
  
      // Extract data from the request body
      const eventInputs = plainToClass(EventInputs, req.body);
  
      // Update the existing event properties
      existingEvent.name = eventInputs.name;
      existingEvent.description = eventInputs.description;
      existingEvent.ActivityBeginDate = eventInputs.ActivityBeginDate;
      existingEvent.ActivityEndDate = eventInputs.ActivityEndDate;
      existingEvent.ActivityAdress = eventInputs.ActivityAdress;
      existingEvent.registrationDeadline = eventInputs.registrationDeadline;
      existingEvent.categorie = eventInputs.categorie;
      existingEvent.IsPaid = eventInputs.IsPaid;
      existingEvent.LeaderName = eventInputs.LeaderName  ;
  
      // Save the updated event
      const updatedEvent = await existingEvent.save();
  
      res.json(updatedEvent);
    } catch (error) {
      console.error('Error updating event:', error);
      next(error);
    }
  }
export const getEventById = async (req: Request, res: Response, next: NextFunction) => {
  try {
    const id = req.params.id;
    const event = await Event.findById(id);
    if (event) {
      res.json({

        _id: event._id,
        name: event.name,
        LeaderName: event.LeaderName,
  
        ActivityPoints: event.ActivityPoints,
        description: event.description,
        categorie: event.categorie,
        IsPaid: event.IsPaid,
        price: event.price,
        registrationDeadline: event.registrationDeadline,
        
        ActivityBegindate: event.ActivityBeginDate,
        ActivityEnddate: event.ActivityEndDate,
        ActivityAdress: event.ActivityAdress,
   
        participants: event.Participants,
        CoverImages: event.CoverImages,

        










      });
      console.log(event)
    } else {

      res.status(404).json({ message: "No event found with this id" });
    }
  } catch (error) {
    console.error('Error retrieving event by id:', error);
    next(error);
  }
  
}





export const getEventByName = async (req: Request, res: Response, next: NextFunction) => {
  try {
    const name = req.params.name;
    const event = await Event.findOne
    ({name:name});
    if (event) {
      res.json(event);
    } else {
      res.status(404).json({ message: "No event found with this name" });
    }
  } catch (error) {
    console.error('Error retrieving event by name:', error);
    next(error);
  }

}
export const getEventByDate = async (req: Request, res: Response, next: NextFunction) => {
  try {
    const date = req.params.date;
    const event = await Event.findOne
    ({ActivityBeginDate:date});
    if (event) {
      res.json(event);
    } else {
      res.status(404).json({ message: "No event found with this date" });
    }
  } catch (error) {
    console.error('Error retrieving event by date:', error);
    next(error);
  }}


  export const uploadImage= async (req: Request, res: Response, next: NextFunction) => {

    try {
    const file=req.files
    console.log("file",file)

      const   id=req.params.id
      // Find the event
      const event = await Event.findById(id);

      if (!event) return res.status(401).send("No such event")
      const images: Express.Multer.File[] = req.files as Express.Multer.File[]||[];

      if (!images || images.length === 0){
            console.log(images)

        return res.status(400).send("Invalid or missing image files");
      }
  console.log(images)
      // Convert images to base64
      const base64Images = images.map((image) => image.buffer.toString('base64'));

      // Add the images to the event
      event.CoverImages.push(...base64Images);

      // Save the event
      const savedEvent = await event.save();

      res.json(savedEvent);
    } catch (error) {
      console.log('Error uploading image:', error);
      next(error);
    }
  }
  export const updateImage = async (req: Request, res: Response, next: NextFunction) => {
    try {
      const eventId = req.params.id;
      const event = await Event.findById(eventId);
  
      if (!event) {
        return res.status(404).send("No such event");
      }
  
      const images: Express.Multer.File[] = req.files as Express.Multer.File[] || [];
  
      if (!images || images.length === 0) {
        return res.status(400).send("Invalid or missing image files");
      }
  
      // Convert images to base64
      const base64Images = images.map((image) => image.buffer.toString('base64'));
  
      // Update the existing images in the event
      event.CoverImages = base64Images;
  
      // Save the event
      const updatedEvent = await event.save();
  
      res.json(updatedEvent);
    } catch (error) {
      console.log('Error updating image:', error);
      next(error);
    }
  }
  export const AddParticipantToEvent = async (req: Request, res: Response, next: NextFunction) => {
    const member=req.member
    if (member){
    try {
      const eventId = req.params.idEvent;
   
  
      console.log(eventId)
      // Find the event by ID
      const event = await Event.findById(eventId);
      console.log(event)
  
      if (!event) {
        return res.status(404).json({ message: 'Event not found' });
      }

      // Check if the participant is already added
      if (event.Participants.includes(member._id)) {
        return res.status(400).json({ message: 'Participant is already added to the event' });
      }
  
      // Add the participant to the Participants array
      await event.Participants.push(member);
  
      // Save the updated event
      const updatedEvent = await event.save();
  
      // Respond with the updated event
      res.status(200).json({ message: 'Participant added to the event', event: updatedEvent });
    } catch (error) {
     res.status(500).json({ message: 'Error adding participant to the event' });
    }}
  };
 // Import your Member model

export const RemoveParticipantFromEvent = async (req: Request, res: Response, next: NextFunction) => {
  const member=req.member
  if (member){
  try {
    const eventId = req.params.idEvent;
    const participantId = member._id;

    // Find the event by ID
    const event = await Event.findById(eventId);

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

    // Remove the participant from the Participants array
    event.Participants = event.Participants.filter((member) => !member._id.equals(participantId));

    // Save the updated event
    const updatedEvent = await event.save();

    // Respond with the updated event
    res.json({ message: 'Participant removed from the event', event: updatedEvent });
  } catch (error) {
     res.status(500).json({message:'Error removing participant from event:', error});
    next(error);
   } }
};
export const deleteEvent= async (req:Request, res:Response, next:NextFunction) => {
                           try {
                             const eventId = req.params.id;

                             // Check if the event exists
                             const event = await Event.findById(eventId);
                             if (!event) {
                               return res.status(404).json({ error: 'Event not found' });
                             }

                             // Delete the event
                             await event.deleteOne();

                             res.status(204).json({message:"deleted successully"}); // 204 No Content indicates a successful deletion
                           } catch (error) {
                             console.error('Error deleting event:', error);
                             next(error);
                           }
                         };