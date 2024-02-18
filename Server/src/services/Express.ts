
import express, { Application } from 'express';
import { AuthRouter, MemberRoute, SuperAdmineRouter } from '../routes';
import { AdminRoute } from '../routes/adminRoute';


const appli= async (app:Application)=>{

app.use(express.json())
app.use(express.urlencoded({extended:true}))

app.use('/member',MemberRoute)
app.use('/admin',AdminRoute)
app.use('/Super',SuperAdmineRouter)
app.use('/auth',AuthRouter)
return app
}
export default appli
