import mongoose, { Document, Schema } from "mongoose";

export interface Activity extends Document{

    name:string;
    
    description:string;
    ActivityBeginDate:Date
    ActivityEndDate:Date
   ActivityAdress:string
    ActivityPoints:number
categorie:string
    IsPaid:boolean
    price:number
    Participants:any[]
    CoverImages:[string]
    
}
export const ActivitySchema=new Schema({
    name:{type:String,required:true},
    description:{type:String,required:true},
    ActivityBeginDate:{type:Date,required:true},
    ActivityEndDate:{type:Date},
    ActivityAdress:{type:String,
    default:"Local Menchia"
    },
    ActivityPoints:{type:Number},
 
    categorie:{type:String,required:true},
    IsPaid:{type:Boolean,default:false},
    Price:{type:Number,default:0},
    Participants: [{
        type: mongoose.Schema.Types.ObjectId,
        ref: 'Member',
        default:[]
      }],
    CoverImages:{type:[String],required:true}
},{
    toJSON:{
        transform(doc,ret){
            delete ret.ActivityPoints
            delete ret.__v
            delete ret.createdAt
            delete ret.updatedAt
        }
    },
    
    timestamps:true
})
   



const Activity=mongoose.model<Activity>('Activity',ActivitySchema)
export { Activity };

