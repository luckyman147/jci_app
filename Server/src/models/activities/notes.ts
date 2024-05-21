import mongoose, { Schema } from "mongoose";

export interface notes extends Document{
    title:string;
    content:string;
    date:Date;
    owner:any
}
export const notesSchema=new Schema({
    title:{type:String,required:true},
    content:{type:String,required:true},
    date:{type:Date,required:true},
    owner:{type:Schema.Types.ObjectId,ref:'Member'}
},
{
    toJSON:{
        transform:(_doc,ret)=>{
            delete ret.createdAt
            delete ret.updatedAt
            delete ret.__v
        }
    },
    timestamps:true}



)
export const notes=mongoose.model('notes',notesSchema)