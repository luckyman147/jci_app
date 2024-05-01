
import express, { Application } from 'express';
import morgan from "morgan";
import { specs, specs2, swaggerUi, swaggerUiOptions1, swaggerUiOptions2 } from '../config/swaggerConfig';
import { AuthRouter, BoardRouter, MemberRoute, SuperAdmineRouter } from '../routes';
import { trainingRoute } from '../routes/activity/TrainingRoute';
import { Activityroute } from '../routes/activity/activityRoute';
import { EventRoute } from '../routes/activity/eventRoute';
import { meetingRoute } from '../routes/activity/meetingRoute';
import { AdminRoute } from '../routes/adminRoute';
import { BoardRoleRouter } from '../routes/board/BoardRoleRoute';
import { PosRouter } from '../routes/board/PosRoute';
import { TeamRoute } from '../routes/team/TeamRoute';
import { mailRoute } from '../routes/mailRoute';


const appli= async (app:Application)=>{
// Middleware to handle form data

const maxRequestBodySize = '100mb';
app.use(express.json({limit: maxRequestBodySize}));
app.use(express.urlencoded({limit: maxRequestBodySize,extended:true}));
app.use(morgan("tiny"));

app.use(express.static("public"));
app.use('/mails',mailRoute)
app.use("/Board",BoardRouter)
app.use("/BoardRole",BoardRoleRouter)
app.use("/PositionOfMember",PosRouter)
app.use('/member',MemberRoute)
app.use('/admin',AdminRoute)
app.use('/Super',SuperAdmineRouter)
app.use('/auth',AuthRouter)
app.use("/Event",EventRoute)
app.use("/Meeting",meetingRoute)
app.use("/Activity  ",Activityroute)
app.use("/Training",trainingRoute)
app.use('/Team',TeamRoute)
app.use('/api-docs-1', swaggerUi.serve, swaggerUi.setup(specs));
app.use('/api-docs-2', swaggerUi.serve, swaggerUi.setup(specs2));
return app
}
export default appli
