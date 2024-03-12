import express from "express";
import multer from "multer";
import { AddParticipantToTraining, GetTrainingsOfMonth, GetTrainingsOfWeekend, RemoveParticipantFromTraining,deleteTrain,

 addTraining, getAllTrainings, getTrainingByDate, getTrainingById, getTrainingByName, uploadImage, 
 updateTraining,
 updateImage} from "../../controllers/activities/TrainingController";
import { Authenticate } from "../../middleware/CommonAuth";

const router=express.Router()
const storage = multer.memoryStorage()
const upload = multer({ storage: storage })
router.post('/LatestofTheMonth',GetTrainingsOfMonth)
router.post('/',getAllTrainings)
router.post('/LatestOfweekend',GetTrainingsOfWeekend)
router.post('/get/:id',getTrainingById)
router.post('/get/:name',getTrainingByName)
router.post('/get/:date',getTrainingByDate)

//!require authentication
router.get('/TrainingParticipants')

//*post
router.post('/add',addTraining)
router.post('/:idTraining/addParticipant',Authenticate ,AddParticipantToTraining)
router.patch('/:id/edit',updateTraining)
router.patch('/:id/UpdateImage',upload.array("CoverImages"),updateImage)

//?should be authenticated
router.post('/:id/uploadImage',upload.array("CoverImages"),uploadImage)
router.delete("/:id",deleteTrain)  //?should be authenticated
router.delete('/:id/deleteParticipant',Authenticate,RemoveParticipantFromTraining  )
export { router as trainingRoute };


