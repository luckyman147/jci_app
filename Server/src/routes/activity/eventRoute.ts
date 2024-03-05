import express from "express";
import multer from "multer";
import { AddParticipantToEvent, GetEventsOfMonth, GetEventsOfWeekend, RemoveParticipantFromEvent, addEvent, deleteEvent, getAllEvents, getEventByDate, getEventById, getEventByName, updateEvent, updateImage, uploadImage } from "../../controllers/activities/EventsController";
import { Authenticate } from "../../middleware/CommonAuth";

const router=express.Router()
const storage = multer.memoryStorage()
const upload = multer({ storage: storage })
router.get('/LatestofTheMonth',GetEventsOfMonth)
router.get('/',getAllEvents)
router.get('/LatestOfweekend',GetEventsOfWeekend)
router.get('/:id',getEventById)
router.get('/:name',getEventByName)
router.get('/:date',getEventByDate)

//!require authentication
router.get('/EventParticipants')

//*post
router.post('/add',addEvent)
router.post('/:idEvent/addParticipant',Authenticate ,AddParticipantToEvent)
router.patch('/:id/edit',updateEvent)
router.patch('/:id/UpdateImage',upload.array("CoverImages"),updateImage)
//?should be authenticated
router.post('/:id/uploadImage',upload.array("CoverImages"),uploadImage)
router.delete("/:id",deleteEvent)  //?should be authenticated
router.delete('/Event/:id/deleteParticipant',Authenticate,RemoveParticipantFromEvent  )
export { router as EventRoute };


