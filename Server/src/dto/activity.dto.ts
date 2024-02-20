import { IsNotEmpty } from 'class-validator'

export interface EventOftheMonthField {
    _id:string
    name: string
    LeaderName:string
    ActivityBegindate: Date
    ActivityEnddate: Date
    ActivityAdress:string
    participants:any []
    CoverImages:[string]

}export interface MeetingField {
    _id:string
    name: string
    Director:any
Duration:number
type:string



    Begindate: Date
    Enddate: Date
    place:string
    participants:any []
    CoverImages:[string]

}
export class EventInputs{
    @IsNotEmpty()
    name:string
    @IsNotEmpty()
description:string

@IsNotEmpty()
ActivityBeginDate:Date
@IsNotEmpty()
ActivityEndDate:Date

@IsNotEmpty()
ActivityAdress:string



IsPaid:boolean
@IsNotEmpty()
categorie:string


@IsNotEmpty()
registrationDeadline: Date
@IsNotEmpty()
LeaderName:String
}export class MeetingInputs{
    @IsNotEmpty()
    name:string
    @IsNotEmpty()
description:string

@IsNotEmpty()
ActivityBeginDate:Date
@IsNotEmpty()
ActivityEndDate:Date

@IsNotEmpty()
ActivityAdress:string



@IsNotEmpty()
categorie:string


@IsNotEmpty()
Duration:number
@IsNotEmpty()
Director:any
@IsNotEmpty()
type:string
}
