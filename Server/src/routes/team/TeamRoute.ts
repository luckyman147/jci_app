import express, { Response } from "express";
import multer from "multer";
import { addCheck, deleteChecklist, updateChecklistName, updateIsCompletedChecklist } from "../../controllers/teams/ChecklistController";
import { GetTaskById, GetTasksOFTeam, addTask, deleteFile, deleteTask, updateDeadline, updateFiles, updateIsCompleted, updateMembers, updateTask, updateTaskName } from "../../controllers/teams/taskController";
import { AddTeam, GetTeams, addMember, deleteTeam, getTeamById, updateImage, updateTeam, uploadTeamImage } from "../../controllers/teams/teamsController";

import { Authenticate } from "../../middleware/CommonAuth";
interface CustomResponse extends Response {
    paginatedResults: any;
}

const router = express.Router();
const storage = multer.memoryStorage();
const upload = multer({ storage: storage });


router.get('/All', GetTeams);// get teams /
router.get('/get/:id', getTeamById);// get team by id/ 
router.post('/', Authenticate, AddTeam);//create team
router.post('/:id/AddMember/:memberId', addMember);//*add member
router.put('/:id',updateTeam);//update team
router.delete('/:id',deleteTeam)//!delete team 
router.patch('/:id/UpdateImage',upload.single("CoverImage"),updateImage)
router.post('/:id/uploadImage',upload.single("CoverImage"),uploadTeamImage)//delete team
router.get('/:id/tasks',GetTasksOFTeam)
router.get('/:id/tasks/:taskId',GetTaskById)



 //& get tasks

 router.post('/:id/tasks',addTask),
 // create a tas

router.put('/:taskid/UpdateStatus',updateIsCompleted)
router.put('/:id/tasks/:taskid', upload.array("CoverImage",4),updateTask)//* update tasks 
router.put('/tasks/:taskid/UpdateName',updateTaskName)//* update tasks
router.put('/:taskid/UpdateDeadline',updateDeadline)//* update tasks 
router.put('/:taskid/UpdateMembers',updateMembers)//* update tasks 
router.put('/:taskid/UpdateFiles',upload.single("CoverImage"),updateFiles)//* update tasks 

router.delete('/tasks/:taskid',deleteTask)
router.delete('/tasks/:taskid/File/:fileid',deleteFile)
//! Checklist
router.delete('/checklist/:checklistid',deleteChecklist)
router.put('/:taskid/UpdateCheckStatus/:checkid',updateIsCompletedChecklist)
router.put('/:taskid/UpdateCheckName/:checkid',updateChecklistName)
router.post('/:idTask/Checklist',addCheck)// create a a checklist

export { router as TeamRoute };
