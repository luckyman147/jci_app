import { NextFunction, Request, Response } from "express";
import { adminsPayload, AuthPayload } from "../dto/auth.dto";
import { validateAdminSignature, validateSignature, validateSuperAdminSignature } from "../utility";
import { ADminPayload } from "../dto/admin.dto";
import { SuperAdminPayload } from "../dto/superAdmin.dto";
import { Server } from "socket.io";



declare global{
    namespace Express {
        interface Request {
            member: AuthPayload;
            admin:adminsPayload;
            superadmin:SuperAdminPayload;
            otp:number
            expiry:Date,
            io:Server
        }
        interface database{
            gfs:any
        }
        interface Verify{
            otp:string
        }
    }
   
}
export const Authenticate=async (req:Request,res:Response,next:NextFunction)=>{
    const validate=await validateSignature(req)

    if(validate){
    next()
    }
    else{
        res.status(401).json({
            message:"Unauthorized"
        })
    }

}

export const AuthenticateAdmin=async (req:Request,res:Response,next:NextFunction)=>{
  
    const validate=await validateAdminSignature(req)
    console.log(validate)

    if(validate){
        next()
    }
    else{
        res.status(401).json({
            message:"Unauthorized"
        })
    }

}

export const AuthenticateSuperAdmin=async (req:Request,res:Response,next:NextFunction)=>{
    const validate=await validateSuperAdminSignature(req)
    if(validate){
        next()
    }
    else{
        res.status(401).json({
            message:"Unauthorized"
        })
    }

}
