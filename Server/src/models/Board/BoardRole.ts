import mongoose, { Document, Schema } from "mongoose";

export interface BoardRole extends Document{

    name: string
   priority:number


    
}
export const BoardRoleSchema=new Schema({
  
    name: { type: String, required: true },
    priority:{type:Number,default:0,required:true},

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
   



const BoardRole=mongoose.model<BoardRole>('BoardRole',BoardRoleSchema)
export { BoardRole };

