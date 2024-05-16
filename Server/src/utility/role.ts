import crypto from 'crypto';
import { File } from '../models/FileModel';
import { Member } from "../models/Member";
import { Permission } from '../models/Pemission';
import { Guest } from '../models/activities/Guests';
import { Training } from '../models/activities/TrainingModel';
import { Event } from "../models/activities/eventModel";
import { Meeting } from '../models/activities/meetingModel';
import { Role } from "../models/role";
import { CheckList } from '../models/teams/CheckListModel';
import { Task } from '../models/teams/TaskModel';
import { team } from "../models/teams/team";
import { Comment } from '../models/teams/commentModel';
export const findrole=async (name:string)=>{
    const role = await Role.findOne({ name: name });
    if (role){
        return role
    }
}

export const findroleByid=async (id:string)=>{
const role = await Role.findById(id);
if (role){
    return role.name;
}
throw new Error("Role not found");
}
  
export const getEventNameById = async (eventId: string): Promise<any | null> => {
    try {
      // Query the database to find the event by its ID
      const event = await Event.findById(eventId);
  
      // Check if the event is found
      if (event) {
        // Return the event name
        return {name:event.name,ActivityEndDate:event.ActivityEndDate,id:event._id};
      } else {
        // Event not found
        return null;
      }
    } catch (error) {
      console.error(error);
      throw new Error('Internal server error');
    }
  };
  
export const getTeamByEvent= async () =>{
    try {
      const teamsByEvent = await team.aggregate([
        {
          $lookup: {
            from: 'events', // Assuming your events collection is named 'events'
            localField: 'Event',
            foreignField: '_id',
            as: 'eventInfo',
          },
        },
        {
          $unwind: {
            path: '$eventInfo',
            preserveNullAndEmptyArrays: true,
          },
        },
        {
          $group: {
            _id: '$Event', // Group by the Event field
            teams: { $push: '$$ROOT' },
          },
        },
      ]);
  
      return teamsByEvent;
    } catch (error) {
      throw error;
    }
  }
  export const getMembersInfo = async (memberIds: string[]): Promise<any> => {
    try {
      // Query the database to find members by their IDs
      const members = await Member.find({ _id: { $in: memberIds } });

      const membersInfo =
      Promise.all(
      members.map(async  (member) => ({
        _id: member._id,
        firstName: member.firstName,
        Images:await  getFilesInfoByIds(member.Images),

        // Add other fields you want to include
      })));
  console.log(membersInfo)

      return membersInfo;
    } catch (error) {
      console.error(error);
      throw new Error('Internal server error');
    }
  };  export const getGuestInfo = async (memberIds: string): Promise<any> => {
    try {
      // Query the database to find members by their IDs
      const members = await Guest.findById(memberIds);

      
  console.log(members)
if (members){
      return members;}
      else{
        return null
      }
    } catch (error) {
      console.error(error);
      throw new Error('Internal server error');
    }
  };

  export const getTasksInfoIsCompleted = async (taskIds: string[]): Promise<any> => {
    try {
      // Query the database to find tasks by their IDs
      const tasks = await Task.find({ _id: { $in: taskIds } });
  
      const tasksInfo = tasks.map((task) => ({
       
       isCompleted:task.isCompleted,
        // Add other fields you want to include
      }));
  
      console.log(tasksInfo);
  
      return tasksInfo;
    } catch (error) {
      console.error(error);
      throw new Error('Internal server error');
    }
  };export const getTasksInfo = async (taskIds: string[]): Promise<any> => {
    try {
      // Query the database to find tasks by their IDs
      const tasks = await Task.find({ _id: { $in: taskIds } });
  
      const tasksInfo = await Promise.all(
      tasks.map(async (task) => ({
        id: task._id,
        name: task.name,
        AssignTo:await  getMembersInfo(task.AssignTo),
        Deadline: task.Deadline,
 StartDate:task.StartDate,
 attachedFile:await getFilesInfoByIds(task.attachedFile),
        isCompleted: task.isCompleted,
        CheckList: await  getCheckListsInfoByIds(task.CheckList),
        comments:await getCommentsInfo(task.comments)    

  
        // Add other fields you want to include
      })));
  
      console.log(tasksInfo);
  
      return tasksInfo;
    } catch (error) {
      console.error(error);
      throw new Error('Internal server error');
    }
  };
export   function shortenBase64(base64String:string) {
    // Convert the base64 string to a Buffer
    const bufferData = Buffer.from(base64String, 'base64');
  
    // Create a hash using SHA-256
    const sha256Hash = crypto.createHash('sha256').update(bufferData).digest('hex');
  
    // Take the first 8 characters of the hash as a shortened phrase
    const shortenedPhrase = sha256Hash.slice(0, 8);
  
    return shortenedPhrase;
  }
 export  const getTaskById = async (taskId:string) => {
    try {
      const task = await Task.findById(taskId);
  
      if (!task) {
        throw new Error(`Task with ID ${taskId} not found`);
      }
  
      return task;
    } catch (error) {
     return null 
    }
  };
  export const getCheckListsInfoByIds = async (checkListIds:string[]) => {
    try {
      const checkLists = await CheckList.find({ _id: { $in: checkListIds } });
  
      const checkListsInfo = checkLists.map((checkList) => ({
        id: checkList._id,
        name: checkList.name,
        isCompleted: checkList.isCompleted,
   
      }));
  
      return checkListsInfo;
    } catch (error) {
      console.error(error);
      throw new Error('Internal server error');
    }
  };  export const getFilesInfoByIds = async (checkListIds:string[]) => {
    try {
      const Files = await File.find({ _id: { $in: checkListIds } });
  
      const FilesInfo = Files.map((file) => ({
        id: file._id,
        url: file.url,
        extension: file.extension,
        path: file.path,
   
      }));
  
      return FilesInfo;
    } catch (error) {
      console.error(error);
      throw new Error('Internal server error');
    }
  };
  export const getteamsInfo = async (teamsIds: string[]): Promise<any> => {
    try {
      // Query the database to find members by their IDs
      const teams = await team.find({ _id: { $in: teamsIds } });

      const teamsInfo =
      Promise.all(
      teams.map(async(team) => ({
        id: team._id,
        name: team.name,
        CoverImage:team.CoverImage,
        status: team.status,
        Members: await getMembersInfo(team.Members)
        // Add other fields you want to include
      })));
  console.log(teams)

      return teamsInfo;
    } catch (error) {
      console.error(error);
      throw new Error('Internal server error');
    }
  };
  export const getCommentsInfo =async (comments_id:string[])=>{
    try {
      const comments = await Comment.find({ _id: { $in: comments_id } });
  if (comments.length>0){
      const commentsInfo = Promise.all(comments.map(async (comment) => ({
        id: comment._id,
        TaskId: comment.TaskId,
        memberId: await getMembersInfo(comment.MemberId),
        CreatedAt: (comment as Comment).Created_At,
          UpdatedAt: (comment as Comment).Updated_At,
  })))
return commentsInfo
  }
  else{
    return []
  }


}catch(e){
  return []



  }}
  export const getActivitiesInfo = async (EventsIds: string[]): Promise<any> => {
    try {
      // Query the database to find members by their IDs
      const Events = await Event.find({ _id: { $in: EventsIds } });
      console.log(Events)

      const EventsInfo =
        Promise.all(

      Events.map(async(act) => ({
        id: act._id,
        name: act.name,
        CoverImages:act.CoverImages,
        Members:await getMembersInfo(act.Participants)

        // Add other fields you want to include
      })));

      return EventsInfo;
    } catch (error) {
      console.error(error);
      throw new Error('Internal server error');
    }
  }; export const getTrainingInfo = async (EventsIds: string[]): Promise<any> => {
    try {
      // Query the database to find members by their IDs
      const trainings= await Training.find({ _id: { $in: EventsIds } });
      console.log(trainings)

      const trainingsInfo =
        Promise.all(

      trainings.map(async(act) => ({
        id: act._id,
        name: act.name,
        CoverImages:act.CoverImages,
        Members:await getMembersInfo(act.Participants)

        // Add other fields you want to include
      })));

      return trainingsInfo;
    } catch (error) {
      console.error(error);
      throw new Error('Internal server error');
    }
  }; export const getMeetingsInfo = async (EventsIds: string[]): Promise<any> => {
    try {
      // Query the database to find members by their IDs
      const Meetings = await Meeting.find({ _id: { $in: EventsIds } });
      console.log(Meetings)

      const MeetingsInfo =
        Promise.all(

          Meetings.map(async(act) => ({
        id: act._id,
        name: act.name,
        CoverImages:act.CoverImages,
        Members:await getMembersInfo(act.Participants)

        // Add other fields you want to include
      })));

      return MeetingsInfo;
    } catch (error) {
      console.error(error);
      throw new Error('Internal server error');
    }
  };
  export const GetMemberPermission=async (memberPermissionIds:string[])=>{
    try{
      const permissions = await Permission.find({ _id: { $in: memberPermissionIds } });
      console.log(permissions)
if (permissions.length>0){
  const permissionsInfo = permissions.map((permission) => ({
    id: permission._id,
    name: permission.name,
    description: permission.description,

  }));
  return permissionsInfo
}
else{
  return []
}

    }catch(e){
      console.log(e)
    }
  }
  export const getPermissionIdsByRelated = async (searchStrings:string []) => {
    try {
        const permissions = await Permission.find({ related: { $in: searchStrings } },);
        const permissionIds = permissions.map(permission => permission.key);
        return permissionIds;
    } catch (error) {
        console.error('Error retrieving permission IDs:', error);
        throw error;
    }
}; export const getPermissionsKeys = async (searchStrings: string[], role: string) => {
  try {
      const permissions = await Permission.find({
          $or: [
              { _id: { $in: searchStrings } }, // Find by IDs
              { roles: role } // Find by role
          ]
      });

      return permissions.map(permission => permission.key);
  } catch (error) {
      console.error('Error retrieving permissions:', error);
      throw error;
  }
};
export const getPublicPermissions = async (): Promise<Permission[]> => {
  try {
    const permissions = await Permission.find({ isPublic: true });
    return permissions;
  } catch (error) {
    console.error('Error retrieving public permissions:', error);
    throw error;
  }
};
export const getRank=async(id:string)=>{
  
  const roles = await Role.find({ name: { $nin: ["superadmin", "admin"] }});
  const members = await Member.find({ role: { $in: roles.map(role => role._id) } }).sort({Points:-1})
  const member=await members.find(member=>member._id==id)
  const memberrole=await Role.findById(member?.role)
  
  if(!member || !memberrole){return -1}
  else if (memberrole.name in ["superadmin","admin"]){return -1}
  return members.indexOf(member)+1

}