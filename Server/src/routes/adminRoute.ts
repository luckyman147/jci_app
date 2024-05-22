import express from "express";
import { ChangeGuestToNewMember, ChangeToMember, GetAllPermissions, GetMemberById, GetMembers, UpdateCotisation, UpdateMemberPermissions, UpdatePoints, createRole, searchByName, validateMember } from "../controllers";
import { AuthenticateAdmin } from "../middleware/CommonAuth";



const router =express.Router()
/**
 * @swagger
 * /hello/{name}:
 *   get:
 *     summary: Returns a personalized hello message
 *     parameters:
 *       - in: path
 *         name: name
 *         required: true
 *         schema:
 *           type: string
 *     responses:
 *       200:
 *         description: A personalized hello message
 */
 router.use(AuthenticateAdmin)
 router.get('/Members',GetMembers)
 router.get('/Member/:id',GetMemberById)
 router.get('/Member/name/:name',searchByName)
router.post('/guest/ChangeToMember/:guestId',ChangeGuestToNewMember)
 router.get("/Permissions",GetAllPermissions)
 router.post('/Role',createRole)
 router.patch('/changeRole/:id',ChangeToMember)
 router.patch('/Member/:id/validate',validateMember)
 router.patch('/Member/:id/UpdatePoints',UpdatePoints)
 router.patch('/Member/:id/Permissions',UpdateMemberPermissions)

 router.patch('/Member/:id/UpdateCotisation',UpdateCotisation)

export { router as AdminRoute };
