import mongoose, { Document, Schema } from "mongoose";

interface RoleDoc extends Document{

   name:string;
    description:string;
   Members:[any]
}
const RoleSchema=new Schema({
    name:{type:String,required:true},
    description:{
        type:String
    
    },
    Members: [{
        type: mongoose.Schema.Types.ObjectId,
        ref: 'Member'
      }]
 
})
const Role=mongoose.model<RoleDoc>('Role',RoleSchema)
export { Role };

