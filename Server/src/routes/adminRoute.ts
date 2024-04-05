import express from "express";
import { ChangeToMember, GetAllPermissions, GetMemberById, GetMembers, UpdateCotisation, UpdateMemberPermissions, UpdatePoints, createRole, searchByName, validateMember } from "../controllers";
import { Authenticate, AuthenticateAdmin } from "../middleware/CommonAuth";



const router =express.Router()
 router.use(AuthenticateAdmin)
 router.get('/Members',GetMembers)
 router.get('/Member/:id',GetMemberById)
 router.get('/Member/name/:name',searchByName)
 router.get("/Permissions",GetAllPermissions)
 router.post('/Role',createRole)
 router.patch('/changeRole/:id',ChangeToMember)
 router.patch('/Member/:id/validate',validateMember)
 router.patch('/Member/:id/UpdatePoints',UpdatePoints)
 router.patch('/Member/:id/Permissions',UpdateMemberPermissions)

 router.patch('/Member/:id/UpdateCotisation',UpdateCotisation)

export { router as AdminRoute };
