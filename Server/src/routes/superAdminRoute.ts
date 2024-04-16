import express from 'express'
import { ChangeToAdmin, ChangeToMember, ChangeToSuperAdmin, CreateLastPresid, CreatePermission, deleteLastPres, DeletePermission, getAllPresidents, UpdateLastPres, UpdateLastPresImage, UpdatePermission } from '../controllers'
import { AuthenticateSuperAdmin } from '../middleware/CommonAuth'
import multer from 'multer'


    
const storage = multer.memoryStorage()
const upload = multer({ storage: storage })

const router=express.Router()
router.get("/getAllPresidents",getAllPresidents)
router.post('/:id/uploadImage',upload.single("CoverImage"),UpdateLastPresImage)

router.use(AuthenticateSuperAdmin)
router.post('/CreatePermission',CreatePermission)
router.post('/CreateLastPresident',CreateLastPresid)
router.patch('/UpdatePresident/:id',UpdateLastPres)

router.patch('/UpdatePermission/:id',UpdatePermission)
router.delete('/DeletePermission/:id',DeletePermission )
router.delete('/DeleteLastPresident/:id',deleteLastPres )
router.patch('/ChangeToAdmin/:id',ChangeToAdmin)
router.patch('/ChangeToSuper/:id',ChangeToSuperAdmin)
router.patch('/ChangeToMember/:id',ChangeToMember)


export { router as SuperAdmineRouter }

