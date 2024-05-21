// src/app.ts

const express=require('express')
import http from 'http'
import { Server } from 'socket.io';
import {database} from "./services/ConnectDatabase";
import appli from "./services/Express";
const startServer=async()=>{
    const app =express()
    const server = http.createServer(app);
    const io = new Server(server, {
      cors: {
        origin: '*', // Adjust this as necessary for your setup
        methods: ['GET', 'POST',"PUT","DELETE"],
      },
    });
    await database()
    await appli(app,io)
    io.on('connection', (socket) => {
        console.log('a user connected');
        
        // Handle custom events here
        socket.on('disconnect', () => {
          console.log('user disconnected');
        });
    
        // Example custom event
        socket.on('message', (msg) => {
          console.log('message: ' + msg);
        });
      });
    app.listen(8080,()=>{
        console.log('server started 8000')
    })
}

startServer()