
import { Request } from 'express';
import jwt from 'jsonwebtoken';
import { AuthPayload } from '../dto/auth.dto';
import { MemberPayload } from '../dto/member.dto';
import { Role } from '../models/role';
import { ADminPayload } from '../dto/admin.dto';
import { SuperAdminPayload } from '../dto/superAdmin.dto';
require('dotenv').config();


export const generateAccessToken = (payload: AuthPayload) => {
    // Ensure APP_SECRET is defined
    if (!process.env.APP_SECRET) {
      throw new Error('APP_SECRET environment variable is not defined');
    }
  
    const accessToken = jwt.sign(payload, process.env.APP_SECRET , {
      expiresIn: '1h',
    });
    
  
    return {
      accessToken,
      
    };
  };
  export const generateRefreshToken = (payload: AuthPayload) => {
    // Ensure APP_SECRET is defined
    if (!process.env.APP_SECRET) {
      throw new Error('APP_SECRET environment variable is not defined');
    }
  
    
    const refreshToken = jwt.sign(payload, process.env.APP_SECRET , {
      expiresIn: '1d',
    });
  
    return {
      refreshToken,
      
    };
  };
  
  
  export const validateSignature = async (req: Request) => {
    const signature = req.get('Authorization');
    if (signature) {
      const payload = jwt.verify(signature.split(' ')[1], process.env.APP_SECRET as string) as MemberPayload;
  
      req.user = payload;
      return true;
    }
    return false;
  };
  
  export const validateAdminSignature = async (req: Request) => {
    const signature = req.get('Authorization');
    if (signature) {
      const payload = jwt.verify(signature.split(' ')[1], process.env.APP_SECRET as string) as ADminPayload;
      const role= await Role.findById(payload.role)
      if (role?.name === 'admin') {
        req.user = payload;
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
      if (role?.name == 'superadmin') {
        req.user = payload;
        return true;
      }
    }
    return false;
  };
 export const  VerifyrefreshToken =async(refrecshToken:string)=>{
    const payload = jwt.verify(refrecshToken, process.env.APP_SECRET as string) as AuthPayload;
    
    const accessToken = generateAccessToken(payload)
return accessToken
 }