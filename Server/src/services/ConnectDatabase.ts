import mongoose, { ConnectOptions } from 'mongoose';
import { GridFSBucket } from 'mongodb';
require('dotenv') .config({path:'Server\\src\\.env'}) 
let gfs;
const database= async ()=>{
    try {
        const MongoURI = process.env.MONGO_URL ;
      
        await mongoose.connect(MongoURI!)
        const conn = mongoose.connection;
       
        

            
        console.log('database connected')
        
    } catch (error) {

        console.log(error)

    }

}
export   {database}