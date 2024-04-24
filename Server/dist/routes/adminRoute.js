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
/**
 * @swagger
 * /hello/{name}:
 *   get:
 *     summary: Returns a personalized hello message
 *     parameters:
 *       - in: path
 *         name: name
 *         required: true
 *         schema:
 *           type: string
 *     responses:
 *       200:
 *         description: A personalized hello message
 */
router.use(CommonAuth_1.AuthenticateAdmin);
router.get('/Members', controllers_1.GetMembers);
router.get('/Member/:id', controllers_1.GetMemberById);
router.get('/Member/name/:name', controllers_1.searchByName);
router.get("/Permissions", controllers_1.GetAllPermissions);
router.post('/Role', controllers_1.createRole);
router.patch('/changeRole/:id', controllers_1.ChangeToMember);
router.patch('/Member/:id/validate', controllers_1.validateMember);
router.patch('/Member/:id/UpdatePoints', controllers_1.UpdatePoints);
router.patch('/Member/:id/Permissions', controllers_1.UpdateMemberPermissions);
router.patch('/Member/:id/UpdateCotisation', controllers_1.UpdateCotisation);
