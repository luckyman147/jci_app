import mongoose, { Document, Schema } from "mongoose";

export interface CheckList extends Document{

    name: string
   
    Deadline: Date
    isCompleted:boolean

    
}
export const CheckListSchema=new Schema({
  
    name: { type: String, required: true },
    isCompleted:{type:Boolean,default:false},

    Deadline: { type: Date, default: Date.now },
    
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
   



const CheckList=mongoose.model<CheckList>('CheckList',CheckListSchema)
export { CheckList };

