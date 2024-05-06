
import { plainToClass } from 'class-transformer';
import { NextFunction, Request, Response } from 'express';

import { validate } from 'class-validator';
import { TrainingField, TrainingInputs } from '../../dto/activity.dto';
import { Member } from '../../models/Member';
import { Training } from '../../models/activities/TrainingModel';
import { getMembersInfo, getPermissionIdsByRelated } from '../../utility/role';
import { sendNewEventEmail } from '../../utility/NotificationEmailUtility';

//&Public


export const getAllTrainings = async (req: Request, res: Response, next: NextFunction) => {
  try {
    // Fetch all Trainings and sort them by ActivityBeginDate in ascending order
    const Trainings = await Training.find().sort({ ActivityBeginDate: -1 });
if (Trainings.length>0) {
  const permission=await getPermissionIdsByRelated(["Trainings"])

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
      price: Training.Price,
      IsPart:Training.Participants.some((member) => member._id.equals(req.body.id)),

      
      ActivityBegindate: Training.ActivityBeginDate,
      ActivityEnddate: Training.ActivityEndDate,
      ActivityAdress: Training.ActivityAdress,

 
      participants: Training.Participants,
      CoverImages: Training.CoverImages,
    }));

    res.status(200).json({        Permissions:permission,
      Trainings: formattedTrainings });}
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
        price: Training.Price,
       
       IsPart:Training.Participants.some((member) => member._id.equals(req.body.id)),
        
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
          price: Training.Price,
        
       IsPart:Training.Participants.some((member) => member._id.equals(req.body.id)),
          
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
      IsPaid: trainingInputs.IsPaid,
      ActivityPoints:trainingInputs.ActivityPoints,
  Price:trainingInputs.price, 
      Participants: [],
        ProfesseurName:trainingInputs.ProfesseurName,
        Duration:durationInMillis,



      
      
      
      CoverImages: [], // Convert images to base64
    });

    // Add the Training to the database
    const savedTraining = await newTraining.save();
    const members=await Member.find().select(["email","language"])
   
 
    members.forEach((member)=>{
    
      sendNewEventEmail(savedTraining.name,savedTraining.ActivityBeginDate,savedTraining.ActivityAdress,member.language,member.email,"training",[],savedTraining.ProfesseurName)
    })
    res.json(savedTraining);
  } catch (error) {
    console.error('Error adding Training:', error);
    next(error);
  }}

  export const updateTraining = async (req: Request, res: Response, next: NextFunction) => {
    try {
      const trainingId = req.params.id;
  
      // Find the existing training by ID
      const existingTraining = await Training.findById(trainingId);
  
      if (!existingTraining) {
        return res.status(404).json({ message: 'Training not found' });
      }
  
      // Extract data from the request body
      const trainingInputs = plainToClass(TrainingInputs, req.body);
  
      const errors = await validate(trainingInputs, { validationError: { target: true } });
      if (errors.length > 0) {
        return res.status(400).json({ message: 'Validation error', errors: errors[0].constraints });
      }
  
      const beginDate = new Date(trainingInputs.ActivityBeginDate);
      const endDate = new Date(trainingInputs.ActivityEndDate);
  
      // Check if ActivityEndDate is greater than ActivityBeginDate
      if (endDate.getTime() <= beginDate.getTime()) {
        return res.status(400).json({ message: 'ActivityEndDate must be greater than ActivityBeginDate' });
      }
  
      // Update the existing training properties
      existingTraining.name = trainingInputs.name;
      existingTraining.description = trainingInputs.description;
      existingTraining.ActivityBeginDate = trainingInputs.ActivityBeginDate;
      existingTraining.ActivityEndDate = trainingInputs.ActivityEndDate;
      existingTraining.ActivityAdress = trainingInputs.ActivityAdress;
      existingTraining.categorie = trainingInputs.categorie;
      existingTraining.IsPaid = trainingInputs.IsPaid;
      existingTraining.Price = trainingInputs.price;
      existingTraining.ActivityPoints = trainingInputs.ActivityPoints;
      existingTraining.ProfesseurName = trainingInputs.ProfesseurName;
      
      // Calculate and update the Duration
      const durationInMillis = endDate.getTime() - beginDate.getTime();
      existingTraining.Duration = durationInMillis;
  
      // Save the updated training
      const updatedTraining = await existingTraining.save();
  
      res.json(updatedTraining);
    } catch (error) {
      console.error('Error updating Training:', error);
      next(error);
    }
  };
  
export const getTrainingById = async (req: Request, res: Response, next: NextFunction) => {
  try {
  const Permissions=await getPermissionIdsByRelated(["Trainings"])

    const id = req.params.id;
    const training = await Training.findById(id);
    if (training) {
      res.status(200).json({
        _id: training._id,
        name: training.name,
          ProfesseurName:training.ProfesseurName,
          Duration:training.Duration,
            IsPart:training.Participants.some((member) => member._id.equals(req.body.id)),

  
        ActivityPoints: training.ActivityPoints,
        description: training.description,
        categorie: training.categorie,
        IsPaid: training.IsPaid,
        price: training.Price,
      
        
        ActivityBegindate: training.ActivityBeginDate,
        ActivityEnddate: training.ActivityEndDate,
        ActivityAdress: training.ActivityAdress,
   
        participants: await getMembersInfo(training.Participants.map(member=>member.memberid)),
        CoverImages: training.CoverImages,
        Permissions:Permissions

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
  export const updateImage = async (req: Request, res: Response, next: NextFunction) => {
    try {
      const trainingId = req.params.id;
      const training = await Training.findById(trainingId);
  
      if (!training) {
        return res.status(404).send("No such training");
      }
  
      const images: Express.Multer.File[] = req.files as Express.Multer.File[] || [];
  
      if (!images || images.length === 0) {
        return res.status(400).send("Invalid or missing image files");
      }
  
      // Convert images to base64
      const base64Images = images.map((image) => image.buffer.toString('base64'));
  
      // Update the existing images in the training
      training.CoverImages = base64Images;
  
      // Save the training
      const updatedTraining = await training.save();
  
      res.json(updatedTraining);
    } catch (error) {
      console.error('Error updating image:', error);
      next(error);
    }
  }
  
  
 // Import your Member model



