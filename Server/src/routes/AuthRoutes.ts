import express from "express";
import passport from "passport";
import { MemberLogin, MemberSignUp, RefreshTokenAccess, forgetPassword, logout } from "../controllers";
import { Authenticate, AuthenticateSuperAdmin } from "../middleware/CommonAuth";


const router =express.Router()

//!Signup
router.post('/signup',MemberSignUp)
router.get('/google', passport.authenticate("google", {
    scope: ["email", "profile"],
  }))
  router.get("/google/redirect", passport.authenticate("google"), (req, res) => {
    res.send("This is the callback route");
  });
  
// router.post('/signupWithFacebook',MemberSignUp)

router.patch('/forgetPassword',forgetPassword)
//*login
router.post('/login',MemberLogin)

// router.post('/loginWithFacebook',MemberLogin)
// router.post('/loginWithGoogle',MemberLogin)
router .post('/logout',  Authenticate,logout)
router .post ('/RefreshToken',RefreshTokenAccess)
router .get('/verifyAccessToken')
router.use(AuthenticateSuperAdmin)
router .get('/getRole')

export { router as AuthRouter };

