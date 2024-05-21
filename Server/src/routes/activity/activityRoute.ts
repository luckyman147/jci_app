import express from "express";
import { addGuest, addGuestToAct, addNotes, changeMemberStatus, deleteGuest, deleteNote, GetActivityByid, GetActivityByname, getActivityMembers, getAllGuests, getAllGuestsOfActivity, getAllnotes, updateGuest, updateGuestConfirmation, updateNote } from "../../controllers/activities/activityController";
import { authenticate } from "passport";
import { Authenticate } from "../../middleware/CommonAuth";

const router=express.Router()

router.get('/:id',GetActivityByid)
/**
 * @swagger
 * /activity/{name}:
 *   get:
 *     summary: Get activity by name
 *     parameters:
 *       - in: path
 *         name: name
 *         schema:
 *           type: string
 *         required: true
 *         description: Name of the activity
 *     responses:
 *       200:
 *         description: Success
 *       404:
 *         description: Activity not found
 */

router.get('/notes/:activityId',getAllnotes)
router.post('/notes/:activityId',Authenticate,addNotes)
router.patch('/notes/:activityId/:noteId',updateNote)
router.delete('/notes/:activityId/:noteId',deleteNote)
router.post('/SearchName/get',GetActivityByname)
router.get('/members/:activityId',getActivityMembers)
router.patch('/members',changeMemberStatus)
router.get('/guests/:activityId',getAllGuestsOfActivity)
router.post('/guestsALL',getAllGuests)
router.post('/guests/:activityId',addGuest)
router.post('/guests/:activityId/:guestId',addGuestToAct)
router.delete('/guests/:activityId/:guestId',deleteGuest)
router.patch('/guests/:guestId',updateGuest)
router.patch('/guests/:activityId/:guestId',updateGuestConfirmation)
export { router as Activityroute };
