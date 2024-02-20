import { Schema } from "mongoose";
import { Activity } from "./activitieModel";

export interface Event extends Activity {
  LeaderName:string

    registrationDeadline: Date;
  }
  export const EventSchema = new Schema<Event>({
    LeaderName: {
      type:String,
      required: true
    },
    
    registrationDeadline: { type: Date, required: true }
  });
  const Event = Activity.discriminator<Event>('Event', EventSchema);
  export { Event };  