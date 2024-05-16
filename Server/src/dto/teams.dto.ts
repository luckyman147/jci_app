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
export class CommentInput{
    
    @IsNotEmpty()
    comment:string
    
}
export class TeamInputs{
    @IsNotEmpty()
    name:string
    @IsNotEmpty()
description:string
@IsNotEmpty()

event:string
Members:any[]
status:boolean
tasks:any []
}
export interface TasksField{
    id:string
    name: string
    AssignTo:any[]
    Deadline: Date
    StartDate: Date
    description:string
    attachedFile: String
    CheckList: any[]
    isCompleted:boolean

}

export class  IsCompletedInput{
    @IsNotEmpty()
    IsCompleted:boolean

}export class  TimelineInput{
    @IsNotEmpty()
    StartDate:Date
    @IsNotEmpty()
    Deadline:Date
}export class  MembersInput{
    @IsNotEmpty()
    Member:string
    @IsNotEmpty()
    Status:string
}export class  firstTaskInput{
    @IsNotEmpty()
    name:string
}export class  FilesInput{
    @IsNotEmpty()
    attachedFile:string
}
export class TaskInput{
    @IsNotEmpty()
    name:string
    @IsNotEmpty() 
    Deadline: Date 
    @IsNotEmpty()
    StartDate:Date
    description:string
    AssignTo:any[]
   
    attachedFile: string
    CheckList: any[]
}