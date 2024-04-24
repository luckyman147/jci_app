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
exports.deleteTrain = exports.RemoveParticipantFromTraining = exports.AddParticipantToTraining = exports.updateImage = exports.uploadImage = exports.getTrainingByDate = exports.getTrainingByName = exports.getTrainingById = exports.updateTraining = exports.addTraining = exports.GetTrainingsOfMonth = exports.GetTrainingsOfWeekend = exports.getAllTrainings = void 0;
const class_transformer_1 = require("class-transformer");
const class_validator_1 = require("class-validator");
const activity_dto_1 = require("../../dto/activity.dto");
const Member_1 = require("../../models/Member");
const TrainingModel_1 = require("../../models/activities/TrainingModel");
const role_1 = require("../../utility/role");
//&Public
const getAllTrainings = (req, res, next) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        // Fetch all Trainings and sort them by ActivityBeginDate in ascending order
        const Trainings = yield TrainingModel_1.Training.find().sort({ ActivityBeginDate: -1 });
        if (Trainings.length > 0) {
            const permission = yield (0, role_1.getPermissionIdsByRelated)(["Trainings"]);
            // Format and send the Trainings in the response
            const formattedTrainings = Trainings.map((Training) => ({
                _id: Training._id,
                name: Training.name,
                ProfesseurName: Training.ProfesseurName,
                Duration: Training.Duration,
                ActivityPoints: Training.ActivityPoints,
                description: Training.description,
                categorie: Training.categorie,
                IsPaid: Training.IsPaid,
                price: Training.Price,
                IsPart: Training.Participants.some((member) => member._id.equals(req.body.id)),
                ActivityBegindate: Training.ActivityBeginDate,
                ActivityEnddate: Training.ActivityEndDate,
                ActivityAdress: Training.ActivityAdress,
                participants: Training.Participants,
                CoverImages: Training.CoverImages,
            }));
            res.status(200).json({ Permissions: permission,
                Trainings: formattedTrainings });
        }
        else {
            res.status(400).json({ message: "No Trainings found" });
        }
    }
    catch (error) {
        res.status(500).json({ Error: error });
    }
});
exports.getAllTrainings = getAllTrainings;
const GetTrainingsOfWeekend = (req, res, next) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const currentDate = new Date();
        const currentDay = currentDate.getDay();
        const firstDayOfWeekend = new Date(currentDate.getFullYear(), currentDate.getMonth(), currentDate.getDate() + (5 - currentDay));
        const lastDayOfWeekend = new Date(currentDate.getFullYear(), currentDate.getMonth(), currentDate.getDate() + (7 - currentDay));
        console.log(firstDayOfWeekend);
        console.log(lastDayOfWeekend);
        console.log(currentDate);
        const TrainingsOfWeekend = yield TrainingModel_1.Training.find({
            ActivityBeginDate: { $gte: firstDayOfWeekend, $lte: lastDayOfWeekend },
        }).sort({ ActivityBeginDate: -1 });
        if (TrainingsOfWeekend.length > 0) {
            const formattedTrainings = TrainingsOfWeekend.map((Training) => ({
                _id: Training._id,
                name: Training.name,
                ProfesseurName: Training.ProfesseurName,
                Duration: Training.Duration,
                ActivityPoints: Training.ActivityPoints,
                description: Training.description,
                categorie: Training.categorie,
                IsPaid: Training.IsPaid,
                price: Training.Price,
                IsPart: Training.Participants.some((member) => member._id.equals(req.body.id)),
                ActivityBegindate: Training.ActivityBeginDate,
                ActivityEnddate: Training.ActivityEndDate,
                ActivityAdress: Training.ActivityAdress,
                participants: Training.Participants,
                CoverImages: Training.CoverImages,
            }));
            res.status(200).json({ Trainings: formattedTrainings });
        }
        else {
            res.status(400).json({ message: "No Trainings found for this weekend" });
        }
    }
    catch (error) {
        console.log('Error retrieving Trainings of the weekend:', error);
        next(error);
    }
});
exports.GetTrainingsOfWeekend = GetTrainingsOfWeekend;
const GetTrainingsOfMonth = (req, res, next) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const currentDate = new Date();
        const lastDayOfMonth = new Date(currentDate.getFullYear(), currentDate.getMonth() + 1, 0);
        const TrainingsOfMonth = yield TrainingModel_1.Training.find({
            ActivityBeginDate: { $gte: currentDate },
        }).sort({ ActivityBeginDate: 1 }).limit(3);
        if (TrainingsOfMonth.length > 0) {
            const formattedTrainings = TrainingsOfMonth.map((Training) => ({
                _id: Training._id,
                name: Training.name,
                ProfesseurName: Training.ProfesseurName,
                Duration: Training.Duration,
                ActivityPoints: Training.ActivityPoints,
                description: Training.description,
                categorie: Training.categorie,
                IsPaid: Training.IsPaid,
                price: Training.Price,
                IsPart: Training.Participants.some((member) => member._id.equals(req.body.id)),
                ActivityBegindate: Training.ActivityBeginDate,
                ActivityEnddate: Training.ActivityEndDate,
                ActivityAdress: Training.ActivityAdress,
                participants: Training.Participants,
                CoverImages: Training.CoverImages,
            }));
            console.log(formattedTrainings);
            res.status(200).json({ Trainings: formattedTrainings });
        }
        else {
            res.status(400).json({ message: "No Trainings found for this month" });
        }
    }
    catch (error) {
        console.error('Error retrieving Trainings of the month:', error);
        next(error);
    }
});
exports.GetTrainingsOfMonth = GetTrainingsOfMonth;
//&Private
const addTraining = (req, res, next) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        // Extract data from the request body
        const trainingInputs = (0, class_transformer_1.plainToClass)(activity_dto_1.TrainingInputs, req.body);
        const errors = yield (0, class_validator_1.validate)(trainingInputs, { validationError: { target: true } });
        if (errors.length > 0) {
            return res.status(400).json({ message: 'validation error', errors: errors[0].constraints });
            console.log(errors);
        }
        const beginDate = new Date(trainingInputs.ActivityBeginDate);
        const endDate = new Date(trainingInputs.ActivityEndDate);
        console.log(beginDate, endDate);
        const durationInMillis = endDate.getTime() - beginDate.getTime();
        // Check if ActivityEndDate is greater than ActivityBeginDate
        if (endDate.getTime() <= beginDate.getTime()) {
            return res.status(400).json({ message: 'ActivityEndDate must be greater than ActivityBeginDate' });
        }
        // Create an Training document
        const newTraining = new TrainingModel_1.Training({
            name: trainingInputs.name,
            description: trainingInputs.description,
            ActivityBeginDate: trainingInputs.ActivityBeginDate,
            ActivityEndDate: trainingInputs.ActivityEndDate,
            ActivityAdress: trainingInputs.ActivityAdress,
            categorie: trainingInputs.categorie,
            IsPaid: trainingInputs.IsPaid,
            ActivityPoints: trainingInputs.ActivityPoints,
            Price: trainingInputs.price,
            Participants: [],
            ProfesseurName: trainingInputs.ProfesseurName,
            Duration: durationInMillis,
            CoverImages: [], // Convert images to base64
        });
        // Add the Training to the database
        const savedTraining = yield newTraining.save();
        res.json(savedTraining);
    }
    catch (error) {
        console.error('Error adding Training:', error);
        next(error);
    }
});
exports.addTraining = addTraining;
const updateTraining = (req, res, next) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const trainingId = req.params.id;
        // Find the existing training by ID
        const existingTraining = yield TrainingModel_1.Training.findById(trainingId);
        if (!existingTraining) {
            return res.status(404).json({ message: 'Training not found' });
        }
        // Extract data from the request body
        const trainingInputs = (0, class_transformer_1.plainToClass)(activity_dto_1.TrainingInputs, req.body);
        const errors = yield (0, class_validator_1.validate)(trainingInputs, { validationError: { target: true } });
        if (errors.length > 0) {
            return res.status(400).json({ message: 'Validation error', errors: errors[0].constraints });
        }
        const beginDate = new Date(trainingInputs.ActivityBeginDate);
        const endDate = new Date(trainingInputs.ActivityEndDate);
        // Check if ActivityEndDate is greater than ActivityBeginDate
        if (endDate.getTime() <= beginDate.getTime()) {
            return res.status(400).json({ message: 'ActivityEndDate must be greater than ActivityBeginDate' });
        }
        // Update the existing training properties
        existingTraining.name = trainingInputs.name;
        existingTraining.description = trainingInputs.description;
        existingTraining.ActivityBeginDate = trainingInputs.ActivityBeginDate;
        existingTraining.ActivityEndDate = trainingInputs.ActivityEndDate;
        existingTraining.ActivityAdress = trainingInputs.ActivityAdress;
        existingTraining.categorie = trainingInputs.categorie;
        existingTraining.IsPaid = trainingInputs.IsPaid;
        existingTraining.Price = trainingInputs.price;
        existingTraining.ActivityPoints = trainingInputs.ActivityPoints;
        existingTraining.ProfesseurName = trainingInputs.ProfesseurName;
        // Calculate and update the Duration
        const durationInMillis = endDate.getTime() - beginDate.getTime();
        existingTraining.Duration = durationInMillis;
        // Save the updated training
        const updatedTraining = yield existingTraining.save();
        res.json(updatedTraining);
    }
    catch (error) {
        console.error('Error updating Training:', error);
        next(error);
    }
});
exports.updateTraining = updateTraining;
const getTrainingById = (req, res, next) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const Permissions = yield (0, role_1.getPermissionIdsByRelated)(["Trainings"]);
        const id = req.params.id;
        const training = yield TrainingModel_1.Training.findById(id);
        if (training) {
            res.status(200).json({
                _id: training._id,
                name: training.name,
                ProfesseurName: training.ProfesseurName,
                Duration: training.Duration,
                IsPart: training.Participants.some((member) => member._id.equals(req.body.id)),
                ActivityPoints: training.ActivityPoints,
                description: training.description,
                categorie: training.categorie,
                IsPaid: training.IsPaid,
                price: training.Price,
                ActivityBegindate: training.ActivityBeginDate,
                ActivityEnddate: training.ActivityEndDate,
                ActivityAdress: training.ActivityAdress,
                participants: yield (0, role_1.getMembersInfo)(training.Participants),
                CoverImages: training.CoverImages,
                Permissions: Permissions
            });
        }
        else {
            res.status(404).json({ message: "No Training found with this id" });
        }
    }
    catch (error) {
        console.error('Error retrieving Training by id:', error);
        next(error);
    }
});
exports.getTrainingById = getTrainingById;
const getTrainingByName = (req, res, next) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const name = req.params.name;
        const training = yield TrainingModel_1.Training.findOne({ name: name });
        if (training) {
            res.json(training);
        }
        else {
            res.status(404).json({ message: "No Training found with this name" });
        }
    }
    catch (error) {
        console.error('Error retrieving Training by name:', error);
        next(error);
    }
});
exports.getTrainingByName = getTrainingByName;
const getTrainingByDate = (req, res, next) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const date = req.params.date;
        const training = yield TrainingModel_1.Training.findOne({ ActivityBeginDate: date });
        if (training) {
            res.json(training);
        }
        else {
            res.status(404).json({ message: "No Training found with this date" });
        }
    }
    catch (error) {
        console.error('Error retrieving Training by date:', error);
        next(error);
    }
});
exports.getTrainingByDate = getTrainingByDate;
const uploadImage = (req, res, next) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const id = req.params.id;
        // Find the Training
        const training = yield TrainingModel_1.Training.findById(id);
        if (!training)
            return res.status(401).send("No such Training");
        const images = req.files;
        if (!images || images.length === 0) {
            console.log(images);
            return res.status(400).send("Invalid or missing image files");
        }
        // Convert images to base64
        const base64Images = images.map((image) => image.buffer.toString('base64'));
        // Add the images to the Training
        training.CoverImages.push(...base64Images);
        // Save the Training
        const savedTraining = yield training.save();
        res.json(savedTraining);
    }
    catch (error) {
        console.error('Error uploading image:', error);
        next(error);
    }
});
exports.uploadImage = uploadImage;
const updateImage = (req, res, next) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const trainingId = req.params.id;
        const training = yield TrainingModel_1.Training.findById(trainingId);
        if (!training) {
            return res.status(404).send("No such training");
        }
        const images = req.files || [];
        if (!images || images.length === 0) {
            return res.status(400).send("Invalid or missing image files");
        }
        // Convert images to base64
        const base64Images = images.map((image) => image.buffer.toString('base64'));
        // Update the existing images in the training
        training.CoverImages = base64Images;
        // Save the training
        const updatedTraining = yield training.save();
        res.json(updatedTraining);
    }
    catch (error) {
        console.error('Error updating image:', error);
        next(error);
    }
});
exports.updateImage = updateImage;
const AddParticipantToTraining = (req, res, next) => __awaiter(void 0, void 0, void 0, function* () {
    const member = req.member;
    if (member) {
        try {
            const TrainingId = req.params.idTraining;
            console.log(TrainingId);
            // Find the Training by ID
            const training = yield TrainingModel_1.Training.findById(TrainingId);
            console.log(training);
            if (!training) {
                return res.status(404).json({ message: 'Training not found' });
            }
            // Check if the participant is already added
            if (training.Participants.includes(member._id)) {
                return res.status(400).json({ message: 'Participant is already added to the Training' });
            }
            // Add the participant to the Participants array
            yield training.Participants.push(member);
            // Save the updated Training
            const updatedTraining = yield training.save();
            // Respond with the updated Training
            res.status(200).json({ message: 'Participant added to the Training', Training: updatedTraining });
        }
        catch (error) {
            res.status(500).json({ message: 'Error adding participant to the Training' });
        }
    }
});
exports.AddParticipantToTraining = AddParticipantToTraining;
// Import your Member model
const RemoveParticipantFromTraining = (req, res, next) => __awaiter(void 0, void 0, void 0, function* () {
    const member = req.member;
    if (member) {
        try {
            const TrainingId = req.params.id;
            const participantId = member._id;
            // Find the Training by ID
            const training = yield TrainingModel_1.Training.findById(TrainingId);
            if (!training) {
                return res.status(404).json({ message: 'Training not found' });
            }
            // Find the participant by ID
            const participant = yield Member_1.Member.findById(participantId);
            if (!participant) {
                return res.status(404).json({ message: 'Participant not found' });
            }
            // Check if the participant is added to the Training
            const isParticipantAdded = training.Participants.some((member) => member._id.equals(participantId));
            if (!isParticipantAdded) {
                return res.status(400).json({ message: 'Participant is not added to the Training' });
            }
            // Remove the participant from the Participants array
            training.Participants = training.Participants.filter((member) => !member._id.equals(participantId));
            // Save the updated Training
            const updatedTraining = yield training.save();
            // Respond with the updated Training
            res.json({ message: 'Participant removed from the Training', Training: updatedTraining });
        }
        catch (error) {
            res.status(500).json({ message: 'Error removing participant from Training:', error });
            next(error);
        }
    }
});
exports.RemoveParticipantFromTraining = RemoveParticipantFromTraining;
const deleteTrain = (req, res, next) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const TrainingId = req.params.id;
        // Check if the event exists
        const train = yield TrainingModel_1.Training.findById(TrainingId);
        if (!train) {
            return res.status(404).json({ error: 'Training not found' });
        }
        // Delete the event
        yield train.deleteOne();
        res.status(204).json({ message: "deleted successully" }); // 204 No Content indicates a successful deletion
    }
    catch (error) {
        console.error('Error deleting event:', error);
        next(error);
    }
});
exports.deleteTrain = deleteTrain;
