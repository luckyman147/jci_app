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
exports.deleteEvent = exports.RemoveParticipantFromEvent = exports.AddParticipantToEvent = exports.updateImage = exports.uploadImage = exports.getEventByDate = exports.getEventByName = exports.getEventById = exports.updateEvent = exports.addEvent = exports.GetEventsOfMonth = exports.GetEventsOfWeekend = exports.getAllEvents = void 0;
const class_transformer_1 = require("class-transformer");
const activity_dto_1 = require("../../dto/activity.dto");
const Member_1 = require("../../models/Member");
const eventModel_1 = require("../../models/activities/eventModel");
const role_1 = require("../../utility/role");
//&Public
const getAllEvents = (req, res, next) => __awaiter(void 0, void 0, void 0, function* () {
    const memberId = req.body;
    try {
        // Fetch all events and sort them by ActivityBeginDate in ascending order
        const events = yield eventModel_1.Event.find().sort({ ActivityBeginDate: -1 }).limit(3);
        if (events.length > 0) {
            const permission = yield (0, role_1.getPermissionIdsByRelated)(["Events"]);
            // Format and send the events in the response
            const formattedEvents = events.map((event) => ({
                _id: event._id,
                name: event.name,
                LeaderName: event.LeaderName,
                IsPart: event.Participants.some((member) => member._id.equals(req.body.id)),
                ActivityPoints: event.ActivityPoints,
                description: event.description,
                categorie: event.categorie,
                IsPaid: event.IsPaid,
                price: event.Price,
                registrationDeadline: event.registrationDeadline,
                ActivityBegindate: event.ActivityBeginDate,
                ActivityEnddate: event.ActivityEndDate,
                ActivityAdress: event.ActivityAdress,
                participants: event.Participants,
                CoverImages: event.CoverImages,
            }));
            res.status(200).json({ Permissions: permission,
                events: formattedEvents });
        }
        else {
            res.status(400).json({ message: "No events found" });
        }
    }
    catch (error) {
        res.status(500).json({ Error: error });
    }
});
exports.getAllEvents = getAllEvents;
const GetEventsOfWeekend = (req, res, next) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const currentDate = new Date();
        const currentDay = currentDate.getDay();
        const firstDayOfWeekend = new Date(currentDate.getFullYear(), currentDate.getMonth(), currentDate.getDate() + (5 - currentDay));
        const lastDayOfWeekend = new Date(currentDate.getFullYear(), currentDate.getMonth(), currentDate.getDate() + (8 - currentDay));
        console.log(firstDayOfWeekend);
        console.log(lastDayOfWeekend);
        console.log(currentDate);
        const eventsOfWeekend = yield eventModel_1.Event.find({
            ActivityBeginDate: { $gte: firstDayOfWeekend, $lte: lastDayOfWeekend },
        }).sort({ ActivityBeginDate: -1 });
        const permission = yield (0, role_1.getPermissionIdsByRelated)(["Events"]);
        if (eventsOfWeekend.length > 0) {
            const formattedEvents = eventsOfWeekend.map((event) => ({
                _id: event._id,
                name: event.name,
                LeaderName: event.LeaderName,
                ActivityPoints: event.ActivityPoints,
                description: event.description,
                categorie: event.categorie,
                IsPaid: event.IsPaid,
                price: event.Price,
                registrationDeadline: event.registrationDeadline,
                ActivityBegindate: event.ActivityBeginDate,
                ActivityEnddate: event.ActivityEndDate,
                ActivityAdress: event.ActivityAdress,
                IsPart: event.Participants.some((member) => member._id.equals(req.body.id)),
                participants: event.Participants,
                CoverImages: event.CoverImages,
            }));
            res.status(200).json({ Permissions: permission, events: formattedEvents,
            });
        }
        else {
            res.status(400).json({ message: "No events found for this weekend" });
        }
    }
    catch (error) {
        console.log('Error retrieving events of the weekend:', error);
        next(error);
    }
});
exports.GetEventsOfWeekend = GetEventsOfWeekend;
const GetEventsOfMonth = (req, res, next) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const currentDate = new Date();
        const eventsOfMonth = yield eventModel_1.Event.find({
            ActivityBeginDate: { $gte: currentDate },
        }).sort({ ActivityBeginDate: 1 }).limit(3);
        if (eventsOfMonth) {
            const formattedEvents = eventsOfMonth.map((event) => ({
                _id: event._id,
                name: event.name,
                LeaderName: event.LeaderName,
                ActivityPoints: event.ActivityPoints,
                description: event.description,
                categorie: event.categorie,
                IsPaid: event.IsPaid,
                price: event.Price,
                registrationDeadline: event.registrationDeadline,
                ActivityBegindate: event.ActivityBeginDate,
                ActivityEnddate: event.ActivityEndDate,
                ActivityAdress: event.ActivityAdress,
                participants: event.Participants,
                CoverImages: event.CoverImages,
                IsPart: event.Participants.some((member) => member._id.equals(req.body.id))
            }));
            console.log(formattedEvents);
            res.status(200).json({ events: formattedEvents });
        }
        else {
            res.status(400).json({ message: "No events found for this month" });
        }
    }
    catch (error) {
        console.error('Error retrieving events of the month:', error);
        next(error);
    }
});
exports.GetEventsOfMonth = GetEventsOfMonth;
//&Private
const addEvent = (req, res, next) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        // Extract data from the request body
        const eventInputs = (0, class_transformer_1.plainToClass)(activity_dto_1.EventInputs, req.body);
        const permission = yield (0, role_1.getPermissionIdsByRelated)(["Events"]);
        // Create an Event document
        const newEvent = new eventModel_1.Event({
            name: eventInputs.name,
            description: eventInputs.description,
            ActivityBeginDate: eventInputs.ActivityBeginDate,
            ActivityEndDate: eventInputs.ActivityEndDate,
            ActivityAdress: eventInputs.ActivityAdress,
            registrationDeadline: eventInputs.registrationDeadline,
            categorie: eventInputs.categorie,
            IsPaid: eventInputs.IsPaid,
            ActivityPoints: eventInputs.ActivityPoints,
            Permissions: permission,
            Price: eventInputs.price,
            Participants: [],
            LeaderName: eventInputs.LeaderName,
            CoverImages: [], // Convert images to base64
        });
        // Add the event to the database
        const savedEvent = yield newEvent.save();
        res.json(savedEvent);
    }
    catch (error) {
        console.log('Error adding event:', error);
        next(error);
    }
});
exports.addEvent = addEvent;
const updateEvent = (req, res, next) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const eventId = req.params.id;
        // Find the existing event by ID
        const existingEvent = yield eventModel_1.Event.findById(eventId);
        if (!existingEvent) {
            return res.status(404).json({ message: 'Event not found' });
        }
        // Extract data from the request body
        const eventInputs = (0, class_transformer_1.plainToClass)(activity_dto_1.EventInputs, req.body);
        // Update the existing event properties
        existingEvent.name = eventInputs.name;
        existingEvent.description = eventInputs.description;
        existingEvent.ActivityBeginDate = eventInputs.ActivityBeginDate;
        existingEvent.ActivityEndDate = eventInputs.ActivityEndDate;
        existingEvent.ActivityAdress = eventInputs.ActivityAdress;
        existingEvent.registrationDeadline = eventInputs.registrationDeadline;
        existingEvent.categorie = eventInputs.categorie;
        existingEvent.IsPaid = eventInputs.IsPaid;
        existingEvent.LeaderName = eventInputs.LeaderName;
        existingEvent.Price = eventInputs.price;
        existingEvent.ActivityPoints = eventInputs.ActivityPoints;
        // Save the updated event
        const updatedEvent = yield existingEvent.save();
        res.json(updatedEvent);
    }
    catch (error) {
        console.error('Error updating event:', error);
        next(error);
    }
});
exports.updateEvent = updateEvent;
const getEventById = (req, res, next) => __awaiter(void 0, void 0, void 0, function* () {
    const Permissions = yield (0, role_1.getPermissionIdsByRelated)(["Events"]);
    try {
        const id = req.params.id;
        const event = yield eventModel_1.Event.findById(id);
        if (event) {
            res.json({
                _id: event._id,
                name: event.name,
                LeaderName: event.LeaderName,
                ActivityPoints: event.ActivityPoints,
                description: event.description,
                categorie: event.categorie,
                IsPaid: event.IsPaid,
                price: event.Price,
                registrationDeadline: event.registrationDeadline,
                IsPart: event.Participants.some((member) => member._id.equals(req.body.id)),
                ActivityBegindate: event.ActivityBeginDate,
                ActivityEnddate: event.ActivityEndDate,
                ActivityAdress: event.ActivityAdress,
                participants: yield (0, role_1.getMembersInfo)(event.Participants),
                CoverImages: event.CoverImages,
                Permissions: Permissions
            });
            console.log(event);
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
exports.getEventById = getEventById;
const getEventByName = (req, res, next) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const name = req.params.name;
        const event = yield eventModel_1.Event.findOne({ name: name });
        if (event) {
            res.json(event);
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
exports.getEventByName = getEventByName;
const getEventByDate = (req, res, next) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const date = req.params.date;
        const event = yield eventModel_1.Event.findOne({ ActivityBeginDate: date });
        if (event) {
            res.json(event);
        }
        else {
            res.status(404).json({ message: "No event found with this date" });
        }
    }
    catch (error) {
        console.error('Error retrieving event by date:', error);
        next(error);
    }
});
exports.getEventByDate = getEventByDate;
const uploadImage = (req, res, next) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const file = req.files;
        console.log("file", file);
        const id = req.params.id;
        // Find the event
        const event = yield eventModel_1.Event.findById(id);
        if (!event)
            return res.status(401).send("No such event");
        const images = req.files || [];
        if (!images || images.length === 0) {
            console.log(images);
            return res.status(400).send("Invalid or missing image files");
        }
        console.log(images);
        // Convert images to base64
        const base64Images = images.map((image) => image.buffer.toString('base64'));
        // Add the images to the event
        event.CoverImages.push(...base64Images);
        // Save the event
        const savedEvent = yield event.save();
        res.json(savedEvent);
    }
    catch (error) {
        console.log('Error uploading image:', error);
        next(error);
    }
});
exports.uploadImage = uploadImage;
const updateImage = (req, res, next) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const eventId = req.params.id;
        const event = yield eventModel_1.Event.findById(eventId);
        if (!event) {
            return res.status(404).send("No such event");
        }
        const images = req.files || [];
        if (!images || images.length === 0) {
            return res.status(400).send("Invalid or missing image files");
        }
        // Convert images to base64
        const base64Images = images.map((image) => image.buffer.toString('base64'));
        // Update the existing images in the event
        event.CoverImages = base64Images;
        // Save the event
        const updatedEvent = yield event.save();
        res.json(updatedEvent);
    }
    catch (error) {
        console.log('Error updating image:', error);
        next(error);
    }
});
exports.updateImage = updateImage;
const AddParticipantToEvent = (req, res, next) => __awaiter(void 0, void 0, void 0, function* () {
    const member = req.member;
    if (member) {
        try {
            const eventId = req.params.idEvent;
            console.log(eventId);
            // Find the event by ID
            const event = yield eventModel_1.Event.findById(eventId);
            console.log(event);
            if (!event) {
                return res.status(404).json({ message: 'Event not found' });
            }
            const FoundedMember = yield Member_1.Member.findById(member._id);
            // Check if the participant is already added
            if (event.Participants.includes(member._id)) {
                return res.status(400).json({ message: 'Participant is already added to the event' });
            }
            yield (FoundedMember === null || FoundedMember === void 0 ? void 0 : FoundedMember.Activities.push(event));
            // Add the participant to the Participants array
            yield event.Participants.push(member);
            // Save the updated event
            const updatedEvent = yield event.save();
            const updatedMember = yield FoundedMember.save();
            // Respond with the updated event
            res.status(200).json({ message: 'Participant added to the event', event: updatedEvent, FoundedMember: updatedMember === null || updatedMember === void 0 ? void 0 : updatedMember.Activities });
        }
        catch (error) {
            res.status(500).json({ message: 'Error adding participant to the event' });
        }
    }
});
exports.AddParticipantToEvent = AddParticipantToEvent;
// Import your Member model
const RemoveParticipantFromEvent = (req, res, next) => __awaiter(void 0, void 0, void 0, function* () {
    const member = req.member;
    if (member) {
        try {
            const eventId = req.params.id;
            const participantId = member._id;
            // Find the event by ID
            const event = yield eventModel_1.Event.findById(eventId);
            if (!event) {
                return res.status(404).json({ message: 'Event not found' });
            }
            // Find the participant by ID
            const participant = yield Member_1.Member.findById(participantId);
            if (!participant) {
                return res.status(404).json({ message: 'Participant not found' });
            }
            // Check if the participant is added to the event
            const isParticipantAdded = event.Participants.some((member) => member._id.equals(participantId));
            if (!isParticipantAdded) {
                return res.status(400).json({ message: 'Participant is not added to the event' });
            }
            participant.Activities = participant.Activities.filter((activity) => activity._id.equals(eventId));
            // Remove the participant from the Participants array
            event.Participants = event.Participants.filter((member) => !member._id.equals(participantId));
            // Save the updated event
            const updatedEvent = yield event.save();
            yield participant.save();
            // Respond with the updated event
            res.json({ message: 'Participant removed from the event', event: updatedEvent });
        }
        catch (error) {
            res.status(500).json({ message: 'Error removing participant from event:', error });
            next(error);
        }
    }
});
exports.RemoveParticipantFromEvent = RemoveParticipantFromEvent;
const deleteEvent = (req, res, next) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const eventId = req.params.id;
        // Check if the event exists
        const event = yield eventModel_1.Event.findById(eventId);
        if (!event) {
            return res.status(404).json({ error: 'Event not found' });
        }
        // Delete the event
        yield event.deleteOne();
        res.status(204).json({ message: "deleted successully" }); // 204 No Content indicates a successful deletion
    }
    catch (error) {
        console.error('Error deleting event:', error);
        next(error);
    }
});
exports.deleteEvent = deleteEvent;
