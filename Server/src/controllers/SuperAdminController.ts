import { NextFunction, Request, Response } from 'express';

import { validate } from "class-validator";

import { plainToClass } from 'class-transformer';
import { PermissionInput, PresidentsInut } from '../dto/superAdmin.dto';
import { LastPresidents } from '../models/LastPresidents';
import { Member } from '../models/Member';
import { Permission } from '../models/Pemission';
import { Role } from '../models/role';
import { generateSecureKey } from '../utility';
import { findrole } from '../utility/role';
import { test } from '../models/points';

export const ChangeToAdmin=async(req:Request, res:Response,next:NextFunction)=>{
    const superAdmin=req. superadmin
   
        const id=req.params.id
        const member = await Member.findById(id);

const permissions = await Permission.find({ related: { $in: ["Meetings","Events","Trainings","Teams"] } });
        if (!member) {
          return res.status(404).json({ error: 'Member not found' });
        }
        const role=await findrole('admin')
        const memberrole=await Role.findById(member.role)
        if (memberrole){
            memberrole.Members=memberrole.Members.filter(memberid=>memberid!=member.id)
            await memberrole.save()
        }
        member.role=role
        member.cotisation=[true,true]
        member.Permissions=permissions.map(permission=>permission.id)
        member.is_validated=true
        member.Points+=1000
        //Save
        role?.Members.push(member.id)
        const saved=await member.save()
        if (saved) {
            return res.status(201).json(saved);
            
            
        }
}
export const ChangeToSuperAdmin=async(req:Request, res:Response,next:NextFunction)=>{
    const superAdmin=req. superadmin
   
        const id=req.params.id
        const member = await Member.findById(id);

const permissions = await Permission.find();
        if (!member) {
          return res.status(404).json({ error: 'Member not found' });
        }
        const role=await findrole('superadmin')
        const memberrole=await Role.findById(member.role)
        if (memberrole){
            memberrole.Members=memberrole.Members.filter(memberid=>memberid!=member.id)
            await memberrole.save()
        }
        member.role=role
        member.cotisation=[true,true]
        member.Permissions=permissions.map(permission=>permission.id)
        member.is_validated=true
        member.Points+=2000
        //Save
        role?.Members.push(member.id)
        const saved=await member.save()
        if (saved) {
            return res.status(201).json(saved);
            
            
        }
}
export const ChangeToMember=async(req:Request, res:Response,next:NextFunction)=>{
    const superAdmin=req. superadmin
   
        const id=req.params.id
        const member = await Member.findById(id);

const permissions = await Permission.find({isPublic:true});
        if (!member) {
          return res.status(404).json({ error: 'Member not found' });
        }
        const role=await findrole('member')
        const memberrole=await Role.findById(member.role)
        if (memberrole){
            memberrole.Members=memberrole.Members.filter(memberid=>memberid!=member.id)
            await memberrole.save()
        }
        member.role=role
        
        member.Permissions=permissions.map(permission=>permission.id)
  
        //Save
        role?.Members.push(member.id)
        const saved=await member.save()
        if (saved) {
            return res.status(201).json(saved);
            
            
        }
}


export const CreatePermission = async (req: Request, res: Response, next: NextFunction) => {
    const superAdmin = req.superadmin;
    console.log(superAdmin)
    try {
        const PermissionInputs = plainToClass(PermissionInput, req.body);
        const errors = await validate(PermissionInputs, { validationError: { target: false } });
        if (errors.length > 0) {
            return res.status(400).json({ message: 'Input validation failed', errors });
        }
        const { name, description, related,roles,isPublic} = PermissionInputs;

        // Check if the request contains permission ID for update
        const permissionId = req.params.id;

        // Check if permission name already exists
        const existingPermission = await Permission.findOne({ name });
        if (existingPermission) {
            return res.status(400).json({ message: 'Permission with the same name already exists' });
        }

        // If permission ID exists, update the permission

            const secureKey =  generateSecureKey();
            // Otherwise, create a new permission
            const permission = new Permission({
                name,
                related,
           key:     secureKey,
           roles:roles,
               isPublic : isPublic
          

            });
const admin=await Member.findById(superAdmin._id)
admin?.Permissions.push(permission.id)
await admin!.save()
permission.Members.push(admin!.id)
permission.roles.push(admin!.role)
            const saved = await permission.save();
            if (saved) {
                return res.status(201).json(saved);
            }
            return res.status(400).json({ message: 'Error creating permission' });
        
    } catch (error) {
        console.log(error);
        return res.status(500).json({ message: 'Error with permission' });
    }
}

