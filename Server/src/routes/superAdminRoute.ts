import express from 'express'
import { ChangeToAdmin } from '../controllers/SuperAdminController'


    


const router=express.Router()
//router.use(AuthenticateSuperAdmin)
//router.post('/ChangeToAdmin/:id',ChangeToAdmin)
export { router as SuperAdmineRouter }

