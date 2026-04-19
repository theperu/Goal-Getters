abstract class BaseEntity {
  int? id;
  DateTime? createdAt;
  DateTime? updatedAt;

  BaseEntity({this.id, this.createdAt, this.updatedAt});
}

class BaseEntityFields {
  static const String id = 'id';
  static const String createdAt = 'createdAt';
  static const String updatedAt = 'updatedAt';
}
