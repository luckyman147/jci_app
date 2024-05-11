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
    Price:number
    Participants:any[]
    CoverImages:string[]

    guests:any[]
    
}
export const ActivitySchema=new Schema({
    name:{type:String,required:true},
    description:{type:String,required:true},
    ActivityBeginDate:{type:Date,required:true},
    ActivityEndDate:{type:Date},
    ActivityAdress:{type:String,
    default:"Local Menchia"
    },
    
    ActivityPoints:{type:Number,default:50},

    
      guests:[{
        guest: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'Guest',
        },
        status: {
        type: String,
        enum: ['pending', 'present', 'absent'],
        default: 'pending',
        },
      
      }],
    categorie:{type:String,required:true},
    IsPaid:{type:Boolean,default:false},
    Price:{type:Number,default:0},
    Participants: [{
        memberid: {
          type: mongoose.Schema.Types.ObjectId,
          ref: 'Member', // Reference to the Member model
       
        },
        status: {
          type: String,
          enum: ['pending', 'present', 'absent'],
          default: 'pending',
    
        }
      }],
    CoverImages:{type:[{type:String}],required:true}
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

