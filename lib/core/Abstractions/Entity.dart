import 'IEntity.dart';

abstract class Entity<T> implements IEntity<T> {
  T? id;
  DateTime? createdAt;
  String? createdBy;
  DateTime? lastModified;
  String? lastModifiedBy;

  Entity({
    this.id,
    this.createdAt,
    this.createdBy,
    this.lastModified,
    this.lastModifiedBy,
  });
}
