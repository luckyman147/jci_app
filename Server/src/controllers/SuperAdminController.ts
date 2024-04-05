import { NextFunction, Request, Response } from 'express';

import { validate } from "class-validator";

import { plainToClass } from 'class-transformer';
import { PermissionInput } from '../dto/superAdmin.dto';
import { Member } from '../models/Member';
import { Permission } from '../models/Pemission';
import { generateSecureKey } from '../utility';
import { findrole } from '../utility/role';

export const ChangeToAdmin=async(req:Request, res:Response,next:NextFunction)=>{
    const superAdmin=req. superadmin
   
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
export const CreatePermission = async (req: Request, res: Response, next: NextFunction) => {
    const superAdmin = req.superadmin;
    console.log(superAdmin)
    try {
        const PermissionInputs = plainToClass(PermissionInput, req.body);
        const errors = await validate(PermissionInputs, { validationError: { target: false } });
        if (errors.length > 0) {
            return res.status(400).json({ message: 'Input validation failed', errors });
        }
        const { name, description, related} = PermissionInputs;

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

