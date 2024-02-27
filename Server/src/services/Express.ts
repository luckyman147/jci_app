
import express, { Application } from 'express';
import { AuthRouter, MemberRoute, SuperAdmineRouter } from '../routes';
import { EventRoute } from '../routes/activity/eventRoute';
import { meetingRoute } from '../routes/activity/meetingRoute';
import { AdminRoute } from '../routes/adminRoute';
import { trainingRoute } from '../routes/activity/TrainingRoute';
import { Activityroute } from '../routes/activity/activityRoute';


const appli= async (app:Application)=>{
// Middleware to handle form data


app.use(express.json())

app.use(express.urlencoded({extended:true}))

app.use('/member',MemberRoute)
app.use('/admin',AdminRoute)
app.use('/Super',SuperAdmineRouter)
app.use('/auth',AuthRouter)
app.use("/Event",EventRoute)
app.use("/Meeting",meetingRoute)
app.use("/Activity  ",Activityroute)
app.use("/Training",trainingRoute)
return app
}
export default appli
