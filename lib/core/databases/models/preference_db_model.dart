import 'package:json_annotation/json_annotation.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:spooky/core/databases/adapters/objectbox/preference_box.dart';
import 'package:spooky/core/databases/models/base_db_model.dart';

part 'preference_db_model.g.dart';

@CopyWith()
@JsonSerializable()
class PreferenceDbModel extends BaseDbModel {
  static final PreferenceBox db = PreferenceBox();

  @override
  final int id;
  final String key;
  final String value;

  final DateTime createdAt;

  @override
  final DateTime updatedAt;

  PreferenceDbModel({
    required this.id,
    required this.key,
    required this.value,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PreferenceDbModel.fromJson(Map<String, dynamic> json) => _$PreferenceDbModelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$PreferenceDbModelToJson(this);
}
