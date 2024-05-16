import { plainToClass } from "class-transformer";
import { validate } from "class-validator";
import { NextFunction, Request, Response } from "express";
import moment from 'moment';
import * as path from "path";
import { CommentInput, IsCompletedInput, MembersInput, TaskInput, TimelineInput, firstTaskInput } from "../../dto/teams.dto";
import { File } from "../../models/FileModel";
import { Member } from "../../models/Member";
import { CheckList } from "../../models/teams/CheckListModel";
import { Comment } from "../../models/teams/commentModel";
import { Task } from "../../models/teams/TaskModel";
import { team } from "../../models/teams/team";
import { sendTaskAssignmentEmail, sendTaskCompletedEmail } from "../../utility/NotificationEmailUtility";
import { getCheckListsInfoByIds, getCommentsInfo, getFilesInfoByIds, getMembersInfo, getTaskById, getTasksInfo } from "../../utility/role";

export const GetTasksOFTeam=async(req:Request,res:Response,next:NextFunction)=>{

    const id=req.params.id
    const Team=await team.findById(id)
    if (Team){

        const tasks=Team.tasks
        if (tasks.length>0){
            res.status(200).json(await getTasksInfo(tasks))
        }
        else{
            res.status(404).json({error:"No tasks found"})
        }
    }
    else{
        res.status(404).json({error:"No team found"})
    }
}
export const GetTaskById=async(req:Request,res:Response,next:NextFunction)=>{
    const id=req.params.id
    const taskId=req.params.taskId
    const Team=await team.findById(id)
    if (Team){
     const task =await getTaskById(taskId)
      if (task){
          res.status(200).json({

            id: task._id,
            name: task.name,
            AssignTo:await  getMembersInfo(task.AssignTo),
            Deadline: task.Deadline,
     attachedFile:await    getFilesInfoByIds(task.attachedFile),
     description: task.description,
     StartDate:task.StartDate,
            isCompleted: task.isCompleted,
            CheckList:await  getCheckListsInfoByIds(task.CheckList),
            comments:await getCommentsInfo(task.comments)

          })
      }
      else{
          res.status(404).json({error:"No task found"})
      }
    }
    else{
        res.status(404).json({error:"No team found"})
    }
    
}


export const addTask = async (req: Request, res: Response, next: NextFunction) => {
const Team=await team.findById(req.params.id)
if (!Team) {
    return res.status(404).json({ error: 'Team not found' });
    }

    try {

    
      const fitaskInput=plainToClass(firstTaskInput,req.body)
      const  errors=await validate(fitaskInput,{ validationError: { target: false } })
        if (errors.length > 0) {
            return res.status(400).json({ message: 'Input validation failed', errors });
        }
      
  console.log('heere')


      // Create a new Task instance
      const newTask = new Task({

     name: fitaskInput.name,
        
    });
     console.log('saved task')
  
   try{
       

      const savedTask = await newTask.save();
           

 await Team.tasks.push(savedTask._id)

    await Team.save()
    


      res.status(201).json(savedTask);
}catch(err){
    console.log("error",err)
    }
    } catch (error) {
      res.status(500).json({ error: error });
    }
  };








   
 
  //& update tasks
  export const updateTask = async (req: Request, res: Response, next: NextFunction) => {
    try {
      const teamId = req.params.id;
      const taskId = req.params.taskid;
  
      const Team = await team.findById(teamId);
      if (!Team) {
        return res.status(404).json({ error: 'Team not found' });
      }
  
      const taskToUpdate = Team.tasks.find((task) => task._id.toString() === taskId);
      if (!taskToUpdate) {
        return res.status(404).json({ error: 'Task not found in the team' });
      }
  
      const taskInput = plainToClass(TaskInput, req.body);
      const errors = await validate(taskInput, { validationError: { target: false } });
      if (errors.length > 0) {
        return res.status(400).json({ message: 'Input validation failed', errors });
      }
  
      if (!Team.Members.includes(taskInput.AssignTo)) {
        return res.status(400).json({ error: 'Member not found in team' });
      }
  
      const checkListItems = taskInput.CheckList.map((item: any) =>
        new CheckList({ name: item.name, Deadline: item.Deadline })
      );
  
      const savedCheckListItems = await CheckList.insertMany(checkListItems);
      const attachedFile: Express.Multer.File[] = req.files as Express.Multer.File[];
      if (!attachedFile || attachedFile.length === 0){
              console.log(attachedFile)
  
          return res.status(400).send("Invalid or missing files");
        }
        // Convert images to base64
        const base64files= attachedFile.map((attachedFiles) => attachedFiles.buffer.toString('base64'));
      // Update the existing task with new information
      taskToUpdate.name = taskInput.name;
      taskToUpdate.AssignTo = taskInput.AssignTo;
      taskToUpdate.Deadline = taskInput.Deadline;
      taskToUpdate.attachedFile = base64files;
      taskToUpdate.description = taskInput.description;
      taskToUpdate.StartDate = taskInput.StartDate;
      taskToUpdate.CheckList = savedCheckListItems.map((item: any) => item._id);
  
      // Save the updated team
      const savedTeam = await Team.save();
      await taskToUpdate.save();
  
      res.status(200).json({ updatedTask: taskToUpdate, team: savedTeam });
    } catch (error) {
      console.error(error);
      res.status(500).json({ error: 'Internal server error' });
    }
  };
 export const updateFiles = async (req: Request, res: Response, next: NextFunction) => {
    try {
     
      const taskId = req.params.taskid ;
  
      
  
      const taskToUpdate = await Task.findById(taskId)
      if (!taskToUpdate) {
        return res.status(404).json({ error: 'Task not found in the team' });
      }
  
      
  
  console.log(req.file)
     
  
     
      const attachedFile = req.file;
      if (!attachedFile) {
        return res.status(400).send('Invalid or missing files');
      }
  
      const fileExtension = path.extname(attachedFile.originalname);
    
     const founded= await File
     .findOne({ path: attachedFile.originalname })

    if (!founded) {
      // Convert the file to a base64 string
      const base64File = attachedFile.buffer.toString('base64');
      const file=new File({
        path: attachedFile.originalname ,
        url:base64File,
        extension:fileExtension,

      })

      taskToUpdate.attachedFile.push(file._id);
await   file.save()
  
     
      await taskToUpdate.save();
  
      res.status(200).json( file);
    }
  else{
    if (taskToUpdate.attachedFile.includes(founded._id)){
      return res.status(400).json({ error: 'File already exists' });
    }
    else{
      taskToUpdate.attachedFile.push(founded._id);
      await taskToUpdate.save();
      res.status(200).json(founded);
    }
  }
  }
    
    
    catch (error) {
      console.error(error);
      res.status(500).json({ error: 'Internal server error' });
    }
  };

  export const addComment=async(req:Request,res:Response)=>{

try {
      const taskId=req.params.taskId
      const member=req.member
  
      const task=await Task.findById(taskId)
      const taskInput = plainToClass(CommentInput, req.body);
      const errors = await validate(taskInput, { validationError: { target: false } });
      if (errors.length > 0) {
        return res.status(400).json({ message: 'Input validation failed', errors });
      }
      if (!task){
        return res.status(404).json({ error: 'task not found' });
      }
      const newComment=new Comment({
        comment:taskInput.comment,
        MemberId:member._id,
        TaskId:taskId,
        Created_At:moment.utc(Date.now()).toDate(),
      })
      await newComment.save()
  
      task.comments.push(newComment._id)
      await task.save()
  return res.status(201).json("Added succefully")
  
} catch (error) {
  console.error(error);
  res.status(500).json(error);
  
}
    
  }

  export const deleteComment = async (req: Request, res: Response) => {
    try {
      const taskId = req.params.taskId;
      const commentId = req.params.commentId;
      const member = req.member;
  
      const task = await Task.findById(taskId);
      if (!task) {
        return res.status(404).json({ error: 'task not found' });
      }
  
      const comment = await Comment.findById(commentId);
      if (!comment) {
        return res.status(404).json({ error: 'comment not found' });
      }
  
      // Check if the member has permission to delete the comment
      if (comment.MemberId.toString() !== member._id.toString()) {
        return res.status(403).json({ error: 'Forbidden: Member does not have permission to delete this comment' });
      }
  
      await comment.deleteOne();
  
      // Remove the comment reference from the task
      task.comments = task.comments.filter((id) => id.toString() !== commentId);
      await task.save();
  
      return res.status(204).json({ message: 'Comment deleted successfully' });
    } catch (error) {
      console.error(error);
      res.status(500).json({ error: 'Internal server error' });
    }
  };

  
  export const updateComment = async (req: Request, res: Response) => {
    try {
      const taskId = req.params.taskId;
      const commentId = req.params.commentId;
      const member = req.member;
  
      const task = await Task.findById(taskId);
      if (!task) {
        return res.status(404).json({ error: 'task not found' });
      }
  
      const comment = await Comment.findById(commentId);
      if (!comment) {
        return res.status(404).json({ error: 'comment not found' });
      }
  
      // Check if the member has permission to update the comment
      if (comment.MemberId.toString() !== member._id.toString()) {
        return res.status(403).json({ error: 'Forbidden: Member does not have permission to update this comment' });
      }
  
      const taskInput = plainToClass(CommentInput, req.body);
      const errors = await validate(taskInput, { validationError: { target: false } });
      if (errors.length > 0) {
        return res.status(400).json({ message: 'Input validation failed', errors });
      }
  
      comment.comment = taskInput.comment;
      comment.Updated_At= new Date(Date.now());
      await comment.save();
  
      return res.status(200).json({ message: 'Comment updated successfully' });
    } catch (error) {
      console.error(error);
      res.status(500).json({ error: 'Internal server error' });
    }
  };


  export const updateIsCompleted = async (req: Request, res: Response, next: NextFunction) => {
    try {
      const teamId = req.params.id;
      const taskId = req.params.taskid;
  
      const task = await Task.findById(taskId);
      if (!task) {
        return res.status(404).json({ error: 'task not found' });
      }
    const taskInput = plainToClass(IsCompletedInput, req.body);
      const errors = await validate(taskInput, { validationError: { target: false } });
      if (errors.length > 0) {
        return res.status(400).json({ message: 'Input validation failed', errors });
      }

           
task.isCompleted=taskInput.IsCompleted
const members=await Member.find({ _id: { $in: task.AssignTo } });
console.log(members)
console.log(taskInput.IsCompleted)

await task.save()
if (task.isCompleted==true){
                   members.forEach((member)=>

                     sendTaskCompletedEmail(member.language,member.email,task.name)
                   )
                 }
      res.status(200).json({ message:"Completed" , task });}
   
    
    catch (error) {
      console.error(error);
      res.status(500).json({ error: 'Internal server error' });
    }
  };
  
  
  export const updateDeadline = async (req: Request, res: Response, next: NextFunction) => {
    try {
      
      const taskId = req.params.taskid;
      
  
      const task = await Task.findById(taskId);
      if (!task) {
        return res.status(404).json({ error: 'task not found' });
      }
    const timelineInput = plainToClass(TimelineInput, req.body);
      const errors = await validate(timelineInput, { validationError: { target: false } });
      if (errors.length > 0) {
        return res.status(400).json({ message: 'Input validation failed', errors });
      }
           console.log(timelineInput)
           const startDateUtc = moment.utc(timelineInput.StartDate).toDate();
           console.log(startDateUtc)
const deadlineUtc =  moment.utc(timelineInput.Deadline).toDate();
task.StartDate=startDateUtc
task.Deadline=deadlineUtc
await task.save()
console.log(task)
      res.status(200).json({ message:"Completed" , task });}
   
    
    catch (error) {
      console.error(error);
      res.status(500).json({ error: 'Internal server error' });
    }
  };
  
    export const updateMembers = async (req: Request, res: Response, next: NextFunction) => {
    try {
      
      const taskId = req.params.taskid;
      
  
      const task = await Task.findById(taskId);
      if (!task) {
        return res.status(404).json({ error: 'task not found' });
      }
      
    const membersInput = plainToClass(MembersInput, req.body);
      const errors = await validate(membersInput, { validationError: { target: false } });
      if (errors.length > 0) {
        return res.status(400).json({ message: 'Input validation failed', errors });
      }
      const member=await Member.findById(membersInput.Member)
      if (!member) {
        return res.status(404).json({ error: 'Member not found' });}
         console.log(membersInput.Status)  
    //        if (task.AssignTo.includes(membersInput.Member) && membersInput.Status=="true"){
    // return res.status(400).json({ error: 'Member already exists' });}
if (membersInput.Status=="true"){

  console.log(membersInput.Member)  
  console.log(membersInput.Status)  
   
  await task.AssignTo.push(membersInput.Member)

    await task.save()
    sendTaskAssignmentEmail( member.language,member.email,task.name)
      res.status(200).json({ message:"Completed" , task });
}
else {
  console.log(membersInput.Member)

  task.AssignTo = task.AssignTo.filter((member) => member._id.toString() !== membersInput.Member.toString());

await task.save()
    res.status(200).json({ message:"Completed" , task });
  
}
}
   
    
    catch (error) {
      console.error(error);
      res.status(500).json({ error: 'Internal server error' });
    }
  };
  
  
  
  
  
  
  
  
  export const updateTaskName = async (req: Request, res: Response, next: NextFunction) => {
    try {
      
      const taskId = req.params.taskid;
  
      const task = await Task.findById(taskId);
      if (!task) {
        return res.status(404).json({ error: 'task not found' });
      }
    const taskInput = plainToClass(firstTaskInput, req.body);
      const errors = await validate(taskInput, { validationError: { target: false } });
      if (errors.length > 0) {
        return res.status(400).json({ message: 'Input validation failed', errors });
      }
           
task.name=taskInput.name
await task.save()
      res.status(200).json({ message:"Completed" , task });}
   
    
    catch (error) {
      console.error(error);
      res.status(500).json({ error: 'Internal server error' });
    }
  };



 


  export const deleteTask = async (req: Request, res: Response, next: NextFunction) => {
    try {

      const taskId = req.params.taskid;
         const task = await Task.findById(taskId);
                  if (!task) {
                    return res.status(404).json({ error: 'Task not found' });
                  }

                  // Delete the Team
                  await task.deleteOne();

                  res.status(204).json({message:"deleted successully"});
  

    } catch (error) {
      console.error(error);
      res.status(500).json({ error: 'Internal server error' });
    }
  };export const deleteFile = async (req: Request, res: Response, next: NextFunction) => {
    try {

      const taskId = req.params.taskid;
      const fileId = req.params.fileid;
         const task = await Task.findById(taskId);
                  if (!task) {
                  console.log("task not found")
                    return res.status(404).json({ error: 'Task not found' });
                  }
                  const file=await File.findById(fileId)
                  if (!file) {
                                    console.log("file not found")

                    return res.status(404).json({ error: 'File not found' });
                  }

            task.attachedFile = task.attachedFile.filter((file) => file._id.toString() !== file._id.toString());
await file.deleteOne()
                  await task.save();

                  res.status(204).json({message:"deleted successully"});
  

    } catch (error) {
      console.error(error);
      res.status(500).json({ error: 'Internal server error' });
    }
  };
  
 