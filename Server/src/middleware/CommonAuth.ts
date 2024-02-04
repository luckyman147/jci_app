import { NextFunction, Request, Response } from "express";
import { AuthPayload } from "../dto/auth.dto";
import { validateAdminSignature, validateSignature, validateSuperAdminSignature } from "../utility";



declare global{
    namespace Express {
        interface Request {
            user?: AuthPayload;
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
