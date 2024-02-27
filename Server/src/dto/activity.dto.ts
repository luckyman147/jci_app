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
    CoverImages:[string]

}export interface MeetingField {
    _id:string
    name: string
    Director:any
Duration:number



ActivityBegindate: Date
ActivityEnddate: Date


description:string

ActivityPoints:number
categorie:string
    IsPaid:boolean
    price:number
ActivityAdress:string
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
isPaid:boolean
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
    CoverImages:[string]

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
ActivityAdress:string



@IsNotEmpty()
categorie:string
@IsNotEmpty()
ProfesseurName:string




}