import mongoose, { Schema } from "mongoose";

export interface Permission extends Document{

    name:string;
    description:string;
    related:string[]
     roles:any[]
    key:string;
    Members:any[]    
}
export const PermissionSchema=new Schema(
    {
        name:{type:String,required:true},
        description:{type:String},
        related:{type:[String],default:[],required:true},

        key:{type:String,required:true,unique:true},
        Members: [{
            type: mongoose.Schema.Types.ObjectId,
            ref: 'Member',default:[]
          }],
        roles:[{
            type: mongoose.Schema.Types.ObjectId,
            ref: 'Role',default:[]
          }]


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
   



const Permission=mongoose.model<Permission>('Permission',PermissionSchema)
export { Permission };

