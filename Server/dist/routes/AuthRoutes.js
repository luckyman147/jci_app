"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.AuthRouter = void 0;
const express_1 = __importDefault(require("express"));
const passport_1 = __importDefault(require("passport"));
const controllers_1 = require("../controllers");
const CommonAuth_1 = require("../middleware/CommonAuth");
const router = express_1.default.Router();
exports.AuthRouter = router;
//!Signup
router.post('/signup', controllers_1.MemberSignUp);
router.get('/google', passport_1.default.authenticate("google", {
    scope: ["email", "profile"],
}));
router.get("/google/redirect", passport_1.default.authenticate("google"), (req, res) => {
    res.send("This is the callback route");
});
// router.post('/signupWithFacebook',MemberSignUp)
router.patch('/forgetPassword', controllers_1.forgetPassword);
//*login
router.post('/login', controllers_1.MemberLogin);
// router.post('/loginWithFacebook',MemberLogin)
// router.post('/loginWithGoogle',MemberLogin)
router.post('/logout', CommonAuth_1.Authenticate, controllers_1.logout);
router.post('/RefreshToken', controllers_1.RefreshTokenAccess);
router.get('/verifyAccessToken');
router.use(CommonAuth_1.AuthenticateSuperAdmin);
router.get('/getRole');
