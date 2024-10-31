import { plainToClass } from "class-transformer";
import { validate } from "class-validator";
import { NextFunction, Request, Response } from "express";
import { CreateRoleInput, ValidateCotisation, ValidatePoints } from "../dto/admin.dto";
import { Guest } from "../models/activities/Guests";
import { Member } from "../models/Member";
import { Permission } from "../models/Pemission";
import { Role } from "../models/role";
import { GenerateSalt, generateStrongPassword, HashPassword } from "../utility";
import { sendMembershipEmail, sendNewMemberEmail, sendUpdatedPointsEmail, sendVerifiedMemberEmail } from "../utility/NotificationEmailUtility";
import { CheckObjectif } from "../utility/objectifcheck";
import { findrole, findroleByid, getActivitiesInfo, getFilesInfoByIds, getMeetingsInfo, GetMemberPermission, getPublicPermissions, getteamsInfo, getTrainingInfo } from "../utility/role";
import { Activity } from "../models/activities/activitieModel";


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



//* get members

export const GetMembers=async( req:Request,res:Response,nex:NextFunction)=>{

    

    const members = await Member.find().sort({ createdAt: -1 });

        
        if(members.length>0){
            const ALlmembers = await Promise.all(
                members// Filtering teams with status true
                    .map(async (member) => ({
                        id: member._id,
                        firstName: member.firstName,
                        email: member.email,
                        Images:await getFilesInfoByIds(member.Images),
                  

                    }))
            );

            
            return res.json(ALlmembers)
        }
        return res.json({"message":"data not available"})
    }
    
    export const GetMemberById=async( req:Request,res:Response,nex:NextFunction)=>{

    

const id=req.params.id
        const profile=await Member.findById(id)
        if(profile){
            const [role, teamsInfo, activitiesInfo, trainingsinfo,meetingsInfo,FilesInfo,objectifs] = await Promise.all([
                findroleByid(profile.role),
                getteamsInfo(profile.Teams),
                getActivitiesInfo(profile.Activities),getTrainingInfo(profile.Activities),
                getMeetingsInfo(profile.Activities),getFilesInfoByIds(profile.Images),CheckObjectif(profile.id)
            ]);

            const info = {    Activities: [{"Events" : activitiesInfo,"Trainings":trainingsinfo,"Meetings":meetingsInfo}],
                id: profile.id,
                firstName: profile.firstName,
                lastName: profile.lastName,
                Images: FilesInfo,
                phone: profile.phone,
                email: profile.email,
                cotisation: profile.cotisation,
                role: role,
                points: profile.Points,
                is_validated: profile.is_validated,
                teams: teamsInfo,
                objectifs:objectifs
            
            };

            console.log(info)
            return res.status(200).json(info)
        }
        return res.status(404).json({message:'member not found'})
    }

//? create role

//find members by name
export const searchByName = async (req: Request, res: Response,next:NextFunction)=>{
    const admin=req.member
    if  (admin){
    const firstName = req.params.name
    const result = await Member.find({ firstName: { $regex: new RegExp(firstName, 'i') } })
  .sort({firstName:1});

    if(result.length >0){
        const ALlmembers = await Promise.all(
            result// Filtering teams with status true
                .map(async (member) => ({
                    id: member._id,
                    firstName: member.firstName,
                    email: member.email,
                    Images:await getFilesInfoByIds(member.Images),
              

                }))
        );
     
          return res.status(200).json(ALlmembers)
     }
     return res.status(400).json({"message":" notfound"})
    }
}
export const validateMember =async (req:Request,res:Response,next:NextFunction)=>{

   
        const id=req.params.id
console.log(id)
        const member=await Member.findById(id)
        if (member){
            member.is_validated=true
            const saved=await member.save()
            if (saved){
                sendVerifiedMemberEmail(member.language,member.firstName,member.email)
                //!send Email
                console.log(saved)
                return res.status(200).json(saved)
            }
            return res.status(400).json({message:'error with profile'})
        }

    
    
    }
    export const UpdatePoints =async (req:Request,res:Response,next:NextFunction)=>{

   
        const id=req.params.id
        const validateAction = plainToClass(ValidatePoints, req.body);
        const errors = await validate(validateAction, { validationError: { target: false } });
        if (errors.length > 0) {
          return res.status(400).json({ message: 'Input validation failed', errors });
        }
        const member=await Member.findById(id)
        if (member){
            member.PreviousPoints=member.Points
        
            member.Points=validateAction.Points
       
         
            
            
            const saved=await member.save()
            if (saved){
                sendUpdatedPointsEmail(member.language,member.firstName,saved.Points,member.email)
                //send email
                return res.status(200).json(saved)
            }
            return res.status(400).json({message:'error with profile'})
          }
          return res.status(404).json({message:'member not found'})
        }

    
    
        export const UpdateCotisation =async (req:Request,res:Response,next:NextFunction)=>{
     
           
                const id=req.params.id
                const validateAction = plainToClass(ValidateCotisation, req.body);
                const errors = await validate(validateAction, { validationError: { target: false } });
                if (errors.length > 0) {
                  return res.status(400).json({ message: 'Input validation failed', errors });
                }
                const member=await Member.findById(id)
                if (member){
                  if (validateAction.type==1){
                    member.cotisation[0]=validateAction.action
                    }else{
if (                      member.cotisation.length==1){
    member.cotisation.push(validateAction.action)
}
else{
    member.cotisation[1]=validateAction.action
}
                    }
                    
                    const saved=await member.save()

                    if (saved){
                        sendMembershipEmail(saved.language,saved.firstName,saved.email)
                        //send email
                        return res.status(200).json(saved)
                    }
                    return res.status(400).json({message:'error with profile'})
                  }
                  return res.status(404).json({message:'member not found'})
                }
        
            
            
        export    const GetPermissionsOfMember=async(req:Request,res:Response,next:NextFunction)=>{
                const admin=req.member
                
                    const id=req.params.id
                    const member=await Member.findById(id)
                    if (member){
                        const    permission =await GetMemberPermission(member.Permissions)
                        return res.status(200).json(permission)
            
        
        
        }}
        export const GetAllPermissions = async (req: Request, res: Response, next: NextFunction) => {
            try {
                // Retrieve all permissions from the database
                const permissions = await Permission.find();
        
                // Check if any permissions were found
                if (!permissions || permissions.length === 0) {
                    return res.status(404).json({ message: 'No permissions found' });
                }
        
                // Return the permissions
                return res.status(200).json(permissions);
            } catch (error) {
                console.log(error);
                return res.status(500).json({ message: 'Error retrieving permissions' });
            }
        }
                
export const UpdateMemberPermissions = async (req: Request, res: Response, next: NextFunction) => {
                        try {
                            const memberId = req.params.id;
                            const { permissionId, action } = req.body; // action should be either "add" or "remove"
                    
                            // Check if the member with the given ID exists
                            const member = await Member.findById(memberId);
                            if (!member) {
                                return res.status(404).json({ message: 'Member not found' });
                            }
                    
                            // Check if the permission with the given ID exists
                            const permission = await Permission.findById(permissionId);
                            if (!permission) {
                                return res.status(404).json({ message: 'Permission not found' });
                            }
                    
                            // Check if the action is valid (should be either "add" or "remove")
                            if (action !== 'add' && action !== 'remove') {
                                return res.status(400).json({ message: 'Invalid action. Action should be either "add" or "remove"' });
                            }
                    
                            // Update the member's permissions based on the action
                            if (action === 'add') {
                                // Check if the permission is already in the member's permissions
                                if (member.Permissions.includes(permissionId)) {
                                    return res.status(400).json({ message: 'Permission already exists for this member' });
                                }
                                // Add the permission to the member's permissions
                                member.Permissions.push(permissionId);
                            } else { // action === 'remove'
                                // Remove the permission from the member's permissions
                                const index = member.Permissions.indexOf(permissionId);
                                if (index !== -1) {
                                    member.Permissions.splice(index, 1);
                                } else {
                                    return res.status(400).json({ message: 'Permission does not exist for this member' });
                                }
                            }
                    
                            // Save the updated member
                            await member.save();
                    
                            return res.status(200).json({ permission:member.Permissions });
                        } catch (error) {
                            console.log(error);
                            return res.status(500).json({ message: 'Error updating permissions for member' });
                        }
                    }
export const ChangeGuestToNewMember=async(req:Request,res:Response)=>{
    const guestId=req.params.guestId
const guest=await Guest.findById(guestId)
if (guest){
//existed member 
const existed = await Member.findOne({ email: guest.email });
if (existed){
    return res.status(409).json({message:"member already exist"})

}

const salt=await GenerateSalt()
const password=generateStrongPassword(8)
const UserPassword=await HashPassword(password,salt)
const Permissions=await getPublicPermissions()
const role = await findrole('New Member')

const newMember=await Member.create({
    email:guest.email,
    password:UserPassword,
    salt:salt,
    cotisation:[false,false],
    firstName:guest.name,
    is_validated:false,
    adress:'',
    phone:'',
    language:'fr',

    lastName:guest.name,
    role:role,
    Permissions:Permissions

})
if (newMember){
    if(role){
        role.Members.push(newMember.id)
        await role.save()

    }
    const activitys=await Activity.find(
        
    )
    if (activitys.length>0){
        activitys.forEach(
           async (acti
            )=>{acti.guests=acti.guests.filter(
                (guests)=>guests.guest!=guest.id
                 )
                await acti.save()
                }
    )

      
    }
   await guest.deleteOne()

    console.log(newMember.language)
    sendNewMemberEmail(newMember.language,newMember.firstName,newMember.email,true,password)
  
    return res.status(201).json({message:"sign up completed " })

    
}
}
return res.status(404).json({message:"guest not found"})

}