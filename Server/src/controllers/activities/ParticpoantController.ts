import { Request, Response } from 'express';
import { Activity } from '../../models/activities/activitieModel';
import { createAndUploadExcel } from '../../utility/Partipants';
import { getguestsBasicInfo, getMembersBasicInfo } from '../../utility/role';
export const uploadExcel=async(req:Request,res:Response)=>{
try {
    const {activityId}=req.params
    const activity=await Activity.findById(activityId)
    if(!activity){
        return res.status(404).json({message:'Activity not found'})}
console.log("haha")

        const formattedguest = await Promise.all(activity.guests.map(async (participant) => ({
            guest: await getguestsBasicInfo(participant.guest),
        })));
console.log("haha")
        
        const formattedList = Object.values(formattedguest).map(item => item.guest);
        const formated=await Promise.all(activity.Participants.map(async(partipant)=>({
            member:await getMembersBasicInfo(partipant.memberid),
           
          })))
console.log("haha")

            const formatedparticpantsList = Object.values(formated).map(item => item.member);       
console.log("haha")
            
            const members=[...formatedparticpantsList,...formattedList]
console.log("haha-1")

await    createAndUploadExcel(members,res,activity.name)  
} catch (error) {
    res.status(500).json({"ssss":error})
    
}                                     
}