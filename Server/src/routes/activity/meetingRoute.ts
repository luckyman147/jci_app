import express from "express";
import multer from "multer";
import { AddParticipantTomeeting, GetmeetingsOfWeekend,
 RemoveParticipantFrommeeting, addmeeting, getAllmeetings, getmeetingByDate,
  getmeetingById, getmeetingByName, uploadImage,deleteMeeting, 
  updateMeeting} from "../../controllers/activities/meetingsController";
import { Authenticate,AuthenticateAdmin } from "../../middleware/CommonAuth";

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
router.post('/:idmeeting/addParticipant',Authenticate ,AddParticipantTomeeting)
router.patch('/:id/edit',AuthenticateAdmin,updateMeeting)//?should be authenticated
router.patch('/:id/uploadImage',upload.array("CoverImages",2),uploadImage)
router.delete("/:id",deleteMeeting)  //?should be authenticated
router.delete('/:id/deleteParticipant',Authenticate,RemoveParticipantFrommeeting  )
export { router as meetingRoute };


