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
exports.UpdateMemberPermissions = exports.GetAllPermissions = exports.GetPermissionsOfMember = exports.UpdateCotisation = exports.UpdatePoints = exports.validateMember = exports.searchByName = exports.createRole = exports.GetMemberById = exports.GetMembers = exports.changeRole = exports.FindMember = void 0;
const class_transformer_1 = require("class-transformer");
const class_validator_1 = require("class-validator");
const admin_dto_1 = require("../dto/admin.dto");
const Member_1 = require("../models/Member");
const Pemission_1 = require("../models/Pemission");
const role_1 = require("../models/role");
const role_2 = require("../utility/role");
const objectifcheck_1 = require("../utility/objectifcheck");
//& find member
const FindMember = (id, email) => __awaiter(void 0, void 0, void 0, function* () {
    if (email) {
        return yield Member_1.Member.findOne({ email: email });
    }
    else {
        return yield Member_1.Member.findById(id);
    }
});
exports.FindMember = FindMember;
//TODO change role
const changeRole = (req, res, nex) => __awaiter(void 0, void 0, void 0, function* () {
    const admin = req.member;
    if (admin) {
        const roleChanged = req.body;
        const role = (0, role_2.findrole)(roleChanged);
    }
});
exports.changeRole = changeRole;
//* get members
const GetMembers = (req, res, nex) => __awaiter(void 0, void 0, void 0, function* () {
    const members = yield Member_1.Member.find();
    if (members.length > 0) {
        const ALlmembers = yield Promise.all(members // Filtering teams with status true
            .map((member) => __awaiter(void 0, void 0, void 0, function* () {
            return ({
                id: member._id,
                firstName: member.firstName,
                email: member.email,
                Images: yield (0, role_2.getFilesInfoByIds)(member.Images),
            });
        })));
        return res.json(ALlmembers);
    }
    return res.json({ "message": "data not available" });
});
exports.GetMembers = GetMembers;
const GetMemberById = (req, res, nex) => __awaiter(void 0, void 0, void 0, function* () {
    const id = req.params.id;
    const profile = yield Member_1.Member.findById(id);
    if (profile) {
        const [role, teamsInfo, activitiesInfo, trainingsinfo, meetingsInfo, FilesInfo, objectifs] = yield Promise.all([
            (0, role_2.findroleByid)(profile.role),
            (0, role_2.getteamsInfo)(profile.Teams),
            (0, role_2.getActivitiesInfo)(profile.Activities), (0, role_2.getTrainingInfo)(profile.Activities),
            (0, role_2.getMeetingsInfo)(profile.Activities), (0, role_2.getFilesInfoByIds)(profile.Images), (0, objectifcheck_1.CheckObjectif)(profile.id)
        ]);
        const info = { Activities: [{ "Events": activitiesInfo, "Trainings": trainingsinfo, "Meetings": meetingsInfo }],
            id: profile.id,
            firstName: profile.firstName,
            lastName: profile.lastName,
            Images: FilesInfo,
            phone: profile.phone,
            email: profile.email,
            cotisation: profile.cotisation,
            role: role,
            points: profile.Points,
            is_validated: profile.is_validated,
            teams: teamsInfo,
            objectifs: objectifs
        };
        console.log(info);
        return res.status(200).json(info);
    }
    return res.status(404).json({ message: 'member not found' });
});
exports.GetMemberById = GetMemberById;
//? create role
const createRole = (req, res, next) => __awaiter(void 0, void 0, void 0, function* () {
    const admin = req.member;
    const { name, description } = req.body;
    if (admin) {
        const newRole = yield role_1.Role.create({ name: name, description: description });
        if (newRole) {
            return res.status(201).json(newRole);
        }
        return res.status(400).json({ message: "something went wrong" });
    }
});
exports.createRole = createRole;
//find members by name
const searchByName = (req, res, next) => __awaiter(void 0, void 0, void 0, function* () {
    const admin = req.member;
    if (admin) {
        const firstName = req.params.name;
        const result = yield Member_1.Member.find({ firstName: { $regex: new RegExp(firstName, 'i') } })
            .select(['email', 'firstName', 'Images']).sort({ firstName: 1 });
        if (result.length > 0) {
            return res.status(200).json(result);
        }
        return res.status(400).json({ "message": " notfound" });
    }
});
exports.searchByName = searchByName;
const validateMember = (req, res, next) => __awaiter(void 0, void 0, void 0, function* () {
    const id = req.params.id;
    console.log(id);
    const member = yield Member_1.Member.findById(id);
    if (member) {
        member.is_validated = true;
        const saved = yield member.save();
        if (saved) {
            //!send Email
            console.log(saved);
            return res.status(200).json(saved);
        }
        return res.status(400).json({ message: 'error with profile' });
    }
});
exports.validateMember = validateMember;
const UpdatePoints = (req, res, next) => __awaiter(void 0, void 0, void 0, function* () {
    const id = req.params.id;
    const validateAction = (0, class_transformer_1.plainToClass)(admin_dto_1.ValidatePoints, req.body);
    const errors = yield (0, class_validator_1.validate)(validateAction, { validationError: { target: false } });
    if (errors.length > 0) {
        return res.status(400).json({ message: 'Input validation failed', errors });
    }
    const member = yield Member_1.Member.findById(id);
    if (member) {
        member.Points = validateAction.Points;
        const saved = yield member.save();
        if (saved) {
            //send email
            return res.status(200).json(saved);
        }
        return res.status(400).json({ message: 'error with profile' });
    }
    return res.status(404).json({ message: 'member not found' });
});
exports.UpdatePoints = UpdatePoints;
const UpdateCotisation = (req, res, next) => __awaiter(void 0, void 0, void 0, function* () {
    const id = req.params.id;
    const validateAction = (0, class_transformer_1.plainToClass)(admin_dto_1.ValidateCotisation, req.body);
    const errors = yield (0, class_validator_1.validate)(validateAction, { validationError: { target: false } });
    if (errors.length > 0) {
        return res.status(400).json({ message: 'Input validation failed', errors });
    }
    const member = yield Member_1.Member.findById(id);
    if (member) {
        if (validateAction.type == 1) {
            member.cotisation[0] = validateAction.action;
        }
        else {
            if (member.cotisation.length == 1) {
                member.cotisation.push(validateAction.action);
            }
            else {
                member.cotisation[1] = validateAction.action;
            }
        }
        const saved = yield member.save();
        if (saved) {
            //send email
            return res.status(200).json(saved);
        }
        return res.status(400).json({ message: 'error with profile' });
    }
    return res.status(404).json({ message: 'member not found' });
});
exports.UpdateCotisation = UpdateCotisation;
const GetPermissionsOfMember = (req, res, next) => __awaiter(void 0, void 0, void 0, function* () {
    const admin = req.member;
    const id = req.params.id;
    const member = yield Member_1.Member.findById(id);
    if (member) {
        const permission = yield (0, role_2.GetMemberPermission)(member.Permissions);
        return res.status(200).json(permission);
    }
});
exports.GetPermissionsOfMember = GetPermissionsOfMember;
const GetAllPermissions = (req, res, next) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        // Retrieve all permissions from the database
        const permissions = yield Pemission_1.Permission.find();
        // Check if any permissions were found
        if (!permissions || permissions.length === 0) {
            return res.status(404).json({ message: 'No permissions found' });
        }
        // Return the permissions
        return res.status(200).json(permissions);
    }
    catch (error) {
        console.log(error);
        return res.status(500).json({ message: 'Error retrieving permissions' });
    }
});
exports.GetAllPermissions = GetAllPermissions;
const UpdateMemberPermissions = (req, res, next) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const memberId = req.params.id;
        const { permissionId, action } = req.body; // action should be either "add" or "remove"
        // Check if the member with the given ID exists
        const member = yield Member_1.Member.findById(memberId);
        if (!member) {
            return res.status(404).json({ message: 'Member not found' });
        }
        // Check if the permission with the given ID exists
        const permission = yield Pemission_1.Permission.findById(permissionId);
        if (!permission) {
            return res.status(404).json({ message: 'Permission not found' });
        }
        // Check if the action is valid (should be either "add" or "remove")
        if (action !== 'add' && action !== 'remove') {
            return res.status(400).json({ message: 'Invalid action. Action should be either "add" or "remove"' });
        }
        // Update the member's permissions based on the action
        if (action === 'add') {
            // Check if the permission is already in the member's permissions
            if (member.Permissions.includes(permissionId)) {
                return res.status(400).json({ message: 'Permission already exists for this member' });
            }
            // Add the permission to the member's permissions
            member.Permissions.push(permissionId);
        }
        else { // action === 'remove'
            // Remove the permission from the member's permissions
            const index = member.Permissions.indexOf(permissionId);
            if (index !== -1) {
                member.Permissions.splice(index, 1);
            }
            else {
                return res.status(400).json({ message: 'Permission does not exist for this member' });
            }
        }
        // Save the updated member
        yield member.save();
        return res.status(200).json({ permission: member.Permissions });
    }
    catch (error) {
        console.log(error);
        return res.status(500).json({ message: 'Error updating permissions for member' });
    }
});
exports.UpdateMemberPermissions = UpdateMemberPermissions;
