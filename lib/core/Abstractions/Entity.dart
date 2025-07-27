import 'package:flutter/foundation.dart';

import 'IEntity.dart';

abstract class Entity<T> implements IEntity<T> {
  @override
  T? id;
  @override
  DateTime? createdAt;
  @override
  String? createdBy;
  @override
  DateTime? lastModified;
  @override
  String? lastModifiedBy;

  Entity({
    this.id,
    this.createdAt,
    this.createdBy,
    this.lastModified,
    this.lastModifiedBy,
  });
}
