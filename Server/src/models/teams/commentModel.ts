import mongoose, { Schema,Document } from "mongoose"

export interface Comment extends Document{
    comment:string
    TaskId:any
    MemberId:any
    Created_At:Date
    Updated_At:Date
 
    
}
export const CommentSchema=new Schema({
    comment:{type:String,required:true},
    TaskId:{type:mongoose.Schema.Types.ObjectId,ref:'Task',required:true},
    MemberId:{type:mongoose.Schema.Types.ObjectId,ref:'Member',required:true},
    Created_At:{type:Date,default:Date.now()},
    Updated_At:{type:Date,default:Date.now()}

    
},{
    toJSON:{
        transform(doc,ret){
            delete ret.__v
            
          
        }
    },
    
    timestamps:true
})
const Comment=mongoose.model<Comment>('Comment',CommentSchema)
export { Comment };