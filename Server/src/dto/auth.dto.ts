
import { IsEmail, IsNotEmpty, IsStrongPassword, Length, length } from "class-validator";
import { ADminPayload } from "./admin.dto";
import { EmailPayload, MemberPayload } from "./member.dto";
import { SuperAdminPayload } from "./superAdmin.dto";

export type AuthPayload=  ADminPayload |SuperAdminPayload | MemberPayload | EmailPayload



export class TokenInput {
    @IsNotEmpty()
refreshToken:string

}
export class forgetPasswordInputs{
    @IsNotEmpty()
    @IsEmail()
    email:string
    @Length(8,13)
    password:string
}
