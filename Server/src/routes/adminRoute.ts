import express, { NextFunction, Request, Response } from "express";
import { GetMemberById, GetMembers, SearchByName, createRole } from "../controllers";



const router =express.Router()
 //router.use(AuthenticateAdmin)
 router.get('/Members',GetMembers)
 router.get('/Member/:id',GetMemberById)
 router.get('/Member/:name',SearchByName)
 router.post('/Role',createRole)
export { router as AdminRoute };
