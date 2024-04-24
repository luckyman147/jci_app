import { IsNotEmpty, Length } from "class-validator";

export class BoardInput{
    @IsNotEmpty()
    @Length(4,4)
   year: string
}
export class BoardRoleInput{
    @IsNotEmpty()
    name: string
    @IsNotEmpty()
    priority:number

}
export class PostInput{
   
    @IsNotEmpty()
    year: string
    @IsNotEmpty()
    role: any
    assignto:string
}