"use strict";
var __createBinding = (this && this.__createBinding) || (Object.create ? (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    var desc = Object.getOwnPropertyDescriptor(m, k);
    if (!desc || ("get" in desc ? !m.__esModule : desc.writable || desc.configurable)) {
      desc = { enumerable: true, get: function() { return m[k]; } };
    }
    Object.defineProperty(o, k2, desc);
}) : (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    o[k2] = m[k];
}));
var __setModuleDefault = (this && this.__setModuleDefault) || (Object.create ? (function(o, v) {
    Object.defineProperty(o, "default", { enumerable: true, value: v });
}) : function(o, v) {
    o["default"] = v;
});
var __importStar = (this && this.__importStar) || function (mod) {
    if (mod && mod.__esModule) return mod;
    var result = {};
    if (mod != null) for (var k in mod) if (k !== "default" && Object.prototype.hasOwnProperty.call(mod, k)) __createBinding(result, mod, k);
    __setModuleDefault(result, mod);
    return result;
};
var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    function adopt(value) { return value instanceof P ? value : new P(function (resolve) { resolve(value); }); }
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : adopt(result.value).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments || [])).next());
    });
};
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.deleteFile = exports.deleteTask = exports.updateTaskName = exports.updateMembers = exports.updateDeadline = exports.updateIsCompleted = exports.updateFiles = exports.updateTask = exports.addTask = exports.GetTaskById = exports.GetTasksOFTeam = void 0;
const class_transformer_1 = require("class-transformer");
const class_validator_1 = require("class-validator");
const moment_1 = __importDefault(require("moment"));
const path = __importStar(require("path"));
const teams_dto_1 = require("../../dto/teams.dto");
const FileModel_1 = require("../../models/FileModel");
const CheckListModel_1 = require("../../models/teams/CheckListModel");
const TaskModel_1 = require("../../models/teams/TaskModel");
const team_1 = require("../../models/teams/team");
const role_1 = require("../../utility/role");
const GetTasksOFTeam = (req, res, next) => __awaiter(void 0, void 0, void 0, function* () {
    const id = req.params.id;
    const Team = yield team_1.team.findById(id);
    if (Team) {
        const tasks = Team.tasks;
        if (tasks.length > 0) {
            res.status(200).json(yield (0, role_1.getTasksInfo)(tasks));
        }
        else {
            res.status(404).json({ error: "No tasks found" });
        }
    }
    else {
        res.status(404).json({ error: "No team found" });
    }
});
exports.GetTasksOFTeam = GetTasksOFTeam;
const GetTaskById = (req, res, next) => __awaiter(void 0, void 0, void 0, function* () {
    const id = req.params.id;
    const taskId = req.params.taskId;
    const Team = yield team_1.team.findById(id);
    if (Team) {
        const task = yield (0, role_1.getTaskById)(taskId);
        if (task) {
            res.status(200).json({
                id: task._id,
                name: task.name,
                AssignTo: yield (0, role_1.getMembersInfo)(task.AssignTo),
                Deadline: task.Deadline,
                attachedFile: yield (0, role_1.getFilesInfoByIds)(task.attachedFile),
                description: task.description,
                StartDate: task.StartDate,
                isCompleted: task.isCompleted,
                CheckList: yield (0, role_1.getCheckListsInfoByIds)(task.CheckList),
            });
        }
        else {
            res.status(404).json({ error: "No task found" });
        }
    }
    else {
        res.status(404).json({ error: "No team found" });
    }
});
exports.GetTaskById = GetTaskById;
const addTask = (req, res, next) => __awaiter(void 0, void 0, void 0, function* () {
    const Team = yield team_1.team.findById(req.params.id);
    if (!Team) {
        return res.status(404).json({ error: 'Team not found' });
    }
    try {
        const fitaskInput = (0, class_transformer_1.plainToClass)(teams_dto_1.firstTaskInput, req.body);
        const errors = yield (0, class_validator_1.validate)(fitaskInput, { validationError: { target: false } });
        if (errors.length > 0) {
            return res.status(400).json({ message: 'Input validation failed', errors });
        }
        console.log('heere');
        // Create a new Task instance
        const newTask = new TaskModel_1.Task({
            name: fitaskInput.name,
        });
        console.log('saved task');
        try {
            const savedTask = yield newTask.save();
            yield Team.tasks.push(savedTask._id);
            yield Team.save();
            res.status(201).json(savedTask);
        }
        catch (err) {
            console.log("error", err);
        }
    }
    catch (error) {
        res.status(500).json({ error: error });
    }
});
exports.addTask = addTask;
//& update tasks
const updateTask = (req, res, next) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const teamId = req.params.id;
        const taskId = req.params.taskid;
        const Team = yield team_1.team.findById(teamId);
        if (!Team) {
            return res.status(404).json({ error: 'Team not found' });
        }
        const taskToUpdate = Team.tasks.find((task) => task._id.toString() === taskId);
        if (!taskToUpdate) {
            return res.status(404).json({ error: 'Task not found in the team' });
        }
        const taskInput = (0, class_transformer_1.plainToClass)(teams_dto_1.TaskInput, req.body);
        const errors = yield (0, class_validator_1.validate)(taskInput, { validationError: { target: false } });
        if (errors.length > 0) {
            return res.status(400).json({ message: 'Input validation failed', errors });
        }
        if (!Team.Members.includes(taskInput.AssignTo)) {
            return res.status(400).json({ error: 'Member not found in team' });
        }
        const checkListItems = taskInput.CheckList.map((item) => new CheckListModel_1.CheckList({ name: item.name, Deadline: item.Deadline }));
        const savedCheckListItems = yield CheckListModel_1.CheckList.insertMany(checkListItems);
        const attachedFile = req.files;
        if (!attachedFile || attachedFile.length === 0) {
            console.log(attachedFile);
            return res.status(400).send("Invalid or missing files");
        }
        // Convert images to base64
        const base64files = attachedFile.map((attachedFiles) => attachedFiles.buffer.toString('base64'));
        // Update the existing task with new information
        taskToUpdate.name = taskInput.name;
        taskToUpdate.AssignTo = taskInput.AssignTo;
        taskToUpdate.Deadline = taskInput.Deadline;
        taskToUpdate.attachedFile = base64files;
        taskToUpdate.description = taskInput.description;
        taskToUpdate.StartDate = taskInput.StartDate;
        taskToUpdate.CheckList = savedCheckListItems.map((item) => item._id);
        // Save the updated team
        const savedTeam = yield Team.save();
        yield taskToUpdate.save();
        res.status(200).json({ updatedTask: taskToUpdate, team: savedTeam });
    }
    catch (error) {
        console.error(error);
        res.status(500).json({ error: 'Internal server error' });
    }
});
exports.updateTask = updateTask;
const updateFiles = (req, res, next) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const taskId = req.params.taskid;
        const taskToUpdate = yield TaskModel_1.Task.findById(taskId);
        if (!taskToUpdate) {
            return res.status(404).json({ error: 'Task not found in the team' });
        }
        console.log(req.file);
        const attachedFile = req.file;
        if (!attachedFile) {
            return res.status(400).send('Invalid or missing files');
        }
        const fileExtension = path.extname(attachedFile.originalname);
        const founded = yield FileModel_1.File
            .findOne({ path: attachedFile.originalname });
        if (!founded) {
            // Convert the file to a base64 string
            const base64File = attachedFile.buffer.toString('base64');
            const file = new FileModel_1.File({
                path: attachedFile.originalname,
                url: base64File,
                extension: fileExtension,
            });
            taskToUpdate.attachedFile.push(file._id);
            yield file.save();
            yield taskToUpdate.save();
            res.status(200).json(file);
        }
        else {
            if (taskToUpdate.attachedFile.includes(founded._id)) {
                return res.status(400).json({ error: 'File already exists' });
            }
            else {
                taskToUpdate.attachedFile.push(founded._id);
                yield taskToUpdate.save();
                res.status(200).json(founded);
            }
        }
    }
    catch (error) {
        console.error(error);
        res.status(500).json({ error: 'Internal server error' });
    }
});
exports.updateFiles = updateFiles;
const updateIsCompleted = (req, res, next) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const teamId = req.params.id;
        const taskId = req.params.taskid;
        const task = yield TaskModel_1.Task.findById(taskId);
        if (!task) {
            return res.status(404).json({ error: 'task not found' });
        }
        const taskInput = (0, class_transformer_1.plainToClass)(teams_dto_1.IsCompletedInput, req.body);
        const errors = yield (0, class_validator_1.validate)(taskInput, { validationError: { target: false } });
        if (errors.length > 0) {
            return res.status(400).json({ message: 'Input validation failed', errors });
        }
        task.isCompleted = taskInput.IsCompleted;
        yield task.save();
        res.status(200).json({ message: "Completed", task });
    }
    catch (error) {
        console.error(error);
        res.status(500).json({ error: 'Internal server error' });
    }
});
exports.updateIsCompleted = updateIsCompleted;
const updateDeadline = (req, res, next) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const taskId = req.params.taskid;
        const task = yield TaskModel_1.Task.findById(taskId);
        if (!task) {
            return res.status(404).json({ error: 'task not found' });
        }
        const timelineInput = (0, class_transformer_1.plainToClass)(teams_dto_1.TimelineInput, req.body);
        const errors = yield (0, class_validator_1.validate)(timelineInput, { validationError: { target: false } });
        if (errors.length > 0) {
            return res.status(400).json({ message: 'Input validation failed', errors });
        }
        console.log(timelineInput);
        const startDateUtc = moment_1.default.utc(timelineInput.StartDate).toDate();
        console.log(startDateUtc);
        const deadlineUtc = moment_1.default.utc(timelineInput.Deadline).toDate();
        task.StartDate = startDateUtc;
        task.Deadline = deadlineUtc;
        yield task.save();
        console.log(task);
        res.status(200).json({ message: "Completed", task });
    }
    catch (error) {
        console.error(error);
        res.status(500).json({ error: 'Internal server error' });
    }
});
exports.updateDeadline = updateDeadline;
const updateMembers = (req, res, next) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const taskId = req.params.taskid;
        const task = yield TaskModel_1.Task.findById(taskId);
        if (!task) {
            return res.status(404).json({ error: 'task not found' });
        }
        const membersInput = (0, class_transformer_1.plainToClass)(teams_dto_1.MembersInput, req.body);
        const errors = yield (0, class_validator_1.validate)(membersInput, { validationError: { target: false } });
        if (errors.length > 0) {
            return res.status(400).json({ message: 'Input validation failed', errors });
        }
        console.log(membersInput.Status);
        //        if (task.AssignTo.includes(membersInput.Member) && membersInput.Status=="true"){
        // return res.status(400).json({ error: 'Member already exists' });}
        if (membersInput.Status == "true") {
            console.log(membersInput.Member);
            console.log(membersInput.Status);
            yield task.AssignTo.push(membersInput.Member);
            yield task.save();
            res.status(200).json({ message: "Completed", task });
        }
        else {
            console.log(membersInput.Member);
            task.AssignTo = task.AssignTo.filter((member) => member._id.toString() !== membersInput.Member.toString());
            yield task.save();
            res.status(200).json({ message: "Completed", task });
        }
    }
    catch (error) {
        console.error(error);
        res.status(500).json({ error: 'Internal server error' });
    }
});
exports.updateMembers = updateMembers;
const updateTaskName = (req, res, next) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const taskId = req.params.taskid;
        const task = yield TaskModel_1.Task.findById(taskId);
        if (!task) {
            return res.status(404).json({ error: 'task not found' });
        }
        const taskInput = (0, class_transformer_1.plainToClass)(teams_dto_1.firstTaskInput, req.body);
        const errors = yield (0, class_validator_1.validate)(taskInput, { validationError: { target: false } });
        if (errors.length > 0) {
            return res.status(400).json({ message: 'Input validation failed', errors });
        }
        task.name = taskInput.name;
        yield task.save();
        res.status(200).json({ message: "Completed", task });
    }
    catch (error) {
        console.error(error);
        res.status(500).json({ error: 'Internal server error' });
    }
});
exports.updateTaskName = updateTaskName;
const deleteTask = (req, res, next) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const taskId = req.params.taskid;
        const task = yield TaskModel_1.Task.findById(taskId);
        if (!task) {
            return res.status(404).json({ error: 'Task not found' });
        }
        // Delete the Team
        yield task.deleteOne();
        res.status(204).json({ message: "deleted successully" });
    }
    catch (error) {
        console.error(error);
        res.status(500).json({ error: 'Internal server error' });
    }
});
exports.deleteTask = deleteTask;
const deleteFile = (req, res, next) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const taskId = req.params.taskid;
        const fileId = req.params.fileid;
        const task = yield TaskModel_1.Task.findById(taskId);
        if (!task) {
            console.log("task not found");
            return res.status(404).json({ error: 'Task not found' });
        }
        const file = yield FileModel_1.File.findById(fileId);
        if (!file) {
            console.log("file not found");
            return res.status(404).json({ error: 'File not found' });
        }
        task.attachedFile = task.attachedFile.filter((file) => file._id.toString() !== file._id.toString());
        yield file.deleteOne();
        yield task.save();
        res.status(204).json({ message: "deleted successully" });
    }
    catch (error) {
        console.error(error);
        res.status(500).json({ error: 'Internal server error' });
    }
});
exports.deleteFile = deleteFile;
