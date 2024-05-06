import mongoose, { Schema } from "mongoose"

export interface Guest extends Document{
    name:string
    email:string
    phone:string
    isConfirmed:boolean
}
export const GuestSchema=new Schema({
    name:{type:String,required:true},
    email:{type:String,required:true},
    phone:{type:String,required:true},
    isConfirmed:{type:Boolean,default:false}
})
const Guest=mongoose.model<Guest>('Guest',GuestSchema)
export {Guest}