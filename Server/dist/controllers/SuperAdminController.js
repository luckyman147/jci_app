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
exports.ChangeToAdmin = void 0;
const Member_1 = require("../models/Member");
const role_1 = require("../utility/role");
const ChangeToAdmin = (req, res, next) => __awaiter(void 0, void 0, void 0, function* () {
    const superAdmin = req.user;
    if (superAdmin) {
        const id = req.params.id;
        const member = yield Member_1.Member.findById(id);
        if (!member) {
            return res.status(404).json({ error: 'Member not found' });
        }
        const role = yield (0, role_1.findrole)('admin');
        member.role = role;
        //Save
        role === null || role === void 0 ? void 0 : role.Members.push(member.id);
        const saved = yield member.save();
        if (saved) {
            return res.status(201).json(saved);
        }
    }
});
exports.ChangeToAdmin = ChangeToAdmin;
