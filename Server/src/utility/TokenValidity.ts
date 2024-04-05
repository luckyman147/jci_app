
import { Request } from 'express';
import jwt from 'jsonwebtoken';

import { ADminPayload } from '../dto/admin.dto';
import { EmailPayload, MemberPayload, } from '../dto/member.dto';
import { SuperAdminPayload } from '../dto/superAdmin.dto';
import { Member } from '../models/Member';
import { Role } from '../models/role';
import { isAccessTokenValid, isRefreshTokenValid } from './verification';

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
      const role= await Role.findById(payload.role)

      if (check &&(role?.name === 'member' || role?.name === 'admin' || role?.name === 'superadmin')){
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
    const signature = req.get('Authorization');
    if (signature) {
      const payload = jwt.verify(signature.split(' ')[1], process.env.APP_SECRET as string) as ADminPayload;
      const role= await Role.findById(payload.role)
      const check=await isAccessTokenValid(payload._id,signature)

      if ((role?.name === 'admin' || role?.name === 'superadmin')&& check) {
        req.admin = payload;
        return true;
      }
    }
    return false;
  };
  export const validateSuperAdminSignature = async (req: Request) => {
    const signature = req.get('Authorization');
    if (signature) {
      const payload = jwt.verify(signature.split(' ')[1], process.env.APP_SECRET as string) as SuperAdminPayload;
  
      const role= await Role.findById(payload.role)
      const check=await isAccessTokenValid(payload._id,signature)
      if (role?.name == 'superadmin' && check) {
        req.superadmin = payload;
        return true;
      }
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