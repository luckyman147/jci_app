
import express, { Application } from 'express';
import { AuthRouter, MemberRoute, SuperAdmineRouter } from '../routes';
import { AdminRoute } from '../routes/adminRoute';
import nodemailer from 'nodemailer';
const transporter = nodemailer.createTransport({
    service: 'gmail',
    auth: {
      user: 'your-email@gmail.com',
      pass: 'your-email-password',
    },
  });

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
