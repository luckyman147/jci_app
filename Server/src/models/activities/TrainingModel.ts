import { Schema } from "mongoose";
import { Activity } from "./activitieModel";

export interface Training extends Activity {
  ProfesseurName:String
    Duration:number
    ProfesseurCoverImage:String

   ;
  }
  export const TrainingSchema = new Schema<Training>({

    ProfesseurName:{type:String,required:true},
    Duration: { type: Number, required: true },
    ProfesseurCoverImage:{type:String,required:true}
  });
  const Training = Activity.discriminator<Training>('Training', TrainingSchema);
  export { Training };  