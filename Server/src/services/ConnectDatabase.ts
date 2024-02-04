import mongoose from 'mongoose';

require('dotenv') .config({path:'Server\\src\\.env'})
const database= async ()=>{
    try {
        const MongoURI = process.env.MONGO_URL || 'mongodb://127.0.0.1:27017/jci';
        
        await mongoose.connect(MongoURI)
        console.log('database connected')
    } catch (error) {

        console.log(error)

    }

}
export default  database