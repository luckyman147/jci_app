import crypto from 'crypto';
import { Member } from "../models/Member";
import { Event } from "../models/activities/eventModel";
import { Role } from "../models/role";
import { Task } from '../models/teams/TaskModel';
import { team } from "../models/teams/team";
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
        return {name:event.name,ActivityEndDate:event.ActivityEndDate};
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

      const membersInfo = members.map((member) => ({
        _id: member._id,
        firstName: member.firstName,
        Images:member.Images

        // Add other fields you want to include
      }));
  console.log(membersInfo)

      return membersInfo;
    } catch (error) {
      console.error(error);
      throw new Error('Internal server error');
    }
  };

  export const getTasksInfo = async (taskIds: string[]): Promise<any> => {
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