import mongoose, { Schema } from "mongoose";

export interface ActivityMember extends Document{
    
    status:string
    member:any
}
const ActivityMemberSchema= new Schema({
    status: {
        type: String,
        enum: ['pending', 'present', 'absent'], // Enumerated values for status
        default: 'pending', // Default value set to 'pending'
        required: true
      },
      member:{
        type: mongoose.Schema.Types.ObjectId,
        ref: 'Member',
        default:[]
      }

})
const MemberActivity = mongoose.model<ActivityMember>('MemberActivity', ActivityMemberSchema);

module.exports = MemberActivity;