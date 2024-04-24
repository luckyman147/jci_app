"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.EventRoute = void 0;
const express_1 = __importDefault(require("express"));
const multer_1 = __importDefault(require("multer"));
const EventsController_1 = require("../../controllers/activities/EventsController");
const CommonAuth_1 = require("../../middleware/CommonAuth");
const router = express_1.default.Router();
exports.EventRoute = router;
const storage = multer_1.default.memoryStorage();
const upload = (0, multer_1.default)({ storage: storage });
router.post('/LatestofTheMonth', EventsController_1.GetEventsOfMonth);
router.post('/', EventsController_1.getAllEvents);
router.post('/LatestOfweekend', EventsController_1.GetEventsOfWeekend);
router.post('/get/:id', EventsController_1.getEventById);
router.post('/get/:name', EventsController_1.getEventByName);
router.post('/get/:date', EventsController_1.getEventByDate);
//!require authentication
router.get('/EventParticipants');
//*post
router.post('/add/', CommonAuth_1.Authenticate, EventsController_1.addEvent);
router.patch('/:id/edit', CommonAuth_1.AuthenticateAdmin, EventsController_1.updateEvent);
router.patch('/:id/UpdateImage', upload.array("CoverImages"), EventsController_1.updateImage);
router.post('/:id/uploadImage', upload.array("CoverImages"), EventsController_1.uploadImage);
router.post('/:idEvent/addParticipant', CommonAuth_1.Authenticate, EventsController_1.AddParticipantToEvent);
//?should be authenticated
router.delete("/:id", EventsController_1.deleteEvent); //?should be authenticated
router.delete('/:id/deleteParticipant', CommonAuth_1.Authenticate, EventsController_1.RemoveParticipantFromEvent);
