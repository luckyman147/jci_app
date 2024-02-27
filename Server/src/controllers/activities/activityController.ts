import { NextFunction, Request, Response } from 'express';
import { Activity } from '../../models/activities/activitieModel';


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