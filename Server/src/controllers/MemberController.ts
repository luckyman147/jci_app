import { plainToClass } from 'class-transformer';
import { validate } from 'class-validator';
import { NextFunction, Request, Response } from 'express';

import { File } from "../models/FileModel";

import { EditMemberProfileInputs } from '../dto/member.dto';
import { Member } from '../models/Member';
import { findroleByid, getActivitiesInfo, getFilesInfoByIds, getMeetingsInfo, getteamsInfo, getTrainingInfo } from '../utility/role';
import path from 'path';
import { CheckObjectif } from '../utility/objectifcheck';


//& Verify email
export const MemberVerifyEmail= async(req:Request,res:Response,next:NextFunction)=>{
    const {email}=req.body
    const member=req.member
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

    const member=req.member
    if(member){
        const profile=await Member.findById(member?._id)
        if(profile){
            const [role, teamsInfo, activitiesInfo, trainingsinfo,meetingsInfo,FilesInfo,objectifs] = await Promise.all([
                findroleByid(profile.role),
                getteamsInfo(profile.Teams),
                getActivitiesInfo(profile.Activities),getTrainingInfo(profile.Activities),
                getMeetingsInfo(profile.Activities),getFilesInfoByIds(profile.Images),CheckObjectif(profile.id)
            ]);

            const info = {      teams: teamsInfo,  Activities: [{"Events" : activitiesInfo,"Trainings":trainingsinfo,"Meetings":meetingsInfo}],
                id: profile.id,
                firstName: profile.firstName,
                lastName: profile.lastName,
                Images: FilesInfo,
                phone: profile.phone,
                email: profile.email,
                cotisation: profile.cotisation,
                role: role,
                points: profile.Points,
                is_validated: profile.is_validated,

                objectifs:objectifs
            
            };

            console.log(info)
            return res.status(200).json(info)
        }
        return res.status(404).json({message:'member not found'})
    }
  
}
export const EditmemberProfile= async(req:Request,res:Response,next:NextFunction)=>{
    const member=req.member
    const profileinputs=plainToClass (EditMemberProfileInputs,req.body)
    const errors=await validate(profileinputs,{validationError:{target:false}})
    if(errors.length>0){
    console.log(errors)
        return res.status(400).json(errors)
    }


    const {firstName,lastName,phone}=profileinputs
    if(member){
        const profile=await Member.findById(member?._id)
if (profile){
            profile.firstName=firstName
            profile.lastName=lastName
            profile.phone=phone


            const updated=await profile.save()
            if(updated){
                return res.status(200).json({message:'profile updated'})
            }
            return res.status(400).json({message:'error with profile'})
        }
        return res.status(404).json({message:'member not found'})
    }
}

export const updateImageProfile = async (req: Request, res: Response, next: NextFunction) => {
      const member=req.params.id 
      try {
   
      const user = await Member.findById(member);
  
      if (!user) {
      console.log('no user')
        return res.status(404).send("No such user");
      }
  
      const image = req.file as Express.Multer.File;
      const fileExtension = path.extname(image.originalname);
    
      const founded= await File
      .findOne({ path: image.originalname })
 
     if (!founded) {
       // Convert the file to a base64 string
       const base64File = image.buffer.toString('base64');
       const file=new File({
         path: image.originalname ,
         url:base64File,
         extension:fileExtension,
 
       })
      // Convert the image to base64
    await file.save()
  
      // Add the image to the team
      user.Images = [file._id]
  
      // Save the team
      const saveduser = await user.save();
  
      res.status(200).json(saveduser);
    }
    else{
        
       
          user.Images = [founded._id]
      const saveduser = await user.save();
          
          res.status(200).json(saveduser);
        
      }


} catch (error) {
        console.log(error);
      res.status(500).json({ error: "errrr"});
    }
}
