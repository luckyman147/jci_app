import { IsEmail, IsNotEmpty, IsPhoneNumber, Length, isNotEmpty } from 'class-validator'

export interface SuperAdminPayload{
    _id:string
    email:string 
    role:string
    is_super_admin:boolean
    phone:string
    SuperAdmin_validity:Date
    pincode:number
    
}
