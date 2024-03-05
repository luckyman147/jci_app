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
const admin=req.member
if (admin){
 const   roleChanged=req.body
 const role=findrole(roleChanged)
}

}
export const ChangeToMember=async(req:Request, res:Response,next:NextFunction)=>{
    const Admin=req.member
    if (Admin){
        const id=req.params.id
        const member = await Member.findById(id);


        if (!member) {
          return res.status(404).json({ error: 'Member not found' });
        }
        const role=await findrole('member')
        member.role=role
        //Save
        role?.Members.push(member.id)
        const saved=await member.save()
        if (saved) {
            return res.status(201).json(saved);
            
            
        }
      

    

    }


}

//* get members

export const GetMembers=async( req:Request,res:Response,nex:NextFunction)=>{
    const admin=req.member
    if  (admin){

        const members=await Member.find().select(['email','firstName',"Images"])
        
        if(members){
            
            return res.json(members)
        }
        return res.json({"message":"data not available"})
    }
    }
    export const GetMemberById=async( req:Request,res:Response,nex:NextFunction)=>{
    const admin=req.member
    if (admin){


        const id=req.params.id
        const memberById=await FindMember(id)
        if(memberById){
            return res.json(memberById)
        }
        return res.json({"message":"data not available"})
    }}

//? create role
    export const createRole=async (req:Request,res:Response,next:NextFunction) => {
        const admin=req.member
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
export const searchByName = async (req: Request, res: Response,next:NextFunction)=>{
    const admin=req.member
    if  (admin){
    const firstName = req.params.name
    const result = await Member.find({ firstName: { $regex: new RegExp(firstName, 'i') } })
  .select(['email', 'firstName', 'Images']).sort({firstName:1});

    if(result.length >0){
       
     
          return res.status(200).json(result)
     }
     return res.status(400).json({"message":" notfound"})
    }
}