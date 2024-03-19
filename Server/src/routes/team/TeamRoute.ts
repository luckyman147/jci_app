import express, { Request, Response } from "express";
import multer from "multer";
import { GetTaskById, GetTasksOFTeam, addTask, deleteChecklist, deleteTask, updateTask } from "../../controllers/teams/taskController";
import { AddTeam, GetTeams, addMember, deleteTeam, getTeamById, updateImage, updateTeam, uploadTeamImage } from "../../controllers/teams/teamsController";
import { Authenticate } from "../../middleware/CommonAuth";
import paginatedResults, { PaginatedResponse } from "../../middleware/pagination";
import { Task } from "../../models/teams/TaskModel";



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
router.post('/:id/tasks',addTask)// create a task 
router.put('/:id/tasks/:taskid', upload.array("CoverImage",4),updateTask)//* update tasks 
router.delete('/:id/tasks/:taskid',deleteTask)     //! delete tasks
router.delete('/:id/tasks/:taskid/checklist/:checklistid',deleteChecklist)
export { router as TeamRoute };
