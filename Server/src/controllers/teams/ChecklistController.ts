
import { plainToClass } from "class-transformer"
import { validate } from "class-validator"
import { NextFunction, Request, Response } from "express"
import { IsCompletedInput, TaskInput, firstTaskInput } from "../../dto/teams.dto"
import { CheckList } from "../../models/teams/CheckListModel"
import { Task } from "../../models/teams/TaskModel"
import { team } from "../../models/teams/team"
import { getCheckListsInfoByIds, getMembersInfo, getTaskById, getTasksInfo } from "../../utility/role"
import { Member } from "../../models/Member"
import { sendSubtaskCreatedEmail } from "../../utility/NotificationEmailUtility"

export const addCheck = async (req: Request, res: Response, next: NextFunction) => {
    const task=await Task.findById(req.params.idTask)
    if (!task) {
        return res.status(404).json({ error: 'Task not found' });
        }
    
        try {
    
        
          const fitaskInput=plainToClass(firstTaskInput,req.body)
          const  errors=await validate(fitaskInput,{ validationError: { target: false } })
            if (errors.length > 0) {
                return res.status(400).json({ message: 'Input validation failed', errors });
            }
          
      console.log('heere')
    
    
          // Create a new Task instance
          const newCheck = new CheckList({
    
         name: fitaskInput.name,
            
        });
         console.log('saved checklist')
      
       try{
            console.log('on save checklist')
    
          const savedTask = await newCheck.save();
                  console.log('on save check')
    
     await task.CheckList.push(savedTask._id)
     
    
        await task.save()
        if (task.AssignTo.length>0){
          const members=await Member.find({ _id: { $in: task.AssignTo } });
          if (members.length>0){
            members.forEach(( member)=>sendSubtaskCreatedEmail(member.language,member.email,task.name,newCheck.name))
          }

        }
    

          res.status(201).json(savedTask);
    }catch(err){
        console.log("error",err)
        }
        } catch (error) {
          res.status(500).json({ error: error });
        }
      };
    
      export const updateIsCompletedChecklist = async (req: Request, res: Response, next: NextFunction) => {
        try {
          const taskid = req.params.taskid;
          const checkid = req.params.checkid;
      
          const task = await Task.findById(taskid);
          if (!task) {
            return res.status(404).json({ error: 'task not found' });
          }
          const check = await CheckList.findById(checkid);
          if (!check) {
            return res.status(404).json({ error: 'check not found' });
          }
        const taskInput = plainToClass(IsCompletedInput, req.body);
          const errors = await validate(taskInput, { validationError: { target: false } });
          if (errors.length > 0) {
            return res.status(400).json({ message: 'Input validation failed', errors });
          }
               
    check.isCompleted=taskInput.IsCompleted
    await check.save()
          res.status(200).json({ message:"Completed" , check });}
       
        
        catch (error) {
          console.error(error);
          res.status(500).json({ error: 'Internal server error' });
        }
      };export const updateChecklistName = async (req: Request, res: Response, next: NextFunction) => {
        try {
          const taskid = req.params.taskid;
          const checkid = req.params.checkid;
      
          const task = await Task.findById(taskid);
          if (!task) {
            return res.status(404).json({ error: 'task not found' });
          }
          const check = await CheckList.findById(checkid);
          if (!check) {
            return res.status(404).json({ error: 'check not found' });
          }
        const taskInput = plainToClass(firstTaskInput, req.body);
          const errors = await validate(taskInput, { validationError: { target: false } });
          if (errors.length > 0) {
            return res.status(400).json({ message: 'Input validation failed', errors });
          }
               
    check.name=taskInput.name
    await check.save()
          res.status(200).json({ message:"Completed" , check });}
       
        
        catch (error) {
          console.error(error);
          res.status(500).json({ error: 'Internal server error' });
        }
      };
    
      export const deleteChecklist = async (req: Request, res: Response, next: NextFunction) => {
        try {
    
          const checklistId = req.params.checklistid;
           const check = await CheckList.findById(checklistId);
                if (!check) {
                  return res.status(404).json({ error: 'check not found' });
                }
    
                // Delete the Team
                await check.deleteOne();
    
                res.status(204).json({message:"deleted successully"});
        } catch (error) {
    
          res.status(500).json({ error: 'Internal server error' });
        }
      };
      
    
    
    
    
    
    
    
    
    
    