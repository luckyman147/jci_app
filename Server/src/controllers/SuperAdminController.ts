import { NextFunction, Request, Response } from 'express';


import { Member } from '../models/Member';
import { findrole } from '../utility/role';

export const ChangeToAdmin=async(req:Request, res:Response,next:NextFunction)=>{
    const superAdmin=req. member
    if (superAdmin){
        const id=req.params.id
        const member = await Member.findById(id);


        if (!member) {
          return res.status(404).json({ error: 'Member not found' });
        }
        const role=await findrole('admin')
        member.role=role
        //Save
        role?.Members.push(member.id)
        const saved=await member.save()
        if (saved) {
            return res.status(201).json(saved);
            
            
        }
      

    

    }


}
