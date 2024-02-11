import express from "express";
import { MemberLogin, MemberSignUp, RefreshTokenAccess, forgetPassword, logout } from "../controllers";
import { Authenticate} from "../middleware/CommonAuth";


const router =express.Router()

//!Signup
router.post('/signup',MemberSignUp)
// router.post('/signupWithGoogle',MemberSignUp)
// router.post('/signupWithFacebook',MemberSignUp)

router.patch('/forgetPassword',forgetPassword)
//*login
router.post('/login',MemberLogin)
// router.post('/loginWithFacebook',MemberLogin)
// router.post('/loginWithGoogle',MemberLogin)
router .delete('/logout',logout)
router .get('/RefreshToken',Authenticate,RefreshTokenAccess)
router .get('/AccessToken')
//router.use(AuthenticateSuperAdmin)
//router .get('/getRole')

export { router as AuthRouter };

