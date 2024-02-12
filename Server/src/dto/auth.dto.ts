
import { IsEmail, IsNotEmpty, IsStrongPassword, Length, length } from "class-validator";
import { ADminPayload } from "./admin.dto";
import { MemberPayload } from "./member.dto";
import { SuperAdminPayload } from "./superAdmin.dto";

export type AuthPayload=  ADminPayload |SuperAdminPayload | MemberPayload



export class TokenInput {
    @IsNotEmpty()
refreshToken:string

}
export class forgetPasswordInputs{
    @IsNotEmpty()@IsEmail()
    email:string
    @Length(8,13)
    @IsStrongPassword()
    Newpassword:string
}