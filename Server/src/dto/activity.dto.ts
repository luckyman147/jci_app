import { IsNotEmpty } from 'class-validator'

export interface EventOftheMonthField {
    _id:string
    name: string
    LeaderName:string
    ActivityBegindate: Date
    ActivityEnddate: Date
registrationDeadline: Date

    description:string

    ActivityPoints:number
    categorie:string
        IsPaid:boolean
        price:number
    ActivityAdress:string
    participants:any []
    CoverImages:string[]

}export interface MeetingField {
    _id:string
    name: string
    Director:any




ActivityBegindate: Date

Agenda:[string]

description:string

ActivityPoints:number
categorie:string
 
participants:any []


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
LeaderName:string
}export class MeetingInputs{
    @IsNotEmpty()
    name:string
    @IsNotEmpty()
description:string
@IsNotEmpty()
agenda:[string]
@IsNotEmpty()
ActivityBeginDate:Date

ActivityPoints:number




@IsNotEmpty()
categorie:string


@IsNotEmpty()
Director:any

}
export interface TrainingField {
    _id:string
    name: string
    
    ActivityBegindate: Date
    ActivityEnddate: Date

    ProfesseurName:string
    Duration:number

    description:string

    ActivityPoints:number
    categorie:string
        IsPaid:boolean
        price:number
    ActivityAdress:string
    participants:any []
    CoverImages:string[]

}
export class TrainingInputs{
    @IsNotEmpty()
    name:string
    @IsNotEmpty()
description:string
@IsNotEmpty()
IsPaid:boolean
@IsNotEmpty()
ActivityBeginDate:Date
@IsNotEmpty()
ActivityEndDate:Date
@IsNotEmpty()
price:number
ActivityPoints:number
ActivityAdress:string



@IsNotEmpty()
categorie:string
@IsNotEmpty()
ProfesseurName:string




}