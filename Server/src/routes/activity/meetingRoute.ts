import express from "express";
import multer from "multer";
import {  GetmeetingsOfWeekend,
  addmeeting, getAllmeetings, getmeetingByDate,
  getmeetingById, getmeetingByName, uploadImage, 
  updateMeeting} from "../../controllers/activities/meetingsController";
import { Authenticate,AuthenticateAdmin } from "../../middleware/CommonAuth";
import { AddParticipantToActivity, deleteActivity, RemoveParticipant } from "../../controllers/activities/activityController";

const router=express.Router()
const storage = multer.memoryStorage()
const upload = multer({ storage: storage })

router.post('/',getAllmeetings)
router.post('/LatestOfweek',GetmeetingsOfWeekend)
router.post('/get/:id',getmeetingById)
router.get('/get/:name',getmeetingByName)
router.get('/get/:date',getmeetingByDate)

//!require authentication
router.get('/meetingParticipants')

//*post
router.post('/add',addmeeting)
router.post('/:id/addParticipant',Authenticate ,AddParticipantToActivity)
router.patch('/:id/edit',AuthenticateAdmin,updateMeeting)//?should be authenticated
router.patch('/:id/uploadImage',upload.array("CoverImages",2),uploadImage)
router.delete("/:id",AuthenticateAdmin,deleteActivity)  //?should be authenticated
router.delete('/:id/deleteParticipant',Authenticate,RemoveParticipant  )
export { router as meetingRoute };


