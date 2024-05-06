import { Request, Response } from "express";
import nodemailer from "nodemailer";
import { transporter } from "../../config/mailer";
import { GenerateOtp, onRequestOTP, onRequestResetPasswordOTP, ReminderActivity, sendReportIncativity, sendReportmembership, sendTaskDeadlineOverdueEmail } from "../../utility/NotificationEmailUtility";
import { Member } from "../../models/Member";
import { Task } from "../../models/teams/TaskModel";
import { Activity } from "../../models/activities/activitieModel";
require('dotenv').config();


export const SendEmailVerificationCode=async(req: Request, res: Response)=> {

    const {email}=req.body
    // Email content
    const {otp,startDateUtc}=GenerateOtp()
    const isSent=await onRequestOTP(otp,email)
    if (isSent){
        req.otp=otp
        req.expiry=startDateUtc
        console.log("otp:",otp)
        res.status(200).json({message:'Email sent successfully',otp:otp,expiry:startDateUtc})
     
    }else{
        res.status(500).json({message:'Error sending email'})
    }
}

export const SendResetPasswordVerificationCode=async(req: Request, res: Response)=> {

    const {email}=req.body
const MemberInfo=await Member.findOne({email:email})
if (!MemberInfo){
    return res.status(404).json({message:'No user found with this email'})
}

    // Email content
    const {otp,startDateUtc}=GenerateOtp()
    const isSent=await onRequestResetPasswordOTP(otp,email)
    if (isSent){
        req.otp=otp
        req.expiry=startDateUtc
        console.log("otp:",otp)
        res.status(200).json({message:'Email sent successfully',otp:otp,expiry:startDateUtc})
     
    }else{
        res.status(500).json({message:'Error sending email'})
    }
}





export const reportMembershipEmail=async(req: Request, res: Response)=> {
    const {memberid}=req.params
    const member=await Member.findById(memberid)
    if(member){
    sendReportmembership(member.language,member.firstName,member.email)
    res.status(200).json({message:'Email sent'})
    }
}
export const reportInactivityEmail=async(req: Request, res: Response)=> {
    const {memberid}=req.params
    const member=await Member.findById(memberid)
    if(member){
    sendReportIncativity(member.language,member.firstName,member.email)
    res.status(200).json({message:'Email sent'})
    }
}

export const SendReportDeadlineTask=async (req:Request,res:Response)=>{
    const taskid= req.params
    const task=await Task.findById(taskid)
    if (task ){

        const members=await Member.find({ _id: { $in: task!.AssignTo } });
        if (members){
            members.forEach ((member)=>
             sendTaskDeadlineOverdueEmail(member.language,member.email,task.name)
            
            )
        }
       
    }
}
export const SendReminderActivity=async (req:Request,res:Response)=>{
    const {activityId}= req.params
    const activity=await Activity.findById(activityId)
    if (activity ){

        const members=await Member.find();
        if (members){
            members.forEach ((member)=>
             ReminderActivity(member.language,member.email,activity.name,activity.ActivityBeginDate,activity.ActivityAdress)
            
            )
        }
       return res.status(200).json("email sent succefully")
    }
}




export const  testEmail=async(req: Request, res: Response)=> {

const {email}=req.body
 // Email content
 let mailOptions: nodemailer.SendMailOptions = {
    from: process.env.EMAIL, // Sender address
    to: email, // List of recipients
    subject: "subject", // Subject line
    text: 'Hello, this is a test email!', // Plain text body
    html:  `
    
    <span style="color: red;">Hello</span>
    <p>This is a test email with HTML content.</p>
    <p><img src="C:\\Users\\Mytek\\Desktop\\projet\\jcI APP\\jci_app\\Server\\uploads\\Events\\1709224899629IMG_20240227_181811.jpg" alt="Image"></p>
    <p><button onclick="myFunction()">Click me</button></p>
  
`,
attachments: [
    {
        filename: '1709224899629IMG_20240227_181811.jpg', // Attachment filename
        path: 'https://github.com/luckyman147/jci_app/blob/78c8977adea6ac6137aef44b7f8628d3a32d47c1/Server/uploads/Events/1709224899629IMG_20240227_181811.jpg' // Path to your image file
    }
]
};

try {
    // Send email
    let info = await transporter.sendMail(mailOptions);
    res.status(200).json({ message: 'Email sent', info: info.response });
    console.log('Email sent:', info.response);
} catch (error) {
    console.error('Error occurred:', error);
}
}
