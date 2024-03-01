
import { plainToClass } from 'class-transformer';
import { NextFunction, Request, Response } from 'express';

import { validate } from 'class-validator';
import { TrainingField, TrainingInputs } from '../../dto/activity.dto';
import { Member } from '../../models/Member';
import { Training } from '../../models/activities/TrainingModel';

//&Public


export const getAllTrainings = async (req: Request, res: Response, next: NextFunction) => {
  try {
    // Fetch all Trainings and sort them by ActivityBeginDate in ascending order
    const Trainings = await Training.find().sort({ ActivityBeginDate: -1 });
if (Trainings.length>0) {
    // Format and send the Trainings in the response
    const formattedTrainings = Trainings.map<TrainingField>((Training) => ({
      _id: Training._id,
      name: Training.name,
      ProfesseurName:Training.ProfesseurName,
      Duration:Training.Duration,
      ActivityPoints: Training.ActivityPoints,
      description: Training.description,
      categorie: Training.categorie,
      IsPaid: Training.IsPaid,
      price: Training.price,

      
      ActivityBegindate: Training.ActivityBeginDate,
      ActivityEnddate: Training.ActivityEndDate,
      ActivityAdress: Training.ActivityAdress,

 
      participants: Training.Participants,
      CoverImages: Training.CoverImages,
    }));

    res.status(200).json({ Trainings: formattedTrainings });}
    else{
      res.status(400).json({message:"No Trainings found"})
    }
  } catch (error) {
    res.status(500).json({Error : error});

  }
};
export const GetTrainingsOfWeekend = async (req: Request, res: Response, next: NextFunction) => {
  try {
    const currentDate = new Date();
    const currentDay = currentDate.getDay();
    const firstDayOfWeekend = new Date(currentDate.getFullYear(), currentDate.getMonth(), currentDate.getDate() + (5 - currentDay));
    const lastDayOfWeekend = new Date(currentDate.getFullYear(), currentDate.getMonth(), currentDate.getDate() + (7 - currentDay));
console.log(firstDayOfWeekend)
console.log(lastDayOfWeekend)
console.log(currentDate)
    const TrainingsOfWeekend = await Training.find({
      ActivityBeginDate: { $gte: firstDayOfWeekend, $lte: lastDayOfWeekend },
    }).sort({ ActivityBeginDate: -1 });

    if (TrainingsOfWeekend.length > 0) {
      const formattedTrainings = TrainingsOfWeekend.map<TrainingField>((Training) => ({
        _id: Training._id,
        name: Training.name,
        ProfesseurName:Training.ProfesseurName,
        Duration:Training.Duration,
      
  
        ActivityPoints: Training.ActivityPoints,
        description: Training.description,
        categorie: Training.categorie,
        IsPaid: Training.IsPaid,
        price: Training.price,
       
        
        ActivityBegindate: Training.ActivityBeginDate,
        ActivityEnddate: Training.ActivityEndDate,
        ActivityAdress: Training.ActivityAdress,
   
        participants: Training.Participants,
        CoverImages: Training.CoverImages,
      }));
      res.status(200).json({ Trainings: formattedTrainings });
    } else {
      res.status(400).json({ message: "No Trainings found for this weekend" });
    }
  } catch (error) {
    console.log('Error retrieving Trainings of the weekend:', error);
    next(error);
  }
};
export const GetTrainingsOfMonth= async (req:Request,res:Response,next:NextFunction)=> {

    try {
        const currentDate = new Date();
      
        const lastDayOfMonth = new Date(currentDate.getFullYear(), currentDate.getMonth() + 1, 0);
    
        const TrainingsOfMonth = await Training.find({
          ActivityBeginDate: { $gte: currentDate },
        
        }).sort({ ActivityBeginDate: 1 }).limit(3);
     
    if (TrainingsOfMonth.length>0) {   
        const formattedTrainings = TrainingsOfMonth.map<TrainingField>((Training) => ({
          _id: Training._id,
          name: Training.name,
            ProfesseurName:Training.ProfesseurName,
            Duration:Training.Duration,
        

    
          ActivityPoints: Training.ActivityPoints,
          description: Training.description,
          categorie: Training.categorie,
          IsPaid: Training.IsPaid,
          price: Training.price,
        
          
          ActivityBegindate: Training.ActivityBeginDate,
          ActivityEnddate: Training.ActivityEndDate,
          ActivityAdress: Training.ActivityAdress,
     
          participants: Training.Participants,
          CoverImages: Training.CoverImages,

          }));
          console.log(formattedTrainings);
        res.status(200).json({ Trainings: formattedTrainings });
    
    }
    else{
        res.status(400).json({message:"No Trainings found for this month"})
    }
      } catch (error) {
        console.error('Error retrieving Trainings of the month:', error);
        next(error);
      }


}

//&Private

export const addTraining = async (req: Request, res: Response, next: NextFunction) => {
  try {
    // Extract data from the request body
    const trainingInputs=plainToClass(TrainingInputs,req.body)

    const errors= await validate(trainingInputs,{validationError:{target:true}})
if(errors.length>0){
    return res.status(400).json({message:'validation error',errors:errors[0].constraints})
console.log(errors)
}
const beginDate = new Date(trainingInputs.ActivityBeginDate);
const endDate = new Date(trainingInputs.ActivityEndDate);
console.log(beginDate, endDate)
const durationInMillis = endDate.getTime() - beginDate.getTime();
// Check if ActivityEndDate is greater than ActivityBeginDate
if (endDate.getTime() <= beginDate.getTime()) {
  return res.status(400).json({ message: 'ActivityEndDate must be greater than ActivityBeginDate' });
}
    // Create an Training document
    const newTraining = new Training({
      
      name: trainingInputs.name,
      description: trainingInputs.description,
      ActivityBeginDate: trainingInputs.ActivityBeginDate,
      ActivityEndDate: trainingInputs.ActivityEndDate,
      ActivityAdress: trainingInputs.ActivityAdress,
      
      categorie: trainingInputs.categorie,
      IsPaid: trainingInputs.IsPaid,price: trainingInputs.price,
      ActivityPoints:0,
     
      Participants: [],
        ProfesseurName:trainingInputs.ProfesseurName,
        Duration:durationInMillis,



      
      
      
      CoverImages: [], // Convert images to base64
    });

    // Add the Training to the database
    const savedTraining = await newTraining.save();

    res.json(savedTraining);
  } catch (error) {
    console.error('Error adding Training:', error);
    next(error);
  }}


export const getTrainingById = async (req: Request, res: Response, next: NextFunction) => {
  try {
    const id = req.params.id;
    const training = await Training.findById(id);
    if (training) {
      res.status(200).json({
        _id: training._id,
        name: training.name,
          ProfesseurName:training.ProfesseurName,
          Duration:training.Duration,
      

  
        ActivityPoints: training.ActivityPoints,
        description: training.description,
        categorie: training.categorie,
        IsPaid: training.IsPaid,
        price: training.price,
      
        
        ActivityBegindate: training.ActivityBeginDate,
        ActivityEnddate: training.ActivityEndDate,
        ActivityAdress: training.ActivityAdress,
   
        participants: training.Participants,
        CoverImages: training.CoverImages,

      });
    } else {
      res.status(404).json({ message: "No Training found with this id" });
    }
  } catch (error) {
    console.error('Error retrieving Training by id:', error);
    next(error);
  }
  
}
export const getTrainingByName = async (req: Request, res: Response, next: NextFunction) => {
  try {
    const name =req.params.name;
    const training = await Training.findOne
    ({name:name});
    if (training) {
      res.json(training);
    } else {
      res.status(404).json({ message: "No Training found with this name" });
    }
  } catch (error) {
    console.error('Error retrieving Training by name:', error);
    next(error);
  }

}
export const getTrainingByDate = async (req: Request, res: Response, next: NextFunction) => {
  try {
    const date = req.params.date;
    const training = await Training.findOne
    ({ActivityBeginDate:date});
    if (training) {
      res.json(training);
    } else {
      res.status(404).json({ message: "No Training found with this date" });
    }
  } catch (error) {
    console.error('Error retrieving Training by date:', error);
    next(error);
  }}


  export const uploadImage= async (req: Request, res: Response, next: NextFunction) => {
    try {
    const   id=req.params.id
      // Find the Training
      const training = await Training.findById(id);

      if (!training) return res.status(401).send("No such Training")
      const images: Express.Multer.File[] = req.files as Express.Multer.File[];
    if (!images || images.length === 0){
            console.log(images)

        return res.status(400).send("Invalid or missing image files");
      }
      // Convert images to base64
      const base64Images = images.map((image) => image.buffer.toString('base64'));
  
      // Add the images to the Training
      training.CoverImages.push(...base64Images);
  
      // Save the Training
      const savedTraining = await training.save();
  
      res.json(savedTraining);
    } catch (error) {
      console.error('Error uploading image:', error);
      next(error);
    }
  }
 
  export const AddParticipantToTraining = async (req: Request, res: Response, next: NextFunction) => {
    const member=req.member
    if (member){
    try {
      const TrainingId = req.params.idTraining;
   
  
      console.log(TrainingId)
      // Find the Training by ID
      const training = await Training.findById(TrainingId);
      console.log(training)
  
      if (!training) {
        return res.status(404).json({ message: 'Training not found' });
      }

      // Check if the participant is already added
      if (training.Participants.includes(member._id)) {
        return res.status(400).json({ message: 'Participant is already added to the Training' });
      }
  
      // Add the participant to the Participants array
      await training.Participants.push(member);
  
      // Save the updated Training
      const updatedTraining = await training.save();
  
      // Respond with the updated Training
      res.status(200).json({ message: 'Participant added to the Training', Training: updatedTraining });
    } catch (error) {
     res.status(500).json({ message: 'Error adding participant to the Training' });
    }}
  };
 // Import your Member model

export const RemoveParticipantFromTraining = async (req: Request, res: Response, next: NextFunction) => {
  const member=req.member
  if (member){
  try {
    const TrainingId = req.params.idTraining;
    const participantId = member._id;

    // Find the Training by ID
    const training = await Training.findById(TrainingId);

    if (!training) {
      return res.status(404).json({ message: 'Training not found' });
    }

    // Find the participant by ID
    const participant = await Member.findById(participantId);

    if (!participant) {
      return res.status(404).json({ message: 'Participant not found' });
    }

    // Check if the participant is added to the Training
    const isParticipantAdded = training.Participants.some((member) => member._id.equals(participantId));
 
    if (!isParticipantAdded) {
      return res.status(400).json({ message: 'Participant is not added to the Training' });
    }

    // Remove the participant from the Participants array
    training.Participants = training.Participants.filter((member) => !member._id.equals(participantId));

    // Save the updated Training
    const updatedTraining = await training.save();

    // Respond with the updated Training
    res.json({ message: 'Participant removed from the Training', Training: updatedTraining });
  } catch (error) {
     res.status(500).json({message:'Error removing participant from Training:', error});
    next(error);
   } }
};
export const deleteTrain= async (req:Request, res:Response, next:NextFunction) => {
                           try {
                             const TrainingId = req.params.id;

                             // Check if the event exists
                             const train = await Training.findById(TrainingId);
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
