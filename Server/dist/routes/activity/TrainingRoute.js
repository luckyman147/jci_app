"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.trainingRoute = void 0;
const express_1 = __importDefault(require("express"));
const multer_1 = __importDefault(require("multer"));
const TrainingController_1 = require("../../controllers/activities/TrainingController");
const CommonAuth_1 = require("../../middleware/CommonAuth");
const router = express_1.default.Router();
exports.trainingRoute = router;
const storage = multer_1.default.memoryStorage();
const upload = (0, multer_1.default)({ storage: storage });
router.post('/LatestofTheMonth', TrainingController_1.GetTrainingsOfMonth);
router.post('/', TrainingController_1.getAllTrainings);
router.post('/LatestOfweekend', TrainingController_1.GetTrainingsOfWeekend);
router.post('/get/:id', TrainingController_1.getTrainingById);
router.post('/get/:name', TrainingController_1.getTrainingByName);
router.post('/get/:date', TrainingController_1.getTrainingByDate);
//!require authentication
router.get('/TrainingParticipants');
/**
 * @swagger
 * /hello:
 *   get:
 *     summary: Returns a hello message
 *     responses:
 *       200:
 *         description: A hello message
 */
router.get('/hello', (req, res) => {
    res.json({ message: 'Hello, World!' });
});
//*post
/**
 * @swagger
 * /add/:
 *   post:
 *     summary: Returns a personalized hello message
 
 */
router.post('/add', TrainingController_1.addTraining);
router.post('/:idTraining/addParticipant', CommonAuth_1.Authenticate, TrainingController_1.AddParticipantToTraining);
router.patch('/:id/edit', CommonAuth_1.AuthenticateAdmin, TrainingController_1.updateTraining);
router.patch('/:id/UpdateImage', upload.array("CoverImages"), TrainingController_1.updateImage);
//?should be authenticated
router.post('/:id/uploadImage', upload.array("CoverImages"), TrainingController_1.uploadImage);
router.delete("/:id", TrainingController_1.deleteTrain); //?should be authenticated
router.delete('/:id/deleteParticipant', CommonAuth_1.Authenticate, TrainingController_1.RemoveParticipantFromTraining);
