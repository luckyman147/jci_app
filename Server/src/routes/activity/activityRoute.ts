import express from "express";
import { GetActivityByid, GetActivityByname } from "../../controllers/activities/activityController";

const router=express.Router()

router.get('/:id',GetActivityByid)
router.get('/:name',GetActivityByname)
export { router as Activityroute };