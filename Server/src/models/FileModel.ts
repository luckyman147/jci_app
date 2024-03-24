import mongoose, { Schema } from "mongoose";

export interface File extends Document{

    url:string;
    path:string;
    extension:string;
    
    
    
    
}
export const FileSchema=new Schema({
    url:{type:String,required:true},
    path:{type:String,required:true},
    extension:{type:String,required:true}
    
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
   



const File=mongoose.model<File>('File',FileSchema)
export { File };

