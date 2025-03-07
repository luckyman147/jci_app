
import { Request } from 'express';
import jwt from 'jsonwebtoken';

import { ADminPayload } from '../dto/admin.dto';
import { EmailPayload, MemberPayload, } from '../dto/member.dto';
import { SuperAdminPayload } from '../dto/superAdmin.dto';
import { Member } from '../models/Member';
import { Role } from '../models/role';
import { isAccessTokenValid, isRefreshTokenValid } from './verification';
import { adminsPayload, AuthPayload } from '../dto/auth.dto';

require('dotenv').config();


export const generateAccessToken =async (payload: MemberPayload) => {
    // Ensure APP_SECRET is defined
    if (!process.env.APP_SECRET) {
      throw new Error('APP_SECRET environment variable is not defined');
    }
  
    const accessToken = jwt.sign(payload , process.env.APP_SECRET , {
      expiresIn: '20h',
    });
    if (!await isAccessTokenValid(payload._id,accessToken)){
     await generateAccessToken(payload)
    }
    
  
    return {
      accessToken
      
    };
  };
  export const generateRefreshToken = async (payload: EmailPayload) => {
    // Ensure APP_SECRET is defined
    if (!process.env.APP_SECRET) {
      throw new Error('APP_SECRET environment variable is not defined');
    }
  
    
    const refreshToken = jwt.sign(payload, process.env.APP_SECRET , {
      expiresIn: '1d',
    });
    if (!await isRefreshTokenValid(payload.email,refreshToken)){
const member=await Member.findOne({email:payload.email})
if (member){
await generateAccessToken({
  _id:member._id,
  email:member.email,
  role:member.role
})
}
}


    
  
    return {
      refreshToken
      
    };}

  
  
  export const validateSignature = async (req: Request) => {   
     if (!process.env.APP_SECRET) {
    throw new Error('APP_SECRET environment variable is not defined');
  }
    const signature = req.get('Authorization');
    

    if (signature) {
    try{
    const payload = jwt.verify(signature.split(' ')[1], process.env.APP_SECRET as string) as MemberPayload;
          const check=await isAccessTokenValid(payload._id,signature)
          console.log("check",check)


      if (check ){
        req.member = payload;
          return true;
      }return false 
    }
    catch{
      console.log('error')
    }

     
    }
    return false;
  };
  
  export const validateAdminSignature = async (req: Request) => {
    try{
    const signature = req.get('Authorization');
    if (signature) {
    console.log('signature',signature)
      const payload = jwt.verify(signature.split(' ')[1], process.env.APP_SECRET as string) as adminsPayload;
        console.log('payload',payload)




        req.member = payload;

        return true;
    }
    return false;}
    catch(e){
      console.log(e)
    }
  };
  export const validateSuperAdminSignature = async (req: Request) => {
    const signature = req.get('Authorization');
    if (signature) {
      const payload = jwt.verify(signature.split(' ')[1], process.env.APP_SECRET as string) as SuperAdminPayload;


        req.superadmin = payload;
        return true;

    }
    return false;
  };
  export const generateSecureKey = () => {
    const characters = process.env.APP_SECRET as string;
    let key = '';
    for (let i = 0; i < 5; i++) {
        const randomIndex = Math.floor(Math.random() * characters.length);
        key += characters.charAt(randomIndex);
    }
    return key;
}