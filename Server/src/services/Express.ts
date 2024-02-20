
import express, { Application } from 'express';
import multer from 'multer';
import { AuthRouter, MemberRoute, SuperAdmineRouter } from '../routes';
import { EventRoute } from '../routes/activity/eventRoute';
import { AdminRoute } from '../routes/adminRoute';


const appli= async (app:Application)=>{
// Middleware to handle form data


app.use(express.json())

app.use(express.urlencoded({extended:true}))

app.use('/member',MemberRoute)
app.use('/admin',AdminRoute)
app.use('/Super',SuperAdmineRouter)
app.use('/auth',AuthRouter)
app.use("/Event",EventRoute)
app.use("/Meeting",EventRoute)
return app
}
export default appli
