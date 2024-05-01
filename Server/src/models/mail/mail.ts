import mongoose, { Document, Schema } from "mongoose";

export interface Mail extends Document{

    Subject:string;
    
    description:string;

language:string
    
}
export const MailSchema=new Schema({
 
    Subject:{type:String,required:true},
    description:{type:String,required:true},
    language:{type:String,required:true}
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
   



const Mail=mongoose.model<Mail>('Mail',MailSchema)
export { Mail };

