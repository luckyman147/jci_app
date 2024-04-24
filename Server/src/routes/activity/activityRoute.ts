import express from "express";
import { GetActivityByid, GetActivityByname } from "../../controllers/activities/activityController";

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
router.get('/:name',GetActivityByname)
export { router as Activityroute };
