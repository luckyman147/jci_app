"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.SuperAdmineRouter = void 0;
const express_1 = __importDefault(require("express"));
const multer_1 = __importDefault(require("multer"));
const controllers_1 = require("../controllers");
const CommonAuth_1 = require("../middleware/CommonAuth");
const storage = multer_1.default.memoryStorage();
const upload = (0, multer_1.default)({ storage: storage });
const router = express_1.default.Router();
exports.SuperAdmineRouter = router;
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
router.get("/getAllPresidents", controllers_1.getAllPresidents);
router.post('/:id/uploadImage', upload.single("CoverImage"), controllers_1.UpdateLastPresImage);
router.use(CommonAuth_1.AuthenticateSuperAdmin);
router.post('/CreatePermission', controllers_1.CreatePermission);
router.post('/CreateLastPresident', controllers_1.CreateLastPresid);
router.patch('/UpdatePresident/:id', controllers_1.UpdateLastPres);
router.patch('/UpdatePermission/:id', controllers_1.UpdatePermission);
router.delete('/DeletePermission/:id', controllers_1.DeletePermission);
router.delete('/DeleteLastPresident/:id', controllers_1.deleteLastPres);
router.patch('/ChangeToAdmin/:id', controllers_1.ChangeToAdmin);
router.patch('/ChangeToSuper/:id', controllers_1.ChangeToSuperAdmin);
router.patch('/ChangeToMember/:id', controllers_1.ChangeToMember);
