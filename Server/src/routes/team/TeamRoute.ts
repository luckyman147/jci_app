import express, { Response } from "express";
import multer from "multer";
import { addCheck, deleteChecklist, updateChecklistName, updateIsCompletedChecklist } from "../../controllers/teams/ChecklistController";
import { GetTaskById, GetTasksOFTeam, addComment, addTask, deleteComment, deleteFile, deleteTask, updateComment, updateDeadline, updateFiles, updateIsCompleted, updateMembers, updateTask, updateTaskName } from "../../controllers/teams/taskController";
import { AddTeam, GetTeams, JoinTeam, UpdateTeamMembers, addMember, deleteTeam, getTeamById, getTeamByName, updateImage, updateTeam, uploadTeamImage } from "../../controllers/teams/teamsController";
import { Authenticate, AuthenticateAdmin } from "../../middleware/CommonAuth";
  interface CustomResponse extends Response {
      paginatedResults: any;
 }

  const router = express.Router();
  const storage = multer.memoryStorage();
  const upload = multer({ storage: storage });


 router.get('/All',Authenticate, GetTeams);
  router.get("/get",Authenticate,getTeamByName);// get teams /
  router.get('/get/:id', getTeamById);// get team by id/
router.post('/', AuthenticateAdmin, AddTeam);//create team
router.put('/:teamid/TeamMembers', Authenticate, UpdateTeamMembers);//create team
router.post('/:id/AddMember/:memberId',AuthenticateAdmin, addMember);//*add member
router.post('/:id/JoinTeam',AuthenticateAdmin, JoinTeam);//*join member
router.put('/:id',updateTeam);//update team
 
router.delete('/:id',deleteTeam)//!delete team
router.patch('/:id/UpdateImage',upload.single("CoverImages"),updateImage)
  router.post('/:id/uploadImage',upload.single("CoverImage"),uploadTeamImage)//delete team
router.get('/:id/tasks',GetTasksOFTeam)
router.post('/:taskId/comments',Authenticate,addComment)
 router.patch('/:taskId/comments/:commentId',Authenticate,updateComment)
 router.delete('/:taskId/comments/:commentId',Authenticate,deleteComment)
router.get('/:id/tasks/:taskId',GetTaskById)




                                            //& get tasks

router.post('/:id/tasks',addTask),
                                            // create a tas

router.put('/:taskid/UpdateStatus',updateIsCompleted)
router.put('/:id/tasks/:taskid', upload.array("CoverImage",4),updateTask)//* update tasks 
router.put('/tasks/:taskid/UpdateName',updateTaskName)//* update tasks
router.put('/:taskid/UpdateDeadline',updateDeadline)//* update tasks 
router.put('/:taskid/UpdateMembers',updateMembers)//* update tasks
router.put('/:taskid/UpdateFiles',upload.single("File"),updateFiles)//* update tasks

router.delete('/tasks/:taskid',deleteTask)
router.delete('/tasks/:taskid/File/:fileid',deleteFile)
//! Checklist
router.delete('/checklist/:checklistid',deleteChecklist)
router.put('/:taskid/UpdateCheckStatus/:checkid',updateIsCompletedChecklist)
router.put('/:taskid/UpdateCheckName/:checkid',updateChecklistName)
router.post('/:idTask/Checklist',addCheck)// create a a checklist

export { router as TeamRoute };
