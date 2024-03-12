import mongoose, { Document, Schema } from "mongoose";

export interface Team extends Document{

    name:string;
    
    description:string;
  Event:any

    Members:any[]
    CoverImage:any
    tasks:any[]
    
}
export const TeamSchema=new Schema({
    name:{type:String,required:true},
    description:{type:String,required:true},
Event:{
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Event',
    required:true
},
    Members: [{
        type: mongoose.Schema.Types.ObjectId,
        ref: 'Member',
        default:[]
      }],
    tasks: [{
        type: mongoose.Schema.Types.ObjectId,
        ref: 'Task',
        default:[]
      }],
    CoverImage:{type:String}
},{
    toJSON:{
        transform(doc,ret){
            delete ret.__v
            delete ret.createdAt
            delete ret.updatedAt
        }
    },
    
    timestamps:true
})
   



const team=mongoose.model<Team>('Team',TeamSchema)
export { team };

