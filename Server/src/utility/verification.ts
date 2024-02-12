import jwt, { TokenExpiredError } from "jsonwebtoken";
import { MemberPayload } from "../dto/member.dto";
import { Member } from "../models/Member";
import { generateAccessToken } from "./TokenValidity";
require('dotenv').config();

export const  VerifyrefreshToken =async(refrecshToken:string)=>{


    try{
     
   
       const payload = jwt.verify(refrecshToken, process.env.APP_SECRET as string) as MemberPayload;
   
   if (payload){
     if ( !await isRefreshTokenValid(payload._id, refrecshToken)) {
       return { message: 'refresh revoked', accessToken: '' };
     }
   
     const {accessToken} = await generateAccessToken({
       email:payload.email,
       _id:payload._id,
       role:payload.role
     })
   
     return {message:'refresh success',accessToken,refreshToken:refrecshToken}}
   
   else {
     return {message:'refresh error',accessToken:''}
    
   
   }}
   catch (e){
     if (e instanceof TokenExpiredError) {
       return {message:'refresh expired',accessToken:''}}
     
     }
   
   
   return {message:'something wrong',accessToken:''}
    }

    export const isRefreshTokenValid = async (userId:string, refreshToken:string) => {
     try {
       const user = await Member.findById(userId);
   if(user)
       // Check if the refresh token is not in the list of revoked tokens
       return !user.refreshTokenRevoked.includes(refreshToken);
     } catch (error) {
       console.log('Error checking refresh token validity:', error);
       return false;
     }
   };
   
   export const isAccessTokenValid = async (userId:string, AccessToken:string) => {
     try {
       const user = await Member.findById(userId);
   
   if (user)
         return !user.accessTokenRevoked.includes(AccessToken) 
      
   
     } catch (error) {
       console.log('Error checking Access token validity:', error);
       return false;
     }
   };
   export const revokeRefreshToken = async (userId:string, refreshToken:string,accesstoken:string) => {
     try {
       const user = await Member.findById(userId);
   
       if (user) {
   const check=await isRefreshTokenValid(userId,refreshToken) && await isAccessTokenValid(userId,accesstoken)
   console.log
   ("hey  there",check)      
   
   if (check){
   
           
           user.refreshTokenRevoked = user.refreshTokenRevoked || [];
           user.accessTokenRevoked= user.accessTokenRevoked || [];
           // Add the refresh token to the list of revoked tokens
           user.accessTokenRevoked.push(accesstoken)
           user.refreshTokenRevoked.push(refreshToken);
           
           // Save the updated user object to the database
           await user.save();
           return { message: 'Logout successful' }
         }
         else{
   
           return       { message: 'Already logged in' }
         }
       }
     } catch (error) {
       return {message:"Error revoking refresh token"};
     }
   };
   export const revokeAccessToken = async (userId:string, AccessToken:string) => {
     try {
       const user = await Member.findById(userId);
       const check=await isAccessTokenValid(userId,AccessToken)
       console.log
       ("hey  there",check)      
       if (user) {
         
         // Add the refresh token to the list of revoked tokens
         user.accessTokenRevoked.push(AccessToken);
   
         // Save the updated user object to the database
         await user.save();
       }
     } catch (error) {
       console.error('Error revoking Access token:', error);
     }
   };