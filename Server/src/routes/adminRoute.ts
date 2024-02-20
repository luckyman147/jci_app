import express from "express";
import { ChangeToMember, GetMemberById, GetMembers, SearchByName, createRole } from "../controllers";
import { AuthenticateAdmin } from "../middleware/CommonAuth";



const router =express.Router()
 router.use(AuthenticateAdmin)
 router.get('/Members',GetMembers)
 router.get('/Member/:id',GetMemberById)
 router.get('/Member/:name',SearchByName)
 router.post('/Role',createRole)
 router.patch('/changeRole/:id',ChangeToMember)
export { router as AdminRoute };
