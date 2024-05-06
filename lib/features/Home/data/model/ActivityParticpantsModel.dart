import 'package:jci_app/features/Home/domain/entities/ActivityParticpants.dart';

class ActivityParticipantsModel extends ActivityParticipants{
  ActivityParticipantsModel({required member, required status})
      : super(member: member, status: status);

  factory ActivityParticipantsModel.fromJson(Map<String, dynamic> json) {
    return ActivityParticipantsModel(
      member: json['member'] as dynamic,
      status: json['status'],
    );}
  }