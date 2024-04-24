"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.Meeting = exports.MeetingSchema = void 0;
const mongoose_1 = require("mongoose");
const activitieModel_1 = require("./activitieModel");
exports.MeetingSchema = new mongoose_1.Schema({
    Director: {
        type: mongoose_1.Schema.Types.ObjectId,
        ref: 'Member',
        required: true
    },
    Agenda: {
        type: [String],
        required: true
    }
});
const Meeting = activitieModel_1.Activity.discriminator('Meeting', exports.MeetingSchema);
exports.Meeting = Meeting;
