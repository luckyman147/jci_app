import mongoose, { Date, Schema } from "mongoose";
import { MemberDoc,MemberSchema } from "./Member";

interface AdminDoc extends MemberDoc {
Admin_validity:Date

  }
  const adminSchema = new Schema({
    // Add new properties here
  Admin_validity:{type:Date , require:true}
    // ...more properties
  });
  adminSchema.add({
   ...MemberSchema.obj

  })
  const Admin = mongoose.model<AdminDoc>(
    'AdmindMember',
    adminSchema
  );
export {Admin}
  
  