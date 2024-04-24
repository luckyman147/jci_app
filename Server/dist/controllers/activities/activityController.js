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
exports.GetActivityByname = exports.GetActivityByid = void 0;
const activitieModel_1 = require("../../models/activities/activitieModel");
const GetActivityByid = (req, res, next) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const id = req.params.id;
        const activitie = yield activitieModel_1.Activity.findById(id);
        if (activitie) {
            res.json(activitie);
        }
        else {
            res.status(404).json({ message: "No event found with this id" });
        }
    }
    catch (error) {
        console.error('Error retrieving event by id:', error);
        next(error);
    }
});
exports.GetActivityByid = GetActivityByid;
const GetActivityByname = (req, res, next) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const name = req.params.name;
        const activitie = yield activitieModel_1.Activity.findOne({ name });
        if (activitie) {
            res.json(activitie);
        }
        else {
            res.status(404).json({ message: "No event found with this name" });
        }
    }
    catch (error) {
        console.error('Error retrieving event by name:', error);
        next(error);
    }
});
exports.GetActivityByname = GetActivityByname;
