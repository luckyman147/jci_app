import mongoose, { Document, Schema } from "mongoose";

export interface MemberDoc extends Document{

    email:string;
    password:string;
    description:string;
    firstName:string
    lastName:string
    address:string;
    phone:string;
    refreshTokenRevoked:[string];
    accessTokenRevoked:[string]
    Activities:any[]
    Teams:any[]
    Points:number
    Permissions:any[]
    
Images:any[];
is_validated:boolean
cotisation:boolean[]
    salt:string
   role:any
}
export const MemberSchema=new Schema({
    email:{type:String,required:true},
    password:{type:String,required:true},
    salt:{type:String,required:true},
    description:{type:String},
    firstName:{type:String},
    lastName:{type:String},
    address:{type:String,},

    Points:{type:Number,default:0},
    phone:{type:String},
    is_validated:{type:Boolean},
    cotisation:{type:[Boolean],default:[false,false]},
    Permissions:{
        type:[Schema.Types.ObjectId],
        ref:"Permission",default:[]
    },
    Images:{type:[Schema.Types.ObjectId],ref:'File'},


    refreshTokenRevoked:{type:[String],default:[]},
    accessTokenRevoked  :{type:[String],default:[]},
    Activities:{
        type:[Schema.Types.ObjectId],
        ref:"Activity"
    },
    Teams:{
        type:[Schema.Types.ObjectId],ref:'Team'    
    },
    role: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'Role',
        
      }
 
},{
    toJSON:{
        transform(doc,ret){
            delete ret.password
            delete ret.salt
            delete ret.__v
     

            delete ret.createdAt
            delete ret.updatedAt
        }
    },
    
    timestamps:true
})
const Member=mongoose.model<MemberDoc>('Member',MemberSchema)
export { Member };

