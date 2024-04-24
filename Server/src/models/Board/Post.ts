import mongoose, { Document, Schema } from "mongoose";

export interface Post extends Document{

   role:any
   Assignto:any[]
   year:string

    
}
export const PostSchema=new Schema({
  
   role:{type: mongoose.Schema.Types.ObjectId,
ref: 'BoardRole',
required:true
},

    Assignto:[{type: mongoose.Schema.Types.ObjectId,
        ref: 'Member',

    }]
    ,
    year:{type:String,required:true}

    
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
   



const Post=mongoose.model<Post>('Post',PostSchema)
export { Post };

