import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:spooky_mb/core/databases/adapters/objectbox/tag_box.dart';
import 'package:spooky_mb/core/databases/models/base_db_model.dart';

part 'tag_db_model.g.dart';

@CopyWith()
@JsonSerializable()
class TagDbModel extends BaseDbModel {
  static final TagBox db = TagBox();

  final int id;
  final int index;
  final int version;
  final String title;
  final bool? starred;
  final String? emoji;
  final DateTime createdAt;
  final DateTime updatedAt;

  TagDbModel({
    required this.id,
    required this.version,
    required this.title,
    required this.starred,
    required this.emoji,
    required this.createdAt,
    required this.updatedAt,
    int? index,
  }) : index = index ?? 0;

  TagDbModel.fromIDTitle(this.id, this.title)
      : version = 0,
        starred = null,
        emoji = null,
        index = 0,
        createdAt = DateTime.now(),
        updatedAt = DateTime.now();

  factory TagDbModel.fromNow() {
    return TagDbModel(
      id: 0,
      version: 0,
      title: 'Favorite',
      starred: true,
      emoji: null,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }
  @override
  Map<String, dynamic> toJson() => _$TagDbModelToJson(this);
  factory TagDbModel.fromJson(Map<String, dynamic> json) {
    if (!json.containsKey('index')) json['index'] = 0;
    return _$TagDbModelFromJson(json);
  }
}
