import express from 'express'
import { reportInactivityEmail, reportMembershipEmail, SendEmailVerificationCode, SendReminderActivity, SendReportDeadlineTask, SendResetPasswordVerificationCode } from '../controllers/mail/mailController'
const router=express.Router()

router.post ('/VerifyEmails',SendEmailVerificationCode)
router.post ('/ResetPasswordMails',SendResetPasswordVerificationCode)
router.post ('/reportmembership/:memberid',reportMembershipEmail)
router.post ('/reportInactivity/:memberid',reportInactivityEmail)
router.post ('/repostunfinishedTask/:taskid',SendReportDeadlineTask)
router.post ('/                                                                                                                                                                                             /:activityId',SendReminderActivity)
export { router as mailRoute }
