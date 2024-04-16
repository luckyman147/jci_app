
import { IsEmail, IsNotEmpty, Length } from "class-validator";
import { SuperAdminPayload } from "./superAdmin.dto";
import { ADminPayload } from "./admin.dto";
import { EmailPayload, MemberPayload } from "./member.dto";

export type AuthPayload=   ADminPayload|SuperAdminPayload | MemberPayload 



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
