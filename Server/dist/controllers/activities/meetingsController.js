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
exports.deleteMeeting = exports.RemoveParticipantFrommeeting = exports.AddParticipantTomeeting = exports.GetmeetingsOfWeekend = exports.uploadImage = exports.getmeetingByDate = exports.getmeetingByName = exports.getmeetingById = exports.addmeeting = exports.updateMeeting = exports.getAllmeetings = void 0;
const class_transformer_1 = require("class-transformer");
const activity_dto_1 = require("../../dto/activity.dto");
const Member_1 = require("../../models/Member");
const class_validator_1 = require("class-validator");
const meetingModel_1 = require("../../models/activities/meetingModel");
const role_1 = require("../../utility/role");
//&Public
const getAllmeetings = (req, res, next) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        // Fetch all meetings and sort them by ActivityBeginDate in ascending order
        const meetings = yield meetingModel_1.Meeting.find().sort({ ActivityBeginDate: -1 });
        const permission = yield (0, role_1.getPermissionIdsByRelated)(["Meetings"]);
        // Format and send the meetings in the response
        const formattedmeetings = meetings.map((meeting) => ({
            _id: meeting._id,
            name: meeting.name,
            Director: meeting.Director,
            Agenda: meeting.Agenda,
            IsPart: meeting.Participants.some((member) => member._id.equals(req.body.id)),
            ActivityBegindate: meeting.ActivityBeginDate,
            ActivityEnddate: meeting.ActivityEndDate,
            description: meeting.description,
            ActivityPoints: meeting.ActivityPoints,
            categorie: meeting.categorie,
            participants: meeting.Participants,
        }));
        res.json({ Permissions: permission,
            meetings: formattedmeetings });
    }
    catch (error) {
        console.error('Error retrieving all meetings:', error);
        next(error);
    }
});
exports.getAllmeetings = getAllmeetings;
//&Private
const updateMeeting = (req, res, next) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        // Extract data from the request body
        const meetingInputs = (0, class_transformer_1.plainToClass)(activity_dto_1.MeetingInputs, req.body);
        // Validate the inputs
        const errors = yield (0, class_validator_1.validate)(meetingInputs, { validationError: { target: false } });
        if (errors.length > 0) {
            return res.status(400).json({ message: 'Input validation failed', errors });
        }
        const meetingId = req.params.id;
        // Find the existing meeting by ID
        const existingMeeting = yield meetingModel_1.Meeting.findById(meetingId);
        if (!existingMeeting) {
            return res.status(404).json({ message: 'Meeting not found' });
        }
        // Update the existing meeting properties
        existingMeeting.name = meetingInputs.name;
        existingMeeting.description = meetingInputs.description;
        existingMeeting.ActivityBeginDate = meetingInputs.ActivityBeginDate;
        existingMeeting.Agenda = meetingInputs.agenda;
        existingMeeting.Director = meetingInputs.Director;
        existingMeeting.categorie = meetingInputs.categorie;
        existingMeeting.ActivityPoints = meetingInputs.ActivityPoints;
        existingMeeting.Price = meetingInputs.price;
        // Save the updated meeting
        const updatedMeeting = yield existingMeeting.save();
        res.json(updatedMeeting);
    }
    catch (error) {
        console.error('Error updating meeting:', error);
        next(error);
    }
});
exports.updateMeeting = updateMeeting;
const addmeeting = (req, res, next) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        // Extract data from the request body
        const meetingInputs = (0, class_transformer_1.plainToClass)(activity_dto_1.MeetingInputs, req.body);
        // Validate the inputs
        const errors = yield (0, class_validator_1.validate)(meetingInputs, { validationError: { target: false } });
        if (errors.length > 0) {
            return res.status(400).json({ message: 'Input validation failed', errors });
        }
        // Create a meeting document
        const newMeeting = new meetingModel_1.Meeting({
            name: meetingInputs.name,
            description: meetingInputs.description,
            ActivityBeginDate: meetingInputs.ActivityBeginDate,
            Agenda: meetingInputs.agenda,
            Director: meetingInputs.Director,
            price: meetingInputs.price,
            categorie: meetingInputs.categorie,
            ActivityPoints: meetingInputs.ActivityPoints,
            Participants: []
        });
        // Add the meeting to the database
        const savedMeeting = yield newMeeting.save();
        res.json(savedMeeting);
    }
    catch (error) {
        console.error('Error adding meeting:', error);
        next(error);
    }
});
exports.addmeeting = addmeeting;
const getmeetingById = (req, res, next) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const id = req.params.id;
        const Permissions = yield (0, role_1.getPermissionIdsByRelated)(["Meetings"]);
        const meeting = yield meetingModel_1.Meeting.findById(id);
        if (meeting) {
            res.json({
                _id: meeting._id,
                name: meeting.name,
                Director: yield findParticipentById(meeting.Director),
                Agenda: meeting.Agenda,
                IsPart: meeting.Participants.some((member) => member._id.equals(req.body.id)),
                ActivityBegindate: meeting.ActivityBeginDate,
                description: meeting.description,
                ActivityPoints: meeting.ActivityPoints,
                categorie: meeting.categorie,
                Permissions: Permissions,
                participants: yield (0, role_1.getMembersInfo)(meeting.Participants),
            });
        }
        else {
            res.status(404).json({ message: "No meeting found with this id" });
        }
    }
    catch (error) {
        console.error('Error retrieving meeting by id:', error);
        next(error);
    }
});
exports.getmeetingById = getmeetingById;
const findParticipentById = (id) => __awaiter(void 0, void 0, void 0, function* () {
    const member = yield Member_1.Member.findById(id);
    if (member) {
        return member.firstName;
    }
    return null;
});
const getmeetingByName = (req, res, next) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const name = req.params.name;
        const meeting = yield meetingModel_1.Meeting.findOne({ name: name });
        if (meeting) {
            res.json(meeting);
        }
        else {
            res.status(404).json({ message: "No meeting found with this name" });
        }
    }
    catch (error) {
        console.error('Error retrieving meeting by name:', error);
        next(error);
    }
});
exports.getmeetingByName = getmeetingByName;
const getmeetingByDate = (req, res, next) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const date = req.params.date;
        const meeting = yield meetingModel_1.Meeting.findOne({ ActivityBeginDate: date });
        if (meeting) {
            res.json(meeting);
        }
        else {
            res.status(404).json({ message: "No meeting found with this date" });
        }
    }
    catch (error) {
        console.error('Error retrieving meeting by date:', error);
        next(error);
    }
});
exports.getmeetingByDate = getmeetingByDate;
const uploadImage = (req, res, next) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const id = req.params.id;
        // Find the meeting
        const meeting = yield meetingModel_1.Meeting.findById(id);
        if (!meeting)
            return res.status(401).send("No such meeting");
        const images = req.files;
        console.log(images);
        // Convert images to base64
        const base64Images = images.map((image) => image.buffer.toString('base64'));
        // Add the images to the meeting
        meeting.CoverImages.push(...base64Images);
        // Save the meeting
        const savedmeeting = yield meeting.save();
        res.json(savedmeeting);
    }
    catch (error) {
        console.error('Error uploading image:', error);
        next(error);
    }
});
exports.uploadImage = uploadImage;
const GetmeetingsOfWeekend = (req, res, next) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const currentDate = new Date();
        const currentDay = currentDate.getDay();
        // Calculate the first day of the week (Monday)
        const firstDayOfWeek = new Date(currentDate.getFullYear(), currentDate.getMonth(), currentDate.getDate() - currentDay + (currentDay === 0 ? -6 : 1));
        // Calculate the last day of the week (Sunday)
        const lastDayOfWeek = new Date(currentDate.getFullYear(), currentDate.getMonth(), currentDate.getDate() - currentDay + 7);
        const meetingsOfWeek = yield meetingModel_1.Meeting.find({
            ActivityBeginDate: { $gte: firstDayOfWeek, $lte: lastDayOfWeek },
        });
        if (meetingsOfWeek.length > 0) {
            const formattedMeetings = meetingsOfWeek.map((meeting) => ({
                _id: meeting._id,
                name: meeting.name,
                Director: meeting.Director,
                Agenda: meeting.Agenda,
                ActivityBegindate: meeting.ActivityBeginDate,
                description: meeting.description,
                ActivityPoints: meeting.ActivityPoints,
                categorie: meeting.categorie,
                IsPart: meeting.Participants.some((member) => member._id.equals(req.body.id)),
                participants: meeting.Participants,
            }));
            res.json({ meetings: formattedMeetings });
        }
        else {
            res.json({ message: "No meetings found for this week" });
        }
    }
    catch (error) {
        console.error('Error retrieving meetings of the week:', error);
        next(error);
    }
});
exports.GetmeetingsOfWeekend = GetmeetingsOfWeekend;
const AddParticipantTomeeting = (req, res, next) => __awaiter(void 0, void 0, void 0, function* () {
    const member = req.member;
    if (member) {
        try {
            const meetingId = req.params.idmeeting;
            console.log(meetingId);
            // Find the meeting by ID
            const meeting = yield meetingModel_1.Meeting.findById(meetingId);
            console.log(meeting);
            if (!meeting) {
                return res.status(404).json({ message: 'meeting not found' });
            }
            // Check if the participant is already added
            if (meeting.Participants.includes(member._id)) {
                return res.status(400).json({ message: 'Participant is already added to the meeting' });
            }
            // Add the participant to the Participants array
            yield meeting.Participants.push(member);
            // Save the updated meeting
            const updatedmeeting = yield meeting.save();
            // Respond with the updated meeting
            res.status(200).json({ message: 'Participant added to the meeting', meeting: updatedmeeting });
        }
        catch (error) {
            res.status(500).json({ message: 'Error adding participant to the meeting' });
        }
    }
});
exports.AddParticipantTomeeting = AddParticipantTomeeting;
// Import your Member model
const RemoveParticipantFrommeeting = (req, res, next) => __awaiter(void 0, void 0, void 0, function* () {
    const member = req.member;
    if (member) {
        try {
            const meetingId = req.params.id;
            const participantId = member._id;
            // Find the meeting by ID
            const meeting = yield meetingModel_1.Meeting.findById(meetingId);
            if (!meeting) {
                return res.status(404).json({ message: 'meeting not found' });
            }
            // Find the participant by ID
            const participant = yield Member_1.Member.findById(participantId);
            if (!participant) {
                return res.status(404).json({ message: 'Participant not found' });
            }
            // Check if the participant is added to the meeting
            const isParticipantAdded = meeting.Participants.some((member) => member._id.equals(participantId));
            if (!isParticipantAdded) {
                return res.status(400).json({ message: 'Participant is not added to the meeting' });
            }
            // Remove the participant from the Participants array
            meeting.Participants = meeting.Participants.filter((member) => !member._id.equals(participantId));
            // Save the updated meeting
            const updatedmeeting = yield meeting.save();
            // Respond with the updated meeting
            res.json({ message: 'Participant removed from the meeting', meeting: updatedmeeting });
        }
        catch (error) {
            res.status(500).json({ message: 'Error removing participant from meeting:', error });
            next(error);
        }
    }
});
exports.RemoveParticipantFrommeeting = RemoveParticipantFrommeeting;
const deleteMeeting = (req, res, next) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const meetingId = req.params.id;
        // Check if the event exists
        const meeting = yield meetingModel_1.Meeting.findById(meetingId);
        if (!meeting) {
            return res.status(404).json({ error: 'Meeting not found' });
        }
        // Delete the event
        yield meeting.deleteOne();
        res.status(204).json({ message: "deleted successully" }); // 204 No Content indicates a successful deletion
    }
    catch (error) {
        console.error('Error deleting meeting:', error);
        next(error);
    }
});
exports.deleteMeeting = deleteMeeting;
