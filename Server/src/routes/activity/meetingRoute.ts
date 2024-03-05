import express from "express";
import multer from "multer";
import { AddParticipantTomeeting, GetmeetingsOfWeekend,
 RemoveParticipantFrommeeting, addmeeting, getAllmeetings, getmeetingByDate,
  getmeetingById, getmeetingByName, uploadImage,deleteMeeting, 
  updateMeeting} from "../../controllers/activities/meetingsController";
import { Authenticate } from "../../middleware/CommonAuth";

const router=express.Router()
const storage = multer.memoryStorage()
const upload = multer({ storage: storage })

router.get('/',getAllmeetings)
router.get('/LatestOfweek',GetmeetingsOfWeekend)
router.get('/:id',getmeetingById)
router.get('/:name',getmeetingByName)
router.get('/:date',getmeetingByDate)

//!require authentication
router.get('/meetingParticipants')

//*post
router.post('/add',addmeeting)
router.post('/:idmeeting/addParticipant',Authenticate ,AddParticipantTomeeting)
router.patch('/:id/edit',updateMeeting)//?should be authenticated
router.patch('/:id/uploadImage',upload.array("CoverImages",2),uploadImage)
router.delete("/:id",deleteMeeting)  //?should be authenticated
router.delete('/:id/deleteParticipant',Authenticate,RemoveParticipantFrommeeting  )
export { router as meetingRoute };


