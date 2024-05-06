import '../../domain/entities/Guest.dart';

class GuestModel extends Guest{
  GuestModel({required super.id, required super.name, required super.email, required super.phone, required super.isConfirmed});

  factory GuestModel.fromJson(Map<String, dynamic> json){
    return GuestModel(
      id: json['_id']??json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      isConfirmed: json['isConfirmed']
    );
  }
  //tojson
  Map<String, dynamic> toJson(){
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'isConfirmed': isConfirmed
    };
  }
factory GuestModel.fromEntity(Guest guest){
  return GuestModel(
    id: guest.id,
    name: guest.name,
    email: guest.email,
    phone: guest.phone,
    isConfirmed: guest.isConfirmed
  );}

}