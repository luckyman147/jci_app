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
exports.SearchByName = exports.createRole = exports.GetMemberById = exports.GetMembers = exports.FindMember = void 0;
const Member_1 = require("../models/Member");
const role_1 = require("../models/role");
const FindMember = (id, email) => __awaiter(void 0, void 0, void 0, function* () {
    if (email) {
        return yield Member_1.Member.findOne({ email: email });
    }
    else {
        return yield Member_1.Member.findById(id);
    }
});
exports.FindMember = FindMember;
const GetMembers = (req, res, nex) => __awaiter(void 0, void 0, void 0, function* () {
    const admin = req.user;
    if (admin) {
        const members = yield Member_1.Member.find();
        if (members) {
            return res.json(members);
        }
        return res.json({ "message": "data not available" });
    }
});
exports.GetMembers = GetMembers;
const GetMemberById = (req, res, nex) => __awaiter(void 0, void 0, void 0, function* () {
    const admin = req.user;
    const id = req.params.id;
    const memberById = yield (0, exports.FindMember)(id);
    if (memberById) {
        return res.json(memberById);
    }
    return res.json({ "message": "data not available" });
});
exports.GetMemberById = GetMemberById;
const createRole = (req, res, next) => __awaiter(void 0, void 0, void 0, function* () {
    const admin = req.user;
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
const SearchByName = (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    const admin = req.user;
    if (admin) {
        const name = req.params.name;
        const result = yield Member_1.Member.find({ name: name });
        if (result.length > 0) {
            let membersResult = [];
            result.map(item => {
                membersResult.push(...item.firstName);
            });
            return res.status(200).json(membersResult);
        }
        return res.status(400).json({ "message": " notfound" });
    }
});
exports.SearchByName = SearchByName;
