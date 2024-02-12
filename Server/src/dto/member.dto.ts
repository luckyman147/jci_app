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
 
    @Length(6,16)
    firstname:string

    @Length(6,16)
    lastname:string
    @Length(6,16)
    address:string
    @Length(8,12)
    phone:string
    @Length(10,100)
    description:string



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