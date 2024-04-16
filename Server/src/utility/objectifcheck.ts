import { Member } from "../models/Member"
import { getActivitiesInfo, getMeetingsInfo, getteamsInfo, getTrainingInfo } from "./role";

export const  CheckObjectif=async(id:string)=>{
const profile=await Member.findById(id)
const [ teams,activitiesInfo, trainingsinfo,meetingsInfo] = await Promise.all([

    getteamsInfo(profile!.Teams),
    getActivitiesInfo(profile!.Activities),getTrainingInfo(profile!.Activities),
    getMeetingsInfo(profile!.Activities),
]);
const objectives = [
    { "name": "Gain 100 Points", "Condition": profile!.Points as number >= 100 },
    { "name": "Change Profile Picture", "Condition": profile!.Images.length > 0 },
    { "name": "Add Phone Number", "Condition": profile!.phone.length>0 },
    { "name": "Join 3 Teams", "Condition": teams.length >= 3 },
    { "name": "Join 3 Events", "Condition": activitiesInfo.length >= 3 },
    { "name": "Join 3 Trainings", "Condition": trainingsinfo.length >= 3 },
    { "name": "Join 3 Meetings", "Condition": meetingsInfo.length >= 3 }
];
return  objectives;

}