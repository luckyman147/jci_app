import mongoose, { Schema } from "mongoose";
import { Activity } from "./activitieModel";

export interface Event extends Activity {
  LeaderName:string

    registrationDeadline: Date;
    teams:any[]
    Permissions:any[]
  }
  export const EventSchema = new Schema<Event>({
    LeaderName: {
      type:String,
      required: true
    },
    Permissions:[{type: mongoose.Schema.Types.ObjectId,ref: 'Permission',default:[]}],
    
    registrationDeadline: { type: Date, required: true },
  teams:[{type: mongoose.Schema.Types.ObjectId,ref: 'Team',default:[]}]  
  });

  const Event = Activity.discriminator<Event>('Event', EventSchema);
  export { Event };  