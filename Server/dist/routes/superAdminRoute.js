"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.SuperAdmineRouter = void 0;
const express_1 = __importDefault(require("express"));
const SuperAdminController_1 = require("../controllers/SuperAdminController");
const CommonAuth_1 = require("../middleware/CommonAuth");
const router = express_1.default.Router();
exports.SuperAdmineRouter = router;
router.use(CommonAuth_1.AuthenticateSuperAdmin);
router.post('/ChangeToAdmin/:id', SuperAdminController_1.ChangeToAdmin);
