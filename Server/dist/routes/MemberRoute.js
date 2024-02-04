"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.MemberRoute = void 0;
const express_1 = __importDefault(require("express"));
const controllers_1 = require("../controllers");
const CommonAuth_1 = require("../middleware/CommonAuth");
const router = express_1.default.Router();
exports.MemberRoute = router;
router.use(CommonAuth_1.Authenticate);
//&verify
router.patch('/verify', controllers_1.MemberVerifyEmail);
//?profil
router.get('/profile', controllers_1.GetmemberProfile);
router.patch('/profile', controllers_1.EditmemberProfile);
