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
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.getPublicPermissions = exports.getPermissionsKeys = exports.getPermissionIdsByRelated = exports.GetMemberPermission = exports.getMeetingsInfo = exports.getTrainingInfo = exports.getActivitiesInfo = exports.getteamsInfo = exports.getFilesInfoByIds = exports.getCheckListsInfoByIds = exports.getTaskById = exports.shortenBase64 = exports.getTasksInfo = exports.getTasksInfoIsCompleted = exports.getMembersInfo = exports.getTeamByEvent = exports.getEventNameById = exports.findroleByid = exports.findrole = void 0;
const crypto_1 = __importDefault(require("crypto"));
const FileModel_1 = require("../models/FileModel");
const Member_1 = require("../models/Member");
const Pemission_1 = require("../models/Pemission");
const TrainingModel_1 = require("../models/activities/TrainingModel");
const eventModel_1 = require("../models/activities/eventModel");
const meetingModel_1 = require("../models/activities/meetingModel");
const role_1 = require("../models/role");
const CheckListModel_1 = require("../models/teams/CheckListModel");
const TaskModel_1 = require("../models/teams/TaskModel");
const team_1 = require("../models/teams/team");
const findrole = (name) => __awaiter(void 0, void 0, void 0, function* () {
    const role = yield role_1.Role.findOne({ name: name });
    if (role) {
        return role;
    }
});
exports.findrole = findrole;
const findroleByid = (id) => __awaiter(void 0, void 0, void 0, function* () {
    const role = yield role_1.Role.findById(id);
    if (role) {
        return role.name;
    }
    throw new Error("Role not found");
});
exports.findroleByid = findroleByid;
const getEventNameById = (eventId) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        // Query the database to find the event by its ID
        const event = yield eventModel_1.Event.findById(eventId);
        // Check if the event is found
        if (event) {
            // Return the event name
            return { name: event.name, ActivityEndDate: event.ActivityEndDate, id: event._id };
        }
        else {
            // Event not found
            return null;
        }
    }
    catch (error) {
        console.error(error);
        throw new Error('Internal server error');
    }
});
exports.getEventNameById = getEventNameById;
const getTeamByEvent = () => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const teamsByEvent = yield team_1.team.aggregate([
            {
                $lookup: {
                    from: 'events', // Assuming your events collection is named 'events'
                    localField: 'Event',
                    foreignField: '_id',
                    as: 'eventInfo',
                },
            },
            {
                $unwind: {
                    path: '$eventInfo',
                    preserveNullAndEmptyArrays: true,
                },
            },
            {
                $group: {
                    _id: '$Event', // Group by the Event field
                    teams: { $push: '$$ROOT' },
                },
            },
        ]);
        return teamsByEvent;
    }
    catch (error) {
        throw error;
    }
});
exports.getTeamByEvent = getTeamByEvent;
const getMembersInfo = (memberIds) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        // Query the database to find members by their IDs
        const members = yield Member_1.Member.find({ _id: { $in: memberIds } });
        const membersInfo = Promise.all(members.map((member) => __awaiter(void 0, void 0, void 0, function* () {
            return ({
                _id: member._id,
                firstName: member.firstName,
                Images: yield (0, exports.getFilesInfoByIds)(member.Images),
                // Add other fields you want to include
            });
        })));
        console.log(membersInfo);
        return membersInfo;
    }
    catch (error) {
        console.error(error);
        throw new Error('Internal server error');
    }
});
exports.getMembersInfo = getMembersInfo;
const getTasksInfoIsCompleted = (taskIds) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        // Query the database to find tasks by their IDs
        const tasks = yield TaskModel_1.Task.find({ _id: { $in: taskIds } });
        const tasksInfo = tasks.map((task) => ({
            isCompleted: task.isCompleted,
            // Add other fields you want to include
        }));
        console.log(tasksInfo);
        return tasksInfo;
    }
    catch (error) {
        console.error(error);
        throw new Error('Internal server error');
    }
});
exports.getTasksInfoIsCompleted = getTasksInfoIsCompleted;
const getTasksInfo = (taskIds) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        // Query the database to find tasks by their IDs
        const tasks = yield TaskModel_1.Task.find({ _id: { $in: taskIds } });
        const tasksInfo = yield Promise.all(tasks.map((task) => __awaiter(void 0, void 0, void 0, function* () {
            return ({
                id: task._id,
                name: task.name,
                AssignTo: yield (0, exports.getMembersInfo)(task.AssignTo),
                Deadline: task.Deadline,
                StartDate: task.StartDate,
                attachedFile: yield (0, exports.getFilesInfoByIds)(task.attachedFile),
                isCompleted: task.isCompleted,
                CheckList: yield (0, exports.getCheckListsInfoByIds)(task.CheckList),
                // Add other fields you want to include
            });
        })));
        console.log(tasksInfo);
        return tasksInfo;
    }
    catch (error) {
        console.error(error);
        throw new Error('Internal server error');
    }
});
exports.getTasksInfo = getTasksInfo;
function shortenBase64(base64String) {
    // Convert the base64 string to a Buffer
    const bufferData = Buffer.from(base64String, 'base64');
    // Create a hash using SHA-256
    const sha256Hash = crypto_1.default.createHash('sha256').update(bufferData).digest('hex');
    // Take the first 8 characters of the hash as a shortened phrase
    const shortenedPhrase = sha256Hash.slice(0, 8);
    return shortenedPhrase;
}
exports.shortenBase64 = shortenBase64;
const getTaskById = (taskId) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const task = yield TaskModel_1.Task.findById(taskId);
        if (!task) {
            throw new Error(`Task with ID ${taskId} not found`);
        }
        return task;
    }
    catch (error) {
        return null;
    }
});
exports.getTaskById = getTaskById;
const getCheckListsInfoByIds = (checkListIds) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const checkLists = yield CheckListModel_1.CheckList.find({ _id: { $in: checkListIds } });
        const checkListsInfo = checkLists.map((checkList) => ({
            id: checkList._id,
            name: checkList.name,
            isCompleted: checkList.isCompleted,
        }));
        return checkListsInfo;
    }
    catch (error) {
        console.error(error);
        throw new Error('Internal server error');
    }
});
exports.getCheckListsInfoByIds = getCheckListsInfoByIds;
const getFilesInfoByIds = (checkListIds) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const Files = yield FileModel_1.File.find({ _id: { $in: checkListIds } });
        const FilesInfo = Files.map((file) => ({
            id: file._id,
            url: file.url,
            extension: file.extension,
            path: file.path,
        }));
        return FilesInfo;
    }
    catch (error) {
        console.error(error);
        throw new Error('Internal server error');
    }
});
exports.getFilesInfoByIds = getFilesInfoByIds;
const getteamsInfo = (teamsIds) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        // Query the database to find members by their IDs
        const teams = yield team_1.team.find({ _id: { $in: teamsIds } });
        const teamsInfo = Promise.all(teams.map((team) => __awaiter(void 0, void 0, void 0, function* () {
            return ({
                id: team._id,
                name: team.name,
                CoverImage: team.CoverImage,
                status: team.status,
                Members: yield (0, exports.getMembersInfo)(team.Members)
                // Add other fields you want to include
            });
        })));
        console.log(teams);
        return teamsInfo;
    }
    catch (error) {
        console.error(error);
        throw new Error('Internal server error');
    }
});
exports.getteamsInfo = getteamsInfo;
const getActivitiesInfo = (EventsIds) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        // Query the database to find members by their IDs
        const Events = yield eventModel_1.Event.find({ _id: { $in: EventsIds } });
        console.log(Events);
        const EventsInfo = Promise.all(Events.map((act) => __awaiter(void 0, void 0, void 0, function* () {
            return ({
                id: act._id,
                name: act.name,
                CoverImages: act.CoverImages,
                Members: yield (0, exports.getMembersInfo)(act.Participants)
                // Add other fields you want to include
            });
        })));
        return EventsInfo;
    }
    catch (error) {
        console.error(error);
        throw new Error('Internal server error');
    }
});
exports.getActivitiesInfo = getActivitiesInfo;
const getTrainingInfo = (EventsIds) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        // Query the database to find members by their IDs
        const trainings = yield TrainingModel_1.Training.find({ _id: { $in: EventsIds } });
        console.log(trainings);
        const trainingsInfo = Promise.all(trainings.map((act) => __awaiter(void 0, void 0, void 0, function* () {
            return ({
                id: act._id,
                name: act.name,
                CoverImages: act.CoverImages,
                Members: yield (0, exports.getMembersInfo)(act.Participants)
                // Add other fields you want to include
            });
        })));
        return trainingsInfo;
    }
    catch (error) {
        console.error(error);
        throw new Error('Internal server error');
    }
});
exports.getTrainingInfo = getTrainingInfo;
const getMeetingsInfo = (EventsIds) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        // Query the database to find members by their IDs
        const Meetings = yield meetingModel_1.Meeting.find({ _id: { $in: EventsIds } });
        console.log(Meetings);
        const MeetingsInfo = Promise.all(Meetings.map((act) => __awaiter(void 0, void 0, void 0, function* () {
            return ({
                id: act._id,
                name: act.name,
                CoverImages: act.CoverImages,
                Members: yield (0, exports.getMembersInfo)(act.Participants)
                // Add other fields you want to include
            });
        })));
        return MeetingsInfo;
    }
    catch (error) {
        console.error(error);
        throw new Error('Internal server error');
    }
});
exports.getMeetingsInfo = getMeetingsInfo;
const GetMemberPermission = (memberPermissionIds) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const permissions = yield Pemission_1.Permission.find({ _id: { $in: memberPermissionIds } });
        console.log(permissions);
        if (permissions.length > 0) {
            const permissionsInfo = permissions.map((permission) => ({
                id: permission._id,
                name: permission.name,
                description: permission.description,
            }));
            return permissionsInfo;
        }
        else {
            return [];
        }
    }
    catch (e) {
        console.log(e);
    }
});
exports.GetMemberPermission = GetMemberPermission;
const getPermissionIdsByRelated = (searchStrings) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const permissions = yield Pemission_1.Permission.find({ related: { $in: searchStrings } });
        const permissionIds = permissions.map(permission => permission.key);
        return permissionIds;
    }
    catch (error) {
        console.error('Error retrieving permission IDs:', error);
        throw error;
    }
});
exports.getPermissionIdsByRelated = getPermissionIdsByRelated;
const getPermissionsKeys = (searchStrings, role) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const permissions = yield Pemission_1.Permission.find({
            $or: [
                { _id: { $in: searchStrings } }, // Find by IDs
                { roles: role } // Find by role
            ]
        });
        return permissions.map(permission => permission.key);
    }
    catch (error) {
        console.error('Error retrieving permissions:', error);
        throw error;
    }
});
exports.getPermissionsKeys = getPermissionsKeys;
const getPublicPermissions = () => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const permissions = yield Pemission_1.Permission.find({ isPublic: true });
        return permissions;
    }
    catch (error) {
        console.error('Error retrieving public permissions:', error);
        throw error;
    }
});
exports.getPublicPermissions = getPublicPermissions;
