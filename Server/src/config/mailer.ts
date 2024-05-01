
import nodemailer from 'nodemailer';

require('dotenv').config();
export const transporter = nodemailer.createTransport({
  host: 'ssl0.ovh.net', // OVH SMTP server
  port: 465, // OVH SMTP port for SSL
  secure: true,
    auth: {
      user: process.env.EMAIL,
      pass: process.env.PASSWORD,
    },
  });
export const transporterContact = nodemailer.createTransport({
  host: 'ssl0.ovh.net', // OVH SMTP server
  port: 465, // OVH SMTP port for SSL
  secure: true,
    auth: {
      user: process.env.EMAIL,
      pass: process.env.PASSWORD,
    },
  });
  
