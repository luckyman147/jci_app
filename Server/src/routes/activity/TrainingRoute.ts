import express, { Request, Response } from "express";
import multer from "multer";
import {
    GetTrainingsOfMonth, GetTrainingsOfWeekend, 
    addTraining,
  
    getAllTrainings, getTrainingByDate, getTrainingById, getTrainingByName,
    updateImage,
    updateTraining,
    uploadImage
} from "../../controllers/activities/TrainingController";
import { Authenticate, AuthenticateAdmin } from "../../middleware/CommonAuth";
import { AddParticipantToActivity, deleteActivity, RemoveParticipant } from "../../controllers/activities/activityController";
import { authenticate } from "passport";
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
/**
 * @swagger
 * /hello:
 *   get:
 *     summary: Returns a hello message
 *     responses:
 *       200:
 *         description: A hello message
 */
router.get('/hello', (req:Request, res:Response) => {
    res.json({ message: 'Hello, World!' });
  });
//*post

/**
 * @swagger
 * /add/:
 *   post:
 *     summary: Returns a personalized hello message
 
 */


router.post('/add',AuthenticateAdmin,addTraining)
router.post('/:id/addParticipant',Authenticate ,AddParticipantToActivity)
router.patch('/:id/edit',AuthenticateAdmin,updateTraining)
router.patch('/:id/UpdateImage',upload.array("CoverImages"),updateImage)

//?should be authenticated
router.post('/:id/uploadImage',upload.array("CoverImages"),uploadImage)
router.delete("/:id",AuthenticateAdmin,deleteActivity)  //?should be authenticated
router.delete('/:id/deleteParticipant',Authenticate,RemoveParticipant  )
export { router as trainingRoute };


