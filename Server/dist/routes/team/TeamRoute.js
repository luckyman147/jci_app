"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.TeamRoute = void 0;
const express_1 = __importDefault(require("express"));
const multer_1 = __importDefault(require("multer"));
const ChecklistController_1 = require("../../controllers/teams/ChecklistController");
const taskController_1 = require("../../controllers/teams/taskController");
const teamsController_1 = require("../../controllers/teams/teamsController");
const CommonAuth_1 = require("../../middleware/CommonAuth");
const router = express_1.default.Router();
exports.TeamRoute = router;
const storage = multer_1.default.memoryStorage();
const upload = (0, multer_1.default)({ storage: storage });
router.get('/All', CommonAuth_1.Authenticate, teamsController_1.GetTeams);
router.get("/get", CommonAuth_1.Authenticate, teamsController_1.getTeamByName); // get teams /
router.get('/get/:id', teamsController_1.getTeamById); // get team by id/ 
router.post('/', CommonAuth_1.Authenticate, teamsController_1.AddTeam); //create team
router.put('/:teamid/TeamMembers', CommonAuth_1.Authenticate, teamsController_1.UpdateTeamMembers); //create team
router.post('/:id/AddMember/:memberId', teamsController_1.addMember); //*add member
router.put('/:id', teamsController_1.updateTeam); //update team
router.delete('/:id', teamsController_1.deleteTeam); //!delete team 
router.patch('/:id/UpdateImage', upload.single("CoverImages"), teamsController_1.updateImage);
router.post('/:id/uploadImage', upload.single("CoverImage"), teamsController_1.uploadTeamImage); //delete team
router.get('/:id/tasks', taskController_1.GetTasksOFTeam);
router.get('/:id/tasks/:taskId', taskController_1.GetTaskById);
//& get tasks
router.post('/:id/tasks', taskController_1.addTask),
    // create a tas
    router.put('/:taskid/UpdateStatus', taskController_1.updateIsCompleted);
router.put('/:id/tasks/:taskid', upload.array("CoverImage", 4), taskController_1.updateTask); //* update tasks 
router.put('/tasks/:taskid/UpdateName', taskController_1.updateTaskName); //* update tasks
router.put('/:taskid/UpdateDeadline', taskController_1.updateDeadline); //* update tasks 
router.put('/:taskid/UpdateMembers', taskController_1.updateMembers); //* update tasks
router.put('/:taskid/UpdateFiles', upload.single("File"), taskController_1.updateFiles); //* update tasks
router.delete('/tasks/:taskid', taskController_1.deleteTask);
router.delete('/tasks/:taskid/File/:fileid', taskController_1.deleteFile);
//! Checklist
router.delete('/checklist/:checklistid', ChecklistController_1.deleteChecklist);
router.put('/:taskid/UpdateCheckStatus/:checkid', ChecklistController_1.updateIsCompletedChecklist);
router.put('/:taskid/UpdateCheckName/:checkid', ChecklistController_1.updateChecklistName);
router.post('/:idTask/Checklist', ChecklistController_1.addCheck); // create a a checklist
