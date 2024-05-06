import express from 'express'
import { EditmemberProfile, GetmemberProfile, MemberVerifyEmail,updateImageProfile, updateLanguage } from '../controllers'
import { Authenticate } from '../middleware/CommonAuth'
import multer from 'multer'

    


const router=express.Router()
const storage = multer.memoryStorage()
const upload = multer({ storage: storage })
router.patch('/profile/:id/UpdateImage',upload.single("CoverImages"),updateImageProfile)

router.use(Authenticate)
//&verify
router.patch('/verify',MemberVerifyEmail)

//?profil
router.get('/profile',GetmemberProfile)

router.patch('/profile',Authenticate,EditmemberProfile)
router.patch('/updateLanguage',Authenticate,updateLanguage)


export { router as MemberRoute }
