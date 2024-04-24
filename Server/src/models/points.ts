import mongoose, { Schema } from "mongoose";

export interface test extends Document{

    filename:string;
    contentType:string;
    length:number
  chunkSize:number
    uploadDate:Date
}
export const testSchema=new Schema(
    {
        filename: { type: String, required: true },
        contentType: { type: String, required: true },
        length: { type: Number, required: true },
        chunkSize: { type: Number, default: 261120},
        uploadDate: { type: Date, default: Date.now },

    },
    {
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
   



const test=mongoose.model<test>('test',testSchema)
export { test };

