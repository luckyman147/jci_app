"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.meetingRoute = void 0;
const express_1 = __importDefault(require("express"));
const multer_1 = __importDefault(require("multer"));
const meetingsController_1 = require("../../controllers/activities/meetingsController");
const CommonAuth_1 = require("../../middleware/CommonAuth");
const router = express_1.default.Router();
exports.meetingRoute = router;
const storage = multer_1.default.memoryStorage();
const upload = (0, multer_1.default)({ storage: storage });
router.post('/', meetingsController_1.getAllmeetings);
router.post('/LatestOfweek', meetingsController_1.GetmeetingsOfWeekend);
router.post('/get/:id', meetingsController_1.getmeetingById);
router.get('/get/:name', meetingsController_1.getmeetingByName);
router.get('/get/:date', meetingsController_1.getmeetingByDate);
//!require authentication
router.get('/meetingParticipants');
//*post
router.post('/add', meetingsController_1.addmeeting);
router.post('/:idmeeting/addParticipant', CommonAuth_1.Authenticate, meetingsController_1.AddParticipantTomeeting);
router.patch('/:id/edit', CommonAuth_1.AuthenticateAdmin, meetingsController_1.updateMeeting); //?should be authenticated
router.patch('/:id/uploadImage', upload.array("CoverImages", 2), meetingsController_1.uploadImage);
router.delete("/:id", meetingsController_1.deleteMeeting); //?should be authenticated
router.delete('/:id/deleteParticipant', CommonAuth_1.Authenticate, meetingsController_1.RemoveParticipantFrommeeting);
