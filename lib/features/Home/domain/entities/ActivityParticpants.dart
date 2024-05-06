import 'package:equatable/equatable.dart';

class ActivityParticipants extends Equatable{
  final dynamic member;
 final  String status;
 const  ActivityParticipants({ required this.member,required this.status});

//to map the data to json
  Map<String, dynamic> toMap() {
    return {
      'member': member,
      'status': status,
    };
  }

  @override
  // TODO: implement props
  List<Object?> get props => [member,status];}