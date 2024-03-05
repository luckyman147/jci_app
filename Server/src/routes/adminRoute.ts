import express from "express";
import { ChangeToMember, GetMemberById, GetMembers, createRole, searchByName } from "../controllers";
import { Authenticate } from "../middleware/CommonAuth";



const router =express.Router()
 router.use(Authenticate)
 router.get('/Members',GetMembers)
 router.get('/Member/:id',GetMemberById)
 router.get('/Member/name/:name',searchByName)
 router.post('/Role',createRole)
 router.patch('/changeRole/:id',ChangeToMember)
export { router as AdminRoute };
