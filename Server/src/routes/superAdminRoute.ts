import express from 'express'
import { ChangeToAdmin } from '../controllers/SuperAdminController'
import { AuthenticateSuperAdmin } from '../middleware/CommonAuth'

    


const router=express.Router()
router.use(AuthenticateSuperAdmin)
router.post('/ChangeToAdmin/:id',ChangeToAdmin)
export { router as SuperAdmineRouter }

