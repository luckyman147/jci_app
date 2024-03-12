import { plainToClass } from "class-transformer"
import { validate } from "class-validator"
import { NextFunction, Request, Response } from "express"
import { TaskInput } from "../../dto/teams.dto"
import { CheckList } from "../../models/teams/CheckListModel"
import { Task } from "../../models/teams/TaskModel"
import { team } from "../../models/teams/team"

export const GetTaskOFTeam=async(req:Request,res:Response,next:NextFunction)=>{
    const id=req.params.id
    const Team=await team.findById(id)
    if (Team){
        const tasks=Team.tasks
        if (tasks){
            res.status(200).json(tasks)
        }
        else{
            res.status(404).json({error:"No tasks found"})
        }
    }
    else{
        res.status(404).json({error:"No team found"})
    }
}
export const createatask= async(req:Request,res:Response,next:NextFunction)=>{
    const id=req.params.id
    const Team=await team.findById(id)
if (Team){

}
} 
export const addTask = async (req: Request, res: Response, next: NextFunction) => {
const Team=await team.findById(req.params.id)
if (!Team) {
    return res.status(404).json({ error: 'Team not found' });
    }

    try {

       let  attachedFile:string=""
      const taskInput=plainToClass(TaskInput,req.body)
      const  errors=await validate(taskInput,{ validationError: { target: false } })
        if (errors.length > 0) {
            return res.status(400).json({ message: 'Input validation failed', errors });
        }
        if (!Team.Members.includes(taskInput.AssignTo)) {
            return res.status(400).json({error:"Member not found in team"})
        }
  console.log('heere')
  console.log(taskInput.CheckList)
      // Create a new CheckList instance for each checklist item
      const checkListItems =    taskInput.CheckList
      .map((item: any) =>
       new CheckList({
 name: item.name,Deadline:item.Deadline}));

      console.log('heere')
  
      // Save the checklist items
      const savedCheckListItems = await CheckList.insertMany(checkListItems);
      console.log('heere')

  if (req.file) {
   attachedFile= req.file.buffer.toString('base64')
}


      // Create a new Task instance
      const newTask = new Task({

     name: taskInput.name,
        AssignTo: taskInput.AssignTo,
        Deadline: taskInput.Deadline,
        attachedFile: attachedFile,
        CheckList: savedCheckListItems.map((item: any) => item._id),
    });
    
  
      // Save the task
      const savedTask = await newTask.save();
  Team.tasks.push(savedTask)
   const savedTeam= await Team.save()
      res.status(201).json({savedTask:savedTask,Team:Team});
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
  
      let attachedFile = '';
      if (req.file) {
        attachedFile = req.file.buffer.toString('base64');
      }
  
      // Update the existing task with new information
      taskToUpdate.name = taskInput.name;
      taskToUpdate.AssignTo = taskInput.AssignTo;
      taskToUpdate.Deadline = taskInput.Deadline;
      taskToUpdate.attachedFile = attachedFile;
      taskToUpdate.CheckList = savedCheckListItems.map((item: any) => item._id);
  
      // Save the updated team
      const savedTeam = await Team.save();
  
      res.status(200).json({ updatedTask: taskToUpdate, team: savedTeam });
    } catch (error) {
      console.error(error);
      res.status(500).json({ error: 'Internal server error' });
    }
  };
  export const deleteTask = async (req: Request, res: Response, next: NextFunction) => {
    try {
      const teamId = req.params.id;
      const taskId = req.params.taskid;
  
      const Team = await team.findById(teamId);
      if (!Team) {
        return res.status(404).json({ error: 'Team not found' });
      }
  
      const taskToDeleteIndex = Team.tasks.findIndex((task) => task._id.toString() === taskId);
      if (taskToDeleteIndex === -1) {
        return res.status(404).json({ error: 'Task not found in the team' });
      }
  
      // Remove the task from the team's tasks array
      const deletedTask = Team.tasks.splice(taskToDeleteIndex, 1)[0];
  
      // Save the updated team
      const savedTeam = await Team.save();
  
      res.status(200).json({ deletedTask, team: savedTeam });
    } catch (error) {
      console.error(error);
      res.status(500).json({ error: 'Internal server error' });
    }
  };
  export const deleteChecklist = async (req: Request, res: Response, next: NextFunction) => {
    try {
      const teamId = req.params.id;
      const taskId = req.params.taskid;
      const checklistId = req.params.checklistid;
  
      const Team = await team.findById(teamId);
      if (!Team) {
        return res.status(404).json({ error: 'Team not found' });
      }
  
      const taskToUpdate = Team.tasks.find((task) => task._id.toString() === taskId);
      if (!taskToUpdate) {
        return res.status(404).json({ error: 'Task not found in the team' });
      }
  console.log(taskToUpdate)
  const task= await Task.findById(taskId)
      const checklistToDeleteIndex = task!.CheckList.findIndex(
        (checklist:any) => checklist._id.toString() === checklistId
      );
      if (checklistToDeleteIndex === -1) {
        return res.status(404).json({ error: 'Checklist not found in the task' });
      }
  
      // Remove the checklist item from the task's CheckList array
      const deletedChecklist = task!.CheckList.splice(checklistToDeleteIndex, 1)[0];
  await task?.save()
      // Save the updated team
      const savedTeam = await Team.save();
  
      res.status(200).json({ deletedChecklist, task });
    } catch (error) {
      console.error(error);
      res.status(500).json({ error: 'Internal server error' });
    }
  };
  