import express from "express";
import multer from "multer";
import { AddParticipantToEvent, GetEventsOfMonth, GetEventsOfWeekend, RemoveParticipantFromEvent, addEvent, deleteEvent, getAllEvents, getEventByDate, getEventById, getEventByName, updateEvent, updateImage, uploadImage } from "../../controllers/activities/EventsController";
import { Authenticate } from "../../middleware/CommonAuth";

const router=express.Router()
const storage = multer.memoryStorage()
const upload = multer({ storage: storage })
router.post('/LatestofTheMonth',GetEventsOfMonth)
router.post('/',getAllEvents)
router.post('/LatestOfweekend',GetEventsOfWeekend)
router.post('/get/:id',getEventById)
router.post('/get/:name',getEventByName)
router.post('/get/:date',getEventByDate)

//!require authentication
router.get('/EventParticipants')

//*post
router.post('/add/',addEvent)

router.patch('/:id/edit',updateEvent)
router.patch('/:id/UpdateImage',upload.array("CoverImages"),updateImage)
router.post('/:id/uploadImage',upload.array("CoverImages"),uploadImage)
router.post('/:idEvent/addParticipant',Authenticate ,AddParticipantToEvent)
//?should be authenticated

router.delete("/:id",deleteEvent)  //?should be authenticated
router.delete('/:id/deleteParticipant',Authenticate,RemoveParticipantFromEvent  )
export { router as EventRoute };


