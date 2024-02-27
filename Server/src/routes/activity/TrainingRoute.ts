import express from "express";
import multer from "multer";
import { AddParticipantToTraining, GetTrainingsOfMonth, GetTrainingsOfWeekend, RemoveParticipantFromTraining, addTraining, getAllTrainings, getTrainingByDate, getTrainingById, getTrainingByName, uploadImage } from "../../controllers/activities/TrainingController";
import { Authenticate } from "../../middleware/CommonAuth";

const router=express.Router()
const storage = multer.memoryStorage()
const upload = multer({ storage: storage })
router.get('/LatestofTheMonth',GetTrainingsOfMonth)
router.get('/',getAllTrainings)
router.get('/LatestOfweekend',GetTrainingsOfWeekend)
router.get('/:id',getTrainingById)
router.get('/:name',getTrainingByName)
router.get('/:date',getTrainingByDate)

//!require authentication
router.get('/TrainingParticipants')

//*post
router.post('/add',addTraining)
router.post('/:idTraining/addParticipant',Authenticate ,AddParticipantToTraining)
router.patch('/:id/edit',)//?should be authenticated
router.patch('/:id/uploadImage',upload.array("CoverImages",2),uploadImage)
router.delete("/Training/:id")  //?should be authenticated
router.delete('/Training/:id/deleteParticipant',Authenticate,RemoveParticipantFromTraining  )
export { router as trainingRoute };


