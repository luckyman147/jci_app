import express from 'express';
import multer from 'multer';

import { ChangeToAdmin, ChangeToMember, ChangeToSuperAdmin, CreateLastPresid, CreatePermission, deleteLastPres, DeletePermission, getAllPresidents, UpdateLastPres, UpdateLastPresImage, UpdatePermission } from '../controllers';
import { AuthenticateSuperAdmin } from '../middleware/CommonAuth';

require('dotenv') .config({path:'Server\\src\\.env'})


const storage = multer.memoryStorage();

const upload = multer({ 
  storage: storage,  
  limits: { fileSize: 20000000 } // Limit file size to 1MB (optional)
});

const router=express.Router()

router.get("/getAllPresidents",getAllPresidents)
/**
 * @swagger
 * /Super/{id}/uploadImage:
 *   post:
 *     summary: Upload a file by  president id ID 
 
 *     consumes:
 *       - multipart/form-data
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: string
 *         description: ID of the  president
 *     
 *       - in: formData
 *         name: CoverImage
 *         required: true
 *         schema:
 *           type: file
 *         description: The file to upload
 *     responses:
 *       201:
 *         description: File uploaded successfully

 */
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


export { router as SuperAdmineRouter };

