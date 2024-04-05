
import express, { Application } from 'express';
import { AuthRouter, MemberRoute, SuperAdmineRouter } from '../routes';
import { EventRoute } from '../routes/activity/eventRoute';
import { meetingRoute } from '../routes/activity/meetingRoute';
import { AdminRoute } from '../routes/adminRoute';
import { trainingRoute } from '../routes/activity/TrainingRoute';
import { Activityroute } from '../routes/activity/activityRoute';
import { TeamRoute } from '../routes/team/TeamRoute';


const appli= async (app:Application)=>{
// Middleware to handle form data

const maxRequestBodySize = '100mb';
app.use(express.json({limit: maxRequestBodySize}));
app.use(express.urlencoded({limit: maxRequestBodySize,extended:true}));


app.use('/member',MemberRoute)
app.use('/admin',AdminRoute)
app.use('/Super',SuperAdmineRouter)
app.use('/auth',AuthRouter)
app.use("/Event",EventRoute)
app.use("/Meeting",meetingRoute)
app.use("/Activity  ",Activityroute)
app.use("/Training",trainingRoute)
app.use('/Team',TeamRoute)
return app
}
export default appli
