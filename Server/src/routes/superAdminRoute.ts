import express from 'express'
import { AuthenticateSuperAdmin } from '../middleware/CommonAuth'
import { CreatePermission, DeletePermission, UpdatePermission } from '../controllers'


    


const router=express.Router()
router.use(AuthenticateSuperAdmin)
router.post('/CreatePermission',CreatePermission)
router.patch('/UpdatePermission/:id',UpdatePermission)
router.delete('/DeletePermission/:id',DeletePermission )

export { router as SuperAdmineRouter }

