"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.Training = exports.TrainingSchema = void 0;
const mongoose_1 = require("mongoose");
const activitieModel_1 = require("./activitieModel");
exports.TrainingSchema = new mongoose_1.Schema({
    ProfesseurName: { type: String, required: true },
    Duration: { type: Number, required: true },
});
const Training = activitieModel_1.Activity.discriminator('Training', exports.TrainingSchema);
exports.Training = Training;
