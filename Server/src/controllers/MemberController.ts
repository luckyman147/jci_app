import { plainToClass } from 'class-transformer';
import { validate } from 'class-validator';
import { NextFunction, Request, Response } from 'express';


import { CreateMemberInputs, EditMemberProfileInputs, MemberLoginInputs } from '../dto/member.dto';
import { Member } from '../models/Member';


//& Verify email
export const MemberVerifyEmail= async(req:Request,res:Response,next:NextFunction)=>{
    const {email}=req.body
    const member=req.user
    if(member){
        const profile=await Member.findById(member?._id)
        // if(profile){
        //     if(profile.otp ===parseInt(otp) && profile.otp_expiry >= new Date()){
        //         profile.verified=true
        //        const updated= await profile.save()
        //         const signature=generateSignature(
                    
        //             {
        //             _id:updated._id,
        //             email:updated.email,
        //             verified:updated.verified
                
        //         })
                
        //         return res.status(200).json({message:'email verified',signature:signature,email:updated.email})
            
        //     }
        // }
        return  res.status(400).json({message:'something messed up'})
    }

}

export const GetmemberProfile= async(req:Request,res:Response,next:NextFunction)=>{

    const member=req.user
    if(member){
        const profile=await Member.findById(member?._id)
        if(profile){
            return res.status(200).json(profile)
        }
        return res.status(404).json({message:'member not found'})
    }
  
}
export const EditmemberProfile= async(req:Request,res:Response,next:NextFunction)=>{
    const member=req.user
    const profileinputs=plainToClass (EditMemberProfileInputs,req.body)
    const errors=await validate(profileinputs,{validationError:{target:false}})
    if(errors.length>0){
        return res.status(400).json(errors)
    }


    const {firstname,lastname,address,description}=profileinputs
    if(member){
        const profile=await Member.findById(member?._id)
        if(profile){
            const files=req.files as Express.Multer.File[]
            const images=files.map((file:Express.Multer.File)=>file.filename)
        profile.Images.push(...images)
           
            profile.firstName=firstname
            profile.lastName=lastname
            profile.address=address
            profile.description=description

            const updated=await profile.save()
            if(updated){
                return res.status(200).json({message:'profile updated'})
            }
            return res.status(400).json({message:'error with profile'})
        }
        return res.status(404).json({message:'member not found'})
    }
}


