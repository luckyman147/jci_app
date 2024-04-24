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
exports.CheckObjectif = void 0;
const Member_1 = require("../models/Member");
const role_1 = require("./role");
const CheckObjectif = (id) => __awaiter(void 0, void 0, void 0, function* () {
    const profile = yield Member_1.Member.findById(id);
    const [teams, activitiesInfo, trainingsinfo, meetingsInfo] = yield Promise.all([
        (0, role_1.getteamsInfo)(profile.Teams),
        (0, role_1.getActivitiesInfo)(profile.Activities), (0, role_1.getTrainingInfo)(profile.Activities),
        (0, role_1.getMeetingsInfo)(profile.Activities),
    ]);
    const objectives = [
        { "name": "Gain 100 Points", "Condition": profile.Points >= 100 },
        { "name": "Change Profile Picture", "Condition": profile.Images.length > 0 },
        { "name": "Add Phone Number", "Condition": profile.phone.length > 0 },
        { "name": "Join 3 Teams", "Condition": teams.length >= 3 },
        { "name": "Join 3 Events", "Condition": activitiesInfo.length >= 3 },
        { "name": "Join 3 Trainings", "Condition": trainingsinfo.length >= 3 },
        { "name": "Join 3 Meetings", "Condition": meetingsInfo.length >= 3 }
    ];
    return objectives;
});
exports.CheckObjectif = CheckObjectif;
