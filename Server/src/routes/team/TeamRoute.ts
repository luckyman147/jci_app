import express from "express";
import multer from "multer";
import { GetTaskOFTeam, addTask, deleteChecklist, deleteTask, updateTask } from "../../controllers/teams/taskController";
import { AddTeam, GetTeams, addMember, deleteTeam, getTeamById, updateImage, updateTeam, uploadTeamImage } from "../../controllers/teams/teamsController";
import { Authenticate } from "../../middleware/CommonAuth";

const router=express.Router()
const storage = multer.memoryStorage()
const upload = multer({ storage: storage })
router.get('/All',GetTeams)// get teams /
router.get('/get/:id',getTeamById)// get team by id/ 
router.post('/',Authenticate,AddTeam)//create team
router.post( '/:id/AddMember/:memberId',addMember)//*add member
router.put('/:id',updateTeam)//update team
router.delete('/:id',deleteTeam)//!delete team 
router.patch('/:id/UpdateImage',upload.single("CoverImage"),updateImage)
router.post('/:id/uploadImage',upload.single("CoverImage"),uploadTeamImage)//delete team
router.get('/:id/tasks',GetTaskOFTeam) //& get tasks
router.post('/:id/tasks',upload.single('file'),addTask)// create a task 
router.put('/:id/tasks/:taskid',updateTask)//* update tasks 
router.delete('/:id/tasks/:taskid',deleteTask)     //! delete tasks
router.delete('/:id/tasks/:taskid/checklist/:checklistid',deleteChecklist)
export { router as TeamRoute };
