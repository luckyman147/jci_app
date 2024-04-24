import mongoose, { Schema } from "mongoose"

export interface Board extends Document{

    year: string
Posts:any[]


    
}
export const BoardSchema=new Schema({
  
    year: { type: String, required: true },
    Posts:[{type: mongoose.Schema.Types.ObjectId,
        ref: 'Post',
        default:[]
    }]
    

    
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

const Board=mongoose.model<Board>('Board',BoardSchema)
export { Board };

