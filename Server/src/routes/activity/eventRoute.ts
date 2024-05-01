import express from "express";
import multer from "multer";
import {  GetEventsOfMonth, GetEventsOfWeekend,  addEvent, getAllEvents, getEventByDate, getEventById, getEventByName, updateEvent, updateImage, uploadImage } from "../../controllers/activities/EventsController";
import { Authenticate,AuthenticateAdmin } from "../../middleware/CommonAuth";
import { AddParticipantToActivity, deleteActivity, RemoveParticipant } from "../../controllers/activities/activityController";

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
router.post('/add/',AuthenticateAdmin,addEvent)

router.patch('/:id/edit',AuthenticateAdmin,updateEvent)
router.patch('/:id/UpdateImage',upload.array("CoverImages"),updateImage)
router.post('/:id/uploadImage',upload.array("CoverImages"),uploadImage)
router.post('/:id/addParticipant',Authenticate ,AddParticipantToActivity)
//?should be authenticated

router.delete("/:id",AuthenticateAdmin,deleteActivity)  //?should be authenticated
router.delete('/:id/deleteParticipant',Authenticate,RemoveParticipant  )
export { router as EventRoute };


