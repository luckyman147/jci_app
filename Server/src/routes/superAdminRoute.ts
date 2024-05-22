import express from 'express';
import multer from 'multer';

import { ChangeToAdmin, ChangeToMember, ChangeToSuperAdmin, CreateLastPresid, CreatePermission, deleteLastPres, deleteMember, DeletePermission, getAllPresidents, UpdateLastPres, UpdateLastPresImage, UpdatePermission } from '../controllers';
import { AuthenticateSuperAdmin } from '../middleware/CommonAuth';

require('dotenv') .config({path:'Server\\src\\.env'})


const storage = multer.memoryStorage();

const upload = multer({ 
  storage: storage,  
  limits: { fileSize: 20000000 } // Limit file size to 1MB (optional)
});

const router=express.Router()
/**
 * @swagger
 * /Super/getAllPresidents:
 *   get:
 *     summary: Get presidents
 *     parameters:
 *       - in: query
 *         name: start
 *         required: true
 *         schema:
 *           type: string
 *         description: Start
 *       - in: query
 *         name: format
 *         required: false
 *         schema:
 *           type: string
 *         description: Format of the uploaded file
 *     responses:
 *       200:
 *         description: Successful response
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 message:
 *                   type: string
 *                   description: A message indicating the success of the operation
 *                 presidents:
 *                   type: array
 *                   items:
 *                     type: object
 *                     properties:
 *                       id:
 *                         type: integer
 *                         description: The ID of the president
 *                       name:
 *                         type: string
 *                         description: The name of the president
 *                       country:
 *                         type: string
 *                         description: The country of the president
 *         example:
 *           message: Success
 *           presidents:
 *             - id: 1
 *               name: John Doe
 *               country: USA
 *             - id: 2
 *               name: Jane Smith
 *               country: Canada
 */


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
router.delete('/member/:id',deleteMember)
router.patch('/UpdatePermission/:id',UpdatePermission)
router.delete('/DeletePermission/:id',DeletePermission )
router.delete('/DeleteLastPresident/:id',deleteLastPres )
router.patch('/ChangeToAdmin/:id',ChangeToAdmin)
router.patch('/ChangeToSuper/:id',ChangeToSuperAdmin)
router.patch('/ChangeToMember/:id',ChangeToMember)


export { router as SuperAdmineRouter };