export const UpdatePermission = async (req: Request, res: Response, next: NextFunction) => {
    // Call CreatePermission function with the permission ID in the URL
    const superAdmin = req.superadmin;
    try {
        const PermissionInputs = plainToClass(PermissionInput, req.body);
        const errors = await validate(PermissionInputs, { validationError: { target: false } });
        if (errors.length > 0) {
            return res.status(400).json({ message: 'Input validation failed', errors });
        }
        const { name, description, related,roles,Members } = PermissionInputs;

        // Check if the request contains permission ID
        const permissionId = req.params.id;

        // Check if permission with given ID exists
        const existingPermission = await Permission.findById(permissionId);
        if (!existingPermission) {
            return res.status(404).json({ message: 'Permission not found' });
        }

        // Check if the updated name conflicts with other permissions
        const otherPermissionWithSameName = await Permission.findOne({ name, _id: { $ne: permissionId } });
        if (otherPermissionWithSameName) {
            return res.status(400).json({ message: 'Another permission with the same name already exists' });
        }

        // Update the permission
        existingPermission.name = name;
        existingPermission.description = description;
        existingPermission.related = related;
        existingPermission.roles = roles,
        existingPermission.Members=Members

        const updatedPermission = await existingPermission.save();
        return res.status(200).json(updatedPermission);
    } catch (error) {
        console.log(error);
        return res.status(500).json({ message: 'Error updating permission' });
    }
}

export const DeletePermission = async (req: Request, res: Response, next: NextFunction) => {
    const permissionId = req.params.id;
    try {
        const deletedPermission = await Permission.findByIdAndDelete(permissionId);
        if (deletedPermission) {
            return res.status(200).json({ message: 'Permission deleted successfully' });
        } else {
            return res.status(404).json({ message: 'Permission not found' });
        }
    } catch (error) {
        console.log(error);
        return res.status(500).json({ message: 'Error deleting permission' });
    }
}
export const getAllPresidents=async(req:Request, res:Response,next:NextFunction)=>{
    const start: number = parseInt(req.query.start as string);
    const limit: number = parseInt(req.query.limit as string);
    const startIndex: number = start;
    const endIndex: number = start + limit;

    const results: any = {};

    if (endIndex < await LastPresidents.countDocuments().exec()) {
        results.next = {
            start: endIndex,
            limit: limit
        };
    }

    if (startIndex > 0) {
        results.previous = {
            start: Math.max(start - limit, 0), // Ensure start is not negative
            limit: limit
        };
    }
    const presidents=await LastPresidents.find().sort({ createdAt: 'desc' }) .limit(limit).skip(startIndex).exec();
    if (presidents) {
        return res.status(200).json(presidents);
    }else{
        return res.status(404).json({ message: 'No presidents found' });
    }
}


export const  CreateLastPresid=async(req:Request, res:Response,next:NextFunction)=>{
    const superAdmin=req. superadmin
    const president = plainToClass(PresidentsInut, req.body);
    const errors = await validate(president, { validationError: { target: false } });
    if (errors.length > 0) {
        return res.status(400).json({ message: 'Input validation failed', errors });
    }

    // search by name
    const existing = await LastPresidents.findOne( {
        $or: [
            { name: president.name },
            { year: president.year }  // Replace x with the desired year value
  ]});
    if (existing) {
        return res.status(400).json({ message: 'president already exists' });
    }
    const { name, year } = president;
    const presid=new LastPresidents({
        name,year
    })
    const saved=await presid.save()
    if (saved) {
        return res.status(201).json(saved);
    }else{
        return res.status(400).json({ message: 'Error creating permission' });
    }


}
export const  UpdateLastPresImage=async(req:Request, res:Response,next:NextFunction)=>{
try {
     const id=req.params.id
    const presid=await LastPresidents.findById(id)
    console.log(("hey"))
    if (!presid) {
        return res.status(404).json({ message: 'Permission not found' });
    }
    const image = req.file as Express.Multer.File;
  
    if (!image) {
      return res.status(400).send("Invalid or missing image file");
    }
    const newtest = new test({
        filename: image.filename,
        contentType: image.mimetype,
        length: image.size,
   
      });
      await newtest.save();
    // Convert the image to base64
    const base64Image = image.buffer.toString('base64');
    presid.CoverImage=base64Image

    const saved=await presid.save()
    if (saved) {
        return res.status(201).json(test);
    }else{
        return res.status(400).json({ message: 'Error creating permission' });
    }
} catch (error) {
    
}
   
}
export const  UpdateLastPres=async(req:Request, res:Response,next:NextFunction)=>{
    const superAdmin=req. superadmin
    const president = plainToClass(PresidentsInut, req.body);
    const errors = await validate(president, { validationError: { target: false } });
    if (errors.length > 0) {
        return res.status(400).json({ message: 'Input validation failed', errors });
    }
    const { name, year } = president;
    const id=req.params.id
    const presid=await LastPresidents.findById(id)
    if (!presid) {
        return res.status(404).json({ message: 'pres not found' });
    }
    presid.name=name
    presid.year=year
    const saved=await presid.save()
    if (saved) {
        return res.status(201).json(saved);
    }else{
        return res.status(400).json({ message: 'Error creating pres' });
    }
}
export const deleteLastPres=async(req:Request, res:Response,next:NextFunction)=>{
    const id=req.params.id
    const presid=await LastPresidents.findByIdAndDelete(id)
    if (presid) {
        return res.status(204).json({ message: 'pres deleted successfully' });
    }else{
        return res.status(404).json({ message: 'pres not found' });
    }
}