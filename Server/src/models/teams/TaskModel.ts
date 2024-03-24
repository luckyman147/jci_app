import { NextFunction } from "express";
import mongoose, { Document, Schema } from "mongoose";
import { CheckList } from "./CheckListModel";

export interface Task extends Document{

    name: string
    AssignTo:any[]
    StartDate: Date
    Deadline: Date
    attachedFile: any[]
    CheckList: any[]
    isCompleted:boolean
    description:string
    
}
export const TaskSchema=new Schema({
  
    name: { type: String, required: true },
    description:{type:String,default:""},
    AssignTo:[{type: mongoose.Schema.Types.ObjectId,
        ref: 'Member',
        default:[]

    
    }],
        isCompleted:{type:Boolean,default:false},
        StartDate : { type: Date, default: Date.now },
    Deadline  : { type: Date, default: 
         () => {
        const currentDate = new Date();
        currentDate.setDate(currentDate.getDate() + 1);
        return currentDate;
      } },
    attachedFile:[{type: mongoose.Schema.Types.ObjectId,
        ref: 'File',
        default:[]}],
    CheckList: [{ type: mongoose.Schema.Types.ObjectId,
        ref: 'CheckList',default:[]},
    
    ],

}




,{
    toJSON:{
        transform(doc,ret){
            delete ret.__v
            delete ret.createdAt
            delete ret.updatedAt
        }
    },
    
    timestamps:true
}





)


   



const Task=mongoose.model<Task>('Task',TaskSchema)
export { Task };

