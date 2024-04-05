import { IsEmail, IsNotEmpty, Length,IsStrongPassword, isNotEmpty } from 'class-validator'

export class CreateMemberInputs{
    @IsEmail()
    email:string

  
      
    @IsNotEmpty()
    @Length(6,20)

    password:string
    @IsNotEmpty()

    firstName:string
    @IsNotEmpty()

    lastName:string
}
export class EditMemberProfileInputs{
 
   @IsNotEmpty()
    firstName:string

     @IsNotEmpty()
    lastName:string
 
     @IsNotEmpty()
    phone:string




}
export class MemberLoginInputs{
    @IsEmail()
    email:string

  
      
    @IsNotEmpty()
    @Length(6,12)
    password:string
}
export interface MemberPayload{
    _id:string
    email:string 
    role:string

}
export interface EmailPayload{
    email:string,
    _id:string
}