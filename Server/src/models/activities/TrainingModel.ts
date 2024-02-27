import { Schema } from "mongoose";
import { Activity } from "./activitieModel";

export interface Training extends Activity {
  ProfesseurName:string
    Duration:number
    

   ;
  }
  export const TrainingSchema = new Schema<Training>({

    ProfesseurName:{type:String,required:true},
    Duration: { type: Number, required: true },
  
  });
  const Training = Activity.discriminator<Training>('Training', TrainingSchema);
  export { Training };  