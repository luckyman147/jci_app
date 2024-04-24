"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.Activityroute = void 0;
const express_1 = __importDefault(require("express"));
const activityController_1 = require("../../controllers/activities/activityController");
const router = express_1.default.Router();
exports.Activityroute = router;
router.get('/:id', activityController_1.GetActivityByid);
router.get('/:name', activityController_1.GetActivityByname);
