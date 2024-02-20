import express from 'express'
import { EditmemberProfile, GetmemberProfile, MemberVerifyEmail } from '../controllers'
import { Authenticate } from '../middleware/CommonAuth'

    


const router=express.Router()


router.use(Authenticate)
//&verify
router.patch('/verify',MemberVerifyEmail)

//?profil
router.get('/profile',GetmemberProfile)
router.patch('/profile',EditmemberProfile)


export { router as MemberRoute }
