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
    
    
Images:[string];
is_validated:boolean
cotisation:[boolean]
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
    phone:{type:String},
    is_validated:{type:Boolean},
    cotisation:{type:[Boolean]},
    Images:{type:[String]},
    refreshTokenRevoked:{type:[String],default:[]},
    accessTokenRevoked  :{type:[String],default:[]},
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

