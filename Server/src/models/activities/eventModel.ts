import mongoose, { Schema } from "mongoose";
import { Activity } from "./activitieModel";

export interface Event extends Activity {
  LeaderName:string

    registrationDeadline: Date;
    teams:any[]
  }
  export const EventSchema = new Schema<Event>({
    LeaderName: {
      type:String,
      required: true
    },
    
    registrationDeadline: { type: Date, required: true },
  teams:[{type: mongoose.Schema.Types.ObjectId,ref: 'Team',default:[]}]  
  });

  const Event = Activity.discriminator<Event>('Event', EventSchema);
  export { Event };  