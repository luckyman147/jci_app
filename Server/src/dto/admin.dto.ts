import { IsEmail, IsNotEmpty, IsPhoneNumber, Length, isNotEmpty } from 'class-validator'
export class CreateRoleInput{
    @IsNotEmpty()
    @Length(5,10)
    name:string

    description:string
}
export interface ADminPayload{
    _id:string
    email:string 
    is_admin:boolean
    role:string
    phone:string
    Admin_validity:Date
    
}
