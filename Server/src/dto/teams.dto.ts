import { IsNotEmpty } from "class-validator"

export interface TeamField {
    _id:string
    name: string

description:string
tasks:any[]
members:any []
event:string
coverImage:string
}
export class TeamInputs{
    @IsNotEmpty()
    name:string
    @IsNotEmpty()
description:string
@IsNotEmpty()

Event:string
Members:any[]
tasks:any []
}

export class TaskInput{
    @IsNotEmpty()
    name:string
    AssignTo:any
    Deadline: Date 
    attachedFile: String
    CheckList: any[]
}