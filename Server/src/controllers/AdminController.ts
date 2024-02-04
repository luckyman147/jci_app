import { NextFunction, Request, Response } from "express";
import { CreateRoleInput } from "../dto/admin.dto";
import { Member } from "../models/Member";
import { Role } from "../models/role";
import { findrole } from "../utility/role";


//& find member
export  const FindMember=async(id:string |undefined ,email?:string)=>{
    if (email) {
        return await Member.findOne({email:email})

        
    }

    else{
        return await Member.findById(id)
    }
}


//TODO change role
export const changeRole=async( req:Request,res:Response,nex:NextFunction)=>{
const admin=req.user
if (admin){
 const   roleChanged=req.body
 const role=findrole(roleChanged)
}

}

//* get members

export const GetMembers=async( req:Request,res:Response,nex:NextFunction)=>{
    const admin=req.user
    if  (admin){

        const members=await Member.find().select(['email','firstName'])
        
        if(members){
            
            return res.json(members)
        }
        return res.json({"message":"data not available"})
    }
    }
    export const GetMemberById=async( req:Request,res:Response,nex:NextFunction)=>{
    const admin=req.user

        const id=req.params.id
        const memberById=await FindMember(id)
        if(memberById){
            return res.json(memberById)
        }
        return res.json({"message":"data not available"})
    }

//? create role
    export const createRole=async (req:Request,res:Response,next:NextFunction) => {
        const admin=req.user
        const {name,description}=<CreateRoleInput>req.body
        if  (admin){
        const newRole = await Role.create({ name: name,description:description});
        if (newRole) {
          return res.status(201).json(newRole);
        }
        return res.status(400).json({ message: "something went wrong" });
    }

    }
//find members by name
export const SearchByName = async (req: Request, res: Response)=>{
    const admin=req.user
    if  (admin){
    const name = req.params.name
    const result = await Member.find({name: name})
    if(result.length >0){
        let membersResult:any=[]
        result.map(item=>{
         
            membersResult.push(...item.firstName)
        })
     
          return res.status(200).json(membersResult)
     }
     return res.status(400).json({"message":" notfound"})
    }
}