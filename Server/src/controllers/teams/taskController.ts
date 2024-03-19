import { plainToClass } from "class-transformer"
import { validate } from "class-validator"
import { NextFunction, Request, Response } from "express"
import { TaskInput, firstTaskInput } from "../../dto/teams.dto"
import { CheckList } from "../../models/teams/CheckListModel"
import { Task } from "../../models/teams/TaskModel"
import { team } from "../../models/teams/team"
import { getCheckListsInfoByIds, getMembersInfo, getTaskById, getTasksInfo } from "../../utility/role"
import { basename } from "path"

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
     attachedFile:task.attachedFile,
     description: task.description,
     StartDate:task.StartDate,
            isCompleted: task.isCompleted,
            CheckList:await  getCheckListsInfoByIds(task.CheckList),
        

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
        console.log('on save task')

      const savedTask = await newTask.save();
              console.log('on save task')

 await Team.tasks.push(savedTask._id)
        console.log('on save task')

    await Team.save()
            console.log('on save task')

 console.log('saved task')
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
  