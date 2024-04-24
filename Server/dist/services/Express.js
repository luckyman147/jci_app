"use strict";
var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    function adopt(value) { return value instanceof P ? value : new P(function (resolve) { resolve(value); }); }
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : adopt(result.value).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments || [])).next());
    });
};
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = __importDefault(require("express"));
const swaggerConfig_1 = require("../config/swaggerConfig");
const routes_1 = require("../routes");
const TrainingRoute_1 = require("../routes/activity/TrainingRoute");
const activityRoute_1 = require("../routes/activity/activityRoute");
const eventRoute_1 = require("../routes/activity/eventRoute");
const meetingRoute_1 = require("../routes/activity/meetingRoute");
const adminRoute_1 = require("../routes/adminRoute");
const TeamRoute_1 = require("../routes/team/TeamRoute");
const appli = (app) => __awaiter(void 0, void 0, void 0, function* () {
    // Middleware to handle form data
    const maxRequestBodySize = '100mb';
    app.use(express_1.default.json({ limit: maxRequestBodySize }));
    app.use(express_1.default.urlencoded({ limit: maxRequestBodySize, extended: true }));
    app.use('/member', routes_1.MemberRoute);
    app.use('/admin', adminRoute_1.AdminRoute);
    app.use('/Super', routes_1.SuperAdmineRouter);
    app.use('/auth', routes_1.AuthRouter);
    app.use("/Event", eventRoute_1.EventRoute);
    app.use("/Meeting", meetingRoute_1.meetingRoute);
    app.use("/Activity  ", activityRoute_1.Activityroute);
    app.use("/Training", TrainingRoute_1.trainingRoute);
    app.use('/Team', TeamRoute_1.TeamRoute);
    app.use('/api-docs', swaggerConfig_1.swaggerUi.serve, swaggerConfig_1.swaggerUi.setup(swaggerConfig_1.specs));
    return app;
});
exports.default = appli;
