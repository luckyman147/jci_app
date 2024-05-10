import express from "express";
import { addGuestToActivity, changeMemberStatus, deleteGuest, GetActivityByid, GetActivityByname, getActivityMembers, getAllGuests, getAllGuestsOfActivity, updateGuest, updateGuestConfirmation } from "../../controllers/activities/activityController";

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
router.post('/SearchName/get',GetActivityByname)
router.get('/members/:activityId',getActivityMembers)
router.patch('/members',changeMemberStatus)
router.get('/guests/:activityId',getAllGuestsOfActivity)
router.post('/guestsALL',getAllGuests)
router.post('/guests/:activityId',addGuestToActivity)
router.delete('/guests/:activityId/:guestId',deleteGuest)
router.patch('/guests/:guestId',updateGuest)
router.patch('/guests/:activityId/:guestId',updateGuestConfirmation)
export { router as Activityroute };
