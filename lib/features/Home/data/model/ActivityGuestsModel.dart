import 'package:jci_app/features/Home/data/model/GuestModel.dart';
import 'package:jci_app/features/Home/domain/entities/ActivityGuest.dart';

import '../../domain/entities/Guest.dart';

class ActivityguestModel extends ActivityGuest{
  const ActivityguestModel({required guest, required status})
      : super(guest: guest, status: status);

  factory ActivityguestModel.fromJson(Map<String, dynamic> json) {
    return ActivityguestModel(
      //list of guests
      guest: json['guest']!=null? GuestModel.fromJson(json['guest'] as Map<String, dynamic>) as Guest:Guest(id: "id", name: "name", email: "email", phone: "phone", isConfirmed: true),
      status: json['status'],
    );}
   Map<String, dynamic> toMap() {
    return {
      'guest': GuestModel.fromEntity(guest).toJson(),
      'status': status,
    };
   }

  factory ActivityguestModel. fromEntity(ActivityGuest guest) {
    return ActivityguestModel(
      guest: guest.guest,
      status: guest.status,
    );
  }

  }