import { plainToClass } from 'class-transformer';
import { validate } from 'class-validator';
import { NextFunction, Request, Response } from 'express';
import { CreateMemberInputs, MemberLoginGoogleInputs, MemberLoginInputs } from '../dto/member.dto';
import { createWorker, Worker } from 'tesseract.js';

import { TokenInput, forgetPasswordInputs } from '../dto/auth.dto';
import { Member } from '../models/Member';
import { GenerateSalt, HashPassword, ValidatePassword, VerifyrefreshToken, generateAccessToken, generateRefreshToken, revokeRefreshToken } from '../utility';
import { findrole, findroleByid, GetMemberPermission, getPermissionsKeys, getPublicPermissions } from '../utility/role';
import { sendNewMemberEmail } from '../utility/NotificationEmailUtility';

//**  Sign Up*/
export const MemberSignUp= async(req:Request,res:Response,next:NextFunction)=>{
const memberInputs=plainToClass(CreateMemberInputs,req.body)

const errors= await validate(memberInputs,{validationError:{target:true}})
if(errors.length>0){
console.log(errors)
    return res.status(400).json({message:'validation error',errors:errors[0].constraints})

}

    const {email,password,firstName,lastName,language}=memberInputs
    
    const existmember= await Member.findOne({email:email})
if (existmember !==null){
    return res.status(409).json({message:'A member exist the same '})

}
const role = await findrole('New Member')
console.log(role)
    const salt=await GenerateSalt()
    const UserPassword=await HashPassword(password,salt)
    const Permissions=await getPublicPermissions()
    const result=await Member.create({
        email:email,
        password:UserPassword,
        salt:salt,
        cotisation:[false,false],
        firstName:firstName,
        is_validated:false,
        adress:'',
        phone:'',
        language:language,

        lastName:lastName,
        role:role,
        Permissions:Permissions

    })
    if (result){
        if(role){
            role.Members.push(result.id)
            await role.save()

        }
        console.log(result.language)
        sendNewMemberEmail(result.language,result.firstName,result.email,false,"")
        console.log(result)
        return res.status(201).json({message:"sign up completed " })

        
}
console.log('something')
return res.status(500).json({message:'something went wrong'})

}


//!Member login
export const MemberLogin= async(req:Request,res:Response,next:NextFunction)=>{
    const loginInputs=plainToClass(MemberLoginInputs,req.body)
    const errors=await validate(loginInputs,{validationError:{target:false}})
    if(errors.length>0){
        return res.status(400).json({message:'validation error'})
    }
    const {email,password}=loginInputs
    let MemberInfo =await Member.findOne({email:email})
    if(MemberInfo){
       const validate=await ValidatePassword(password,MemberInfo.password,MemberInfo.salt)
         if(validate){
          const {accessToken}=
        await  generateAccessToken({
                _id:MemberInfo._id,
                email:MemberInfo.email,
                role:MemberInfo.role._id,
                
                
          
          }) 
          const {refreshToken}=
          await generateRefreshToken({
            _id:MemberInfo._id,
          
         
               
                email:MemberInfo.email,
             
                

          })
        console.log("login")
          return res.status(200).json({refreshToken:refreshToken,accessToken:accessToken,email:MemberInfo.email,role:await findroleByid(MemberInfo.role._id),
            Permissions: await getPermissionsKeys(
            MemberInfo.Permissions,MemberInfo.role)})
         }
         else{
                return res.status(400).json({message:'Invalid credentials'})
            
         }
    }
    return res.status(404).json({message:'Not Found'})
}
//& logout 

export const logout = async (req: Request, res: Response, next: NextFunction) => {
    const signature = req.get('Authorization')?.split(' ')[1];
    const member=req.member

    try {
      const {refreshToken} = req.body;
  
   
  
  if (member && signature){

   const respnse=   await revokeRefreshToken(member?.email,member?._id, refreshToken,signature);

      res.status(200).json(respnse);
  }
  else{
    res.status(400).json({ message: "You are not logged in"});
  }
      // Revoke the refresh token
  
      
    } catch (error) {
      console.error('Error during logout:', error);
      res.status(500).json({ message: 'Internal server error' });
    }
  };
  
//* refreh token
export const RefreshTokenAccess=async(req:Request,res:Response,next:NextFunction)=>{
 
    const refreshTokenInput=req.get('Authorization')?.split(' ')[1];
    if (refreshTokenInput == null) return res.sendStatus(401).json('no token found')
  
    const accessTokenOrError= await VerifyrefreshToken(refreshTokenInput);
  console.log(accessTokenOrError)
  if (accessTokenOrError?.accessToken.toString().length>0){
    return res.status(200).json(accessTokenOrError)

    }
    else{
        return res.status(400).json(accessTokenOrError)
    }

}


export const AccessTokenAccess=async(req:Request,res:Response,next:NextFunction)=>{

}
export const getRole=async(req:Request,res:Response,next:NextFunction)=>{

}
export const verifyexpiry=async(req:Request,res:Response,next:NextFunction)=>{

}
export  const forgetPassword=async(req:Request,res:Response,next:NextFunction)=>{ 

const NewCred=plainToClass(forgetPasswordInputs,req.body)
    const errors=await validate(NewCred,{validationError:{target:false}})
    if(errors.length>0){
        console.log(errors)
        return res.status(401).json(errors)
    }


// send email to the user with reset password link
// let code=generate_code();
let status=200
const ischanged=await Changepassword(NewCred.email,NewCred.password)
if (ischanged) {

    console.log('password changed')
    return res.status(status).json({message:"password changed"})
}
else{
    console.log('password not changed')
    return res.status(400).json({message:"Something missed"})

}


}

export const Changepassword=async(email:string,password:string)=>{
    const member=await Member.findOne({email:email})
    try{
    if(member){
        
    const UserPassword=await HashPassword(password,member.salt)

        member.password=UserPassword
       await member.save()
    }
    return true
}
catch(err){
    return false
}

 }
 export const LoginWithGoogl=async(req:Request,res:Response)=>{
    const loginInputs=plainToClass(MemberLoginGoogleInputs,req.body)
    const errors=await validate(loginInputs,{validationError:{target:false}})
    if(errors.length>0){
        return res.status(400).json({message:'validation error'})
    }
    const {email}=loginInputs
    let MemberInfo =await Member.findOne({email:email})
    if(MemberInfo){
          const {accessToken}=
        await  generateAccessToken({
                _id:MemberInfo._id,
                email:MemberInfo.email,
                role:MemberInfo.role._id,
                
                
          
          }) 
          const {refreshToken}=
          await generateRefreshToken({
            _id:MemberInfo._id,
          
         
               
                email:MemberInfo.email,
             
                

          })
          sendNewMemberEmail(MemberInfo.language,MemberInfo.firstName,MemberInfo.email,false,"")
          return res.status(200).json({refreshToken:refreshToken,accessToken:accessToken,email:MemberInfo.email,role:await findroleByid(MemberInfo.role._id),
           status:'logged' ,Permissions: await getPermissionsKeys(
            MemberInfo.Permissions,MemberInfo.role)})
         }
         else{
                return res.status(400).json({message:'Invalid credentials',status:'NTR'})
            
            
         }
    
  
        }
 
export const MemberGoogleLoginSignUp= async(req:Request,res:Response,next:NextFunction)=>{
            const memberInputs=plainToClass(CreateMemberInputs,req.body)
            
            const errors= await validate(memberInputs,{validationError:{target:true}})
            if(errors.length>0){
            console.log(errors)
                return res.status(400).json({message:'validation error',errors:errors[0].constraints})
            
            }
            
                const {email,password,firstName,lastName,language}=memberInputs
                
                const existmember= await Member.findOne({email:email})
            if (existmember !==null){
                return res.status(409).json({message:'A member exist the same '})
            
            }
            const role = await findrole('New Member')
            console.log(role)
                const salt=await GenerateSalt()
                const UserPassword=await HashPassword(password,salt)
                const Permissions=await getPublicPermissions()
                const result=await Member.create({
                    email:email,
                    password:UserPassword,
                    salt:salt,
                    cotisation:[false,false],
                    firstName:firstName,
                    is_validated:false,
                    adress:'',
                    phone:'',
                    language:language,
            
                    lastName:lastName,
                    role:role,
                    Permissions:Permissions
            
                })
                if (result){
                    if(role){
                        role.Members.push(result.id)
                        await role.save()
            
                    }
                    const {accessToken}=
        await  generateAccessToken({
                _id:result._id,
                email:result.email,
                role:result.role._id,
                
                
          
          }) 
          const {refreshToken}=
          await generateRefreshToken({
            _id:result._id,
          
         
               
                email:result.email,
             
                

          })
          sendNewMemberEmail(result.language,result.firstName,result.email,false,"")
          return res.status(201).json({refreshToken:refreshToken,accessToken:accessToken,email:result.email,role:await findroleByid(result.role._id),
           status:'logged' ,Permissions: await getPermissionsKeys(
            result.Permissions,result.role)})

            
                    
            }
            console.log('something')
            return res.status(500).json({message:'something went wrong'})
            
            }

            