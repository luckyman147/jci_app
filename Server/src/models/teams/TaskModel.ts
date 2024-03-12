import mongoose, { Document, Schema } from "mongoose";

export interface Task extends Document{

    name: string
    AssignTo:any
    Deadline: Date
    attachedFile: String
    CheckList: any[]
    isCompleted:boolean
    
}
export const TaskSchema=new Schema({
  
    name: { type: String, required: true },
    AssignTo:{type: mongoose.Schema.Types.ObjectId,
        ref: 'Member',
        required:true},
        isCompleted:[{type:Boolean,default:false}],
    Deadline: { type: Date, default: Date.now },
    attachedFile: { type: String },
    CheckList: [{ type: mongoose.Schema.Types.ObjectId,
        ref: 'CheckList',}],
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
   



const Task=mongoose.model<Task>('Task',TaskSchema)
export { Task };

