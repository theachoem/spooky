// ignore_for_file: overridden_fields

import 'package:objectbox/objectbox.dart';

abstract class BaseObjectBox<T> {
  void toPermanentlyDeleted();

  DateTime? permanentlyDeletedAt;
}

@Entity()
class StoryObjectBox extends BaseObjectBox {
  @Id(assignable: true)
  int id;
  int version;
  String type;

  int year;
  int month;
  int day;
  int? hour;
  int? minute;
  int? second;

  bool? starred;
  String? feeling;

  @Property(type: PropertyType.date)
  DateTime createdAt;

  @Property(type: PropertyType.date)
  DateTime updatedAt;

  @Property(type: PropertyType.date)
  DateTime? movedToBinAt;

  @override
  @Property(type: PropertyType.date)
  DateTime? permanentlyDeletedAt;

  List<String> changes;
  List<String>? tags;

  // for query
  String? metadata;

  StoryObjectBox({
    required this.id,
    required this.version,
    required this.type,
    required this.year,
    required this.month,
    required this.day,
    required this.hour,
    required this.minute,
    required this.second,
    required this.starred,
    required this.feeling,
    required this.createdAt,
    required this.updatedAt,
    required this.movedToBinAt,
    required this.changes,
    required this.tags,
    required this.metadata,
    this.permanentlyDeletedAt,
  });

  @override
  void toPermanentlyDeleted() {
    changes = [];
    tags = null;
    metadata = null;
    updatedAt = DateTime.now();
    permanentlyDeletedAt = DateTime.now();
  }
}

@Entity()
class TagObjectBox extends BaseObjectBox {
  @Id(assignable: true)
  int id;
  String title;

  int? index;
  int version;
  bool? starred;
  String? emoji;

  @Property(type: PropertyType.date)
  DateTime createdAt;

  @Property(type: PropertyType.date)
  DateTime updatedAt;

  @override
  @Property(type: PropertyType.date)
  DateTime? permanentlyDeletedAt;

  TagObjectBox({
    required this.id,
    required this.title,
    required this.index,
    required this.version,
    required this.starred,
    required this.emoji,
    required this.createdAt,
    required this.updatedAt,
    this.permanentlyDeletedAt,
  });

  @override
  void toPermanentlyDeleted() {
    updatedAt = DateTime.now();
    permanentlyDeletedAt = null;
  }
}

@Entity()
class PreferenceObjectBox extends BaseObjectBox {
  @Id(assignable: true)
  int id;
  String key;
  String value;

  @Property(type: PropertyType.date)
  DateTime createdAt;

  @Property(type: PropertyType.date)
  DateTime updatedAt;

  @override
  @Property(type: PropertyType.date)
  DateTime? permanentlyDeletedAt;

  PreferenceObjectBox({
    required this.id,
    required this.key,
    required this.value,
    required this.createdAt,
    required this.updatedAt,
    this.permanentlyDeletedAt,
  });

  @override
  void toPermanentlyDeleted() {
    updatedAt = DateTime.now();
    permanentlyDeletedAt = null;
  }
}
