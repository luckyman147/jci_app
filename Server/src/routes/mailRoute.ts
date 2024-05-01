import express from 'express'
import { SendEmailVerificationCode, SendResetPasswordVerificationCode } from '../controllers/mail/mailController'
const router=express.Router()

router.post ('/VerifyEmails',SendEmailVerificationCode)
router.post ('/ResetPasswordMails',SendResetPasswordVerificationCode)
export { router as mailRoute }
