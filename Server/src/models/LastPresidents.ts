import mongoose, { Schema,Document } from "mongoose";

export interface LastPresident extends Document{
    name:string;
  year:string;
  CoverImage:string;
}
export const LastPresidentSchema=new Schema({
    name:{type:String,required:true},
    year:{type:String,required:true},
    CoverImage:{type:String,default:""}
},{
    timestamps:true
})
export const LastPresidents=mongoose.model<LastPresident>('LastPresident',LastPresidentSchema)
