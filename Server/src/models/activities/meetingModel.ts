import { Schema } from "mongoose";
import { Activity } from "./activitieModel";

export interface Meeting extends Activity {
  Director:any
Duration:number
type:string


  }
  export const MeetingSchema = new Schema<Meeting>({
    Director: {
      type: Schema.Types.ObjectId,
      ref: 'Member',
      required: true
    },
    Duration: { type: Number, required: true },
    type:{type:String,required:true}
   
  });
  const Meeting = Activity.discriminator<Meeting>('Meeting', MeetingSchema);  

  export { Meeting };