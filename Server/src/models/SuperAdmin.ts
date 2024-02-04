import mongoose, { Date, Schema } from "mongoose";
import { MemberDoc,MemberSchema } from "./Member";

interface SuperAdminDoc extends MemberDoc {
SuperAdmin_validity:Date
pincard:number

  }
  const SuperadminSchema = new Schema({
    // Add new properties here
  SuperAdmin_validity:{type:Date , require:true},
  pincard:{
    type : Number,
    unique:true,require:true
  }
    // ...more properties
  });
  SuperadminSchema.add({
   ...MemberSchema.obj

  })
  const SuperAdmin = mongoose.model<SuperAdminDoc>(
    'SuperAdmindMember',
    SuperadminSchema
  );
export {SuperAdmin}
  