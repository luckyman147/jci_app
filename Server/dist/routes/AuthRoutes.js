"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = __importDefault(require("express"));
const controllers_1 = require("../controllers");
const CommonAuth_1 = require("../middleware/CommonAuth");
const router = express_1.default.Router();
//!Signup
router.post('/signup', controllers_1.MemberSignUp);
// router.post('/signupWithGoogle',MemberSignUp)
// router.post('/signupWithFacebook',MemberSignUp)
//*login
router.post('/login', controllers_1.MemberLogin);
// router.post('/loginWithFacebook',MemberLogin)
// router.post('/loginWithGoogle',MemberLogin)
router.delete('/logout', controllers_1.logout);
router.get('/RefreshToken');
router.get('/AccessToken');
router.use(CommonAuth_1.AuthenticateSuperAdmin);
router.get('/getRole');
