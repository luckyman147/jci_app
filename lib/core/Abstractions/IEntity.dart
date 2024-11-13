import 'package:equatable/equatable.dart';

abstract class IEntity<T> extends BaseEntity {
  T? get id;
  set id(T? value);
}

abstract class BaseEntity extends Equatable {
  DateTime? createdAt;
  String? createdBy;
  DateTime? lastModified;
  String? lastModifiedBy;
}
