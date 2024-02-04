"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.AdminRoute = void 0;
const express_1 = __importDefault(require("express"));
const controllers_1 = require("../controllers");
const CommonAuth_1 = require("../middleware/CommonAuth");
const router = express_1.default.Router();
exports.AdminRoute = router;
router.use(CommonAuth_1.AuthenticateAdmin);
router.get('/Members', controllers_1.GetMembers);
router.get('/Member/:id', controllers_1.GetMemberById);
router.get('/Member/:name', controllers_1.SearchByName);
router.post('/Role', controllers_1.createRole);
