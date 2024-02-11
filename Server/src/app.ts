// src/app.ts

const express=require('express')
import database from "./services/ConnectDatabase";
import appli from "./services/Express";
const startServer=async()=>{
    const app =express()
    await database()
    await appli(app)
    app.listen(8080,()=>{
        console.log('server started 8000')
    })
}
startServer()