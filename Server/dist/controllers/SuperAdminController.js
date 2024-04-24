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
exports.deleteLastPres = exports.UpdateLastPres = exports.UpdateLastPresImage = exports.CreateLastPresid = exports.getAllPresidents = exports.DeletePermission = exports.UpdatePermission = exports.CreatePermission = exports.ChangeToMember = exports.ChangeToSuperAdmin = exports.ChangeToAdmin = void 0;
const class_validator_1 = require("class-validator");
const class_transformer_1 = require("class-transformer");
const superAdmin_dto_1 = require("../dto/superAdmin.dto");
const LastPresidents_1 = require("../models/LastPresidents");
const Member_1 = require("../models/Member");
const Pemission_1 = require("../models/Pemission");
const role_1 = require("../models/role");
const utility_1 = require("../utility");
const role_2 = require("../utility/role");
const ChangeToAdmin = (req, res, next) => __awaiter(void 0, void 0, void 0, function* () {
    const superAdmin = req.superadmin;
    const id = req.params.id;
    const member = yield Member_1.Member.findById(id);
    const permissions = yield Pemission_1.Permission.find({ related: { $in: ["Meetings", "Events", "Trainings", "Teams"] } });
    if (!member) {
        return res.status(404).json({ error: 'Member not found' });
    }
    const role = yield (0, role_2.findrole)('admin');
    const memberrole = yield role_1.Role.findById(member.role);
    if (memberrole) {
        memberrole.Members = memberrole.Members.filter(memberid => memberid != member.id);
        yield memberrole.save();
    }
    member.role = role;
    member.cotisation = [true, true];
    member.Permissions = permissions.map(permission => permission.id);
    member.is_validated = true;
    member.Points += 1000;
    //Save
    role === null || role === void 0 ? void 0 : role.Members.push(member.id);
    const saved = yield member.save();
    if (saved) {
        return res.status(201).json(saved);
    }
});
exports.ChangeToAdmin = ChangeToAdmin;
const ChangeToSuperAdmin = (req, res, next) => __awaiter(void 0, void 0, void 0, function* () {
    const superAdmin = req.superadmin;
    const id = req.params.id;
    const member = yield Member_1.Member.findById(id);
    const permissions = yield Pemission_1.Permission.find();
    if (!member) {
        return res.status(404).json({ error: 'Member not found' });
    }
    const role = yield (0, role_2.findrole)('superadmin');
    const memberrole = yield role_1.Role.findById(member.role);
    if (memberrole) {
        memberrole.Members = memberrole.Members.filter(memberid => memberid != member.id);
        yield memberrole.save();
    }
    member.role = role;
    member.cotisation = [true, true];
    member.Permissions = permissions.map(permission => permission.id);
    member.is_validated = true;
    member.Points += 2000;
    //Save
    role === null || role === void 0 ? void 0 : role.Members.push(member.id);
    const saved = yield member.save();
    if (saved) {
        return res.status(201).json(saved);
    }
});
exports.ChangeToSuperAdmin = ChangeToSuperAdmin;
const ChangeToMember = (req, res, next) => __awaiter(void 0, void 0, void 0, function* () {
    const superAdmin = req.superadmin;
    const id = req.params.id;
    const member = yield Member_1.Member.findById(id);
    const permissions = yield Pemission_1.Permission.find({ isPublic: true });
    if (!member) {
        return res.status(404).json({ error: 'Member not found' });
    }
    const role = yield (0, role_2.findrole)('member');
    const memberrole = yield role_1.Role.findById(member.role);
    if (memberrole) {
        memberrole.Members = memberrole.Members.filter(memberid => memberid != member.id);
        yield memberrole.save();
    }
    member.role = role;
    member.Permissions = permissions.map(permission => permission.id);
    //Save
    role === null || role === void 0 ? void 0 : role.Members.push(member.id);
    const saved = yield member.save();
    if (saved) {
        return res.status(201).json(saved);
    }
});
exports.ChangeToMember = ChangeToMember;
const CreatePermission = (req, res, next) => __awaiter(void 0, void 0, void 0, function* () {
    const superAdmin = req.superadmin;
    console.log(superAdmin);
    try {
        const PermissionInputs = (0, class_transformer_1.plainToClass)(superAdmin_dto_1.PermissionInput, req.body);
        const errors = yield (0, class_validator_1.validate)(PermissionInputs, { validationError: { target: false } });
        if (errors.length > 0) {
            return res.status(400).json({ message: 'Input validation failed', errors });
        }
        const { name, description, related, roles, isPublic } = PermissionInputs;
        // Check if the request contains permission ID for update
        const permissionId = req.params.id;
        // Check if permission name already exists
        const existingPermission = yield Pemission_1.Permission.findOne({ name });
        if (existingPermission) {
            return res.status(400).json({ message: 'Permission with the same name already exists' });
        }
        // If permission ID exists, update the permission
        const secureKey = (0, utility_1.generateSecureKey)();
        // Otherwise, create a new permission
        const permission = new Pemission_1.Permission({
            name,
            related,
            key: secureKey,
            roles: roles,
            isPublic: isPublic
        });
        const admin = yield Member_1.Member.findById(superAdmin._id);
        admin === null || admin === void 0 ? void 0 : admin.Permissions.push(permission.id);
        yield admin.save();
        permission.Members.push(admin.id);
        permission.roles.push(admin.role);
        const saved = yield permission.save();
        if (saved) {
            return res.status(201).json(saved);
        }
        return res.status(400).json({ message: 'Error creating permission' });
    }
    catch (error) {
        console.log(error);
        return res.status(500).json({ message: 'Error with permission' });
    }
});
exports.CreatePermission = CreatePermission;
const UpdatePermission = (req, res, next) => __awaiter(void 0, void 0, void 0, function* () {
    // Call CreatePermission function with the permission ID in the URL
    const superAdmin = req.superadmin;
    try {
        const PermissionInputs = (0, class_transformer_1.plainToClass)(superAdmin_dto_1.PermissionInput, req.body);
        const errors = yield (0, class_validator_1.validate)(PermissionInputs, { validationError: { target: false } });
        if (errors.length > 0) {
            return res.status(400).json({ message: 'Input validation failed', errors });
        }
        const { name, description, related, roles, Members } = PermissionInputs;
        // Check if the request contains permission ID
        const permissionId = req.params.id;
        // Check if permission with given ID exists
        const existingPermission = yield Pemission_1.Permission.findById(permissionId);
        if (!existingPermission) {
            return res.status(404).json({ message: 'Permission not found' });
        }
        // Check if the updated name conflicts with other permissions
        const otherPermissionWithSameName = yield Pemission_1.Permission.findOne({ name, _id: { $ne: permissionId } });
        if (otherPermissionWithSameName) {
            return res.status(400).json({ message: 'Another permission with the same name already exists' });
        }
        // Update the permission
        existingPermission.name = name;
        existingPermission.description = description;
        existingPermission.related = related;
        existingPermission.roles = roles,
            existingPermission.Members = Members;
        const updatedPermission = yield existingPermission.save();
        return res.status(200).json(updatedPermission);
    }
    catch (error) {
        console.log(error);
        return res.status(500).json({ message: 'Error updating permission' });
    }
});
exports.UpdatePermission = UpdatePermission;
const DeletePermission = (req, res, next) => __awaiter(void 0, void 0, void 0, function* () {
    const permissionId = req.params.id;
    try {
        const deletedPermission = yield Pemission_1.Permission.findByIdAndDelete(permissionId);
        if (deletedPermission) {
            return res.status(200).json({ message: 'Permission deleted successfully' });
        }
        else {
            return res.status(404).json({ message: 'Permission not found' });
        }
    }
    catch (error) {
        console.log(error);
        return res.status(500).json({ message: 'Error deleting permission' });
    }
});
exports.DeletePermission = DeletePermission;
const getAllPresidents = (req, res, next) => __awaiter(void 0, void 0, void 0, function* () {
    const start = parseInt(req.query.start);
    const limit = parseInt(req.query.limit);
    const startIndex = start;
    const endIndex = start + limit;
    const results = {};
    if (endIndex < (yield LastPresidents_1.LastPresidents.countDocuments().exec())) {
        results.next = {
            start: endIndex,
            limit: limit
        };
    }
    if (startIndex > 0) {
        results.previous = {
            start: Math.max(start - limit, 0), // Ensure start is not negative
            limit: limit
        };
    }
    const presidents = yield LastPresidents_1.LastPresidents.find().sort({ createdAt: 'desc' }).limit(limit).skip(startIndex).exec();
    if (presidents) {
        return res.status(200).json(presidents);
    }
    else {
        return res.status(404).json({ message: 'No presidents found' });
    }
});
exports.getAllPresidents = getAllPresidents;
const CreateLastPresid = (req, res, next) => __awaiter(void 0, void 0, void 0, function* () {
    const superAdmin = req.superadmin;
    const president = (0, class_transformer_1.plainToClass)(superAdmin_dto_1.PresidentsInut, req.body);
    const errors = yield (0, class_validator_1.validate)(president, { validationError: { target: false } });
    if (errors.length > 0) {
        return res.status(400).json({ message: 'Input validation failed', errors });
    }
    // search by name
    const existing = yield LastPresidents_1.LastPresidents.findOne({
        $or: [
            { name: president.name },
            { year: president.year } // Replace x with the desired year value
        ]
    });
    if (existing) {
        return res.status(400).json({ message: 'president already exists' });
    }
    const { name, year } = president;
    const presid = new LastPresidents_1.LastPresidents({
        name, year
    });
    const saved = yield presid.save();
    if (saved) {
        return res.status(201).json(saved);
    }
    else {
        return res.status(400).json({ message: 'Error creating permission' });
    }
});
exports.CreateLastPresid = CreateLastPresid;
const UpdateLastPresImage = (req, res, next) => __awaiter(void 0, void 0, void 0, function* () {
    const superAdmin = req.superadmin;
    const id = req.params.id;
    const presid = yield LastPresidents_1.LastPresidents.findById(id);
    if (!presid) {
        return res.status(404).json({ message: 'Permission not found' });
    }
    const image = req.file;
    if (!image) {
        return res.status(400).send("Invalid or missing image file");
    }
    // Convert the image to base64
    const base64Image = image.buffer.toString('base64');
    presid.CoverImage = base64Image;
    const saved = yield presid.save();
    if (saved) {
        return res.status(201).json(saved);
    }
    else {
        return res.status(400).json({ message: 'Error creating permission' });
    }
});
exports.UpdateLastPresImage = UpdateLastPresImage;
const UpdateLastPres = (req, res, next) => __awaiter(void 0, void 0, void 0, function* () {
    const superAdmin = req.superadmin;
    const president = (0, class_transformer_1.plainToClass)(superAdmin_dto_1.PresidentsInut, req.body);
    const errors = yield (0, class_validator_1.validate)(president, { validationError: { target: false } });
    if (errors.length > 0) {
        return res.status(400).json({ message: 'Input validation failed', errors });
    }
    const { name, year } = president;
    const id = req.params.id;
    const presid = yield LastPresidents_1.LastPresidents.findById(id);
    if (!presid) {
        return res.status(404).json({ message: 'pres not found' });
    }
    presid.name = name;
    presid.year = year;
    const saved = yield presid.save();
    if (saved) {
        return res.status(201).json(saved);
    }
    else {
        return res.status(400).json({ message: 'Error creating pres' });
    }
});
exports.UpdateLastPres = UpdateLastPres;
const deleteLastPres = (req, res, next) => __awaiter(void 0, void 0, void 0, function* () {
    const id = req.params.id;
    const presid = yield LastPresidents_1.LastPresidents.findByIdAndDelete(id);
    if (presid) {
        return res.status(204).json({ message: 'pres deleted successfully' });
    }
    else {
        return res.status(404).json({ message: 'pres not found' });
    }
});
exports.deleteLastPres = deleteLastPres;
