import mongoose, { Document, Schema } from "mongoose";

export interface Team extends Document{

    name:string;
    
    description:string;
  Event:any
TeamLeader:any
    Members:any[]
    CoverImage:any
    status:boolean
    tasks:any[]
    
}
export const TeamSchema=new Schema({
    name:{type:String,required:true},
    description:{type:String,required:true},
    status:{type:Boolean,default:true},
    
    
    TeamLeader:{
        type: mongoose.Schema.Types.ObjectId,
        ref: 'Member',

    },
Event:{
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Event',


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

