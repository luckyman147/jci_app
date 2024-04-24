"use strict";
var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    function adopt(value) { return value instanceof P ? value : new P(function (resolve) { resolve(value); }); }
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : adopt(result.value).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments || [])).next());
    });
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.deleteChecklist = exports.updateChecklistName = exports.updateIsCompletedChecklist = exports.addCheck = void 0;
const class_transformer_1 = require("class-transformer");
const class_validator_1 = require("class-validator");
const teams_dto_1 = require("../../dto/teams.dto");
const CheckListModel_1 = require("../../models/teams/CheckListModel");
const TaskModel_1 = require("../../models/teams/TaskModel");
const addCheck = (req, res, next) => __awaiter(void 0, void 0, void 0, function* () {
    const task = yield TaskModel_1.Task.findById(req.params.idTask);
    if (!task) {
        return res.status(404).json({ error: 'Task not found' });
    }
    try {
        const fitaskInput = (0, class_transformer_1.plainToClass)(teams_dto_1.firstTaskInput, req.body);
        const errors = yield (0, class_validator_1.validate)(fitaskInput, { validationError: { target: false } });
        if (errors.length > 0) {
            return res.status(400).json({ message: 'Input validation failed', errors });
        }
        console.log('heere');
        // Create a new Task instance
        const newCheck = new CheckListModel_1.CheckList({
            name: fitaskInput.name,
        });
        console.log('saved checklist');
        try {
            console.log('on save checklist');
            const savedTask = yield newCheck.save();
            console.log('on save check');
            yield task.CheckList.push(savedTask._id);
            yield task.save();
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
exports.addCheck = addCheck;
const updateIsCompletedChecklist = (req, res, next) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const taskid = req.params.taskid;
        const checkid = req.params.checkid;
        const task = yield TaskModel_1.Task.findById(taskid);
        if (!task) {
            return res.status(404).json({ error: 'task not found' });
        }
        const check = yield CheckListModel_1.CheckList.findById(checkid);
        if (!check) {
            return res.status(404).json({ error: 'check not found' });
        }
        const taskInput = (0, class_transformer_1.plainToClass)(teams_dto_1.IsCompletedInput, req.body);
        const errors = yield (0, class_validator_1.validate)(taskInput, { validationError: { target: false } });
        if (errors.length > 0) {
            return res.status(400).json({ message: 'Input validation failed', errors });
        }
        check.isCompleted = taskInput.IsCompleted;
        yield check.save();
        res.status(200).json({ message: "Completed", check });
    }
    catch (error) {
        console.error(error);
        res.status(500).json({ error: 'Internal server error' });
    }
});
exports.updateIsCompletedChecklist = updateIsCompletedChecklist;
const updateChecklistName = (req, res, next) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const taskid = req.params.taskid;
        const checkid = req.params.checkid;
        const task = yield TaskModel_1.Task.findById(taskid);
        if (!task) {
            return res.status(404).json({ error: 'task not found' });
        }
        const check = yield CheckListModel_1.CheckList.findById(checkid);
        if (!check) {
            return res.status(404).json({ error: 'check not found' });
        }
        const taskInput = (0, class_transformer_1.plainToClass)(teams_dto_1.firstTaskInput, req.body);
        const errors = yield (0, class_validator_1.validate)(taskInput, { validationError: { target: false } });
        if (errors.length > 0) {
            return res.status(400).json({ message: 'Input validation failed', errors });
        }
        check.name = taskInput.name;
        yield check.save();
        res.status(200).json({ message: "Completed", check });
    }
    catch (error) {
        console.error(error);
        res.status(500).json({ error: 'Internal server error' });
    }
});
exports.updateChecklistName = updateChecklistName;
const deleteChecklist = (req, res, next) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const checklistId = req.params.checklistid;
        const check = yield CheckListModel_1.CheckList.findById(checklistId);
        if (!check) {
            return res.status(404).json({ error: 'check not found' });
        }
        // Delete the Team
        yield check.deleteOne();
        res.status(204).json({ message: "deleted successully" });
    }
    catch (error) {
        res.status(500).json({ error: 'Internal server error' });
    }
});
exports.deleteChecklist = deleteChecklist;
