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
export class ValidatePoints{
    @IsNotEmpty()
    Points:number
    @IsNotEmpty()
    action:boolean //true=> increrase + false=>decrease -
}
export class ValidateCotisation{
    @IsNotEmpty()
    type:number //* 1 => first cotisation 2=> second 
    @IsNotEmpty()
    action:boolean //true=> validate
}
export class ValidateMember{
    @IsNotEmpty()
    action:boolean;
}
