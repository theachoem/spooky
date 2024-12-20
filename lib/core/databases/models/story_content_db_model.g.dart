// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'story_content_db_model.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$StoryContentDbModelCWProxy {
  StoryContentDbModel id(int id);

  StoryContentDbModel title(String? title);

  StoryContentDbModel plainText(String? plainText);

  StoryContentDbModel createdAt(DateTime createdAt);

  StoryContentDbModel pages(List<List<dynamic>>? pages);

  StoryContentDbModel metadata(String? metadata);

  StoryContentDbModel draft(bool? draft);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `StoryContentDbModel(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// StoryContentDbModel(...).copyWith(id: 12, name: "My name")
  /// ````
  StoryContentDbModel call({
    int id,
    String? title,
    String? plainText,
    DateTime createdAt,
    List<List<dynamic>>? pages,
    String? metadata,
    bool? draft,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfStoryContentDbModel.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfStoryContentDbModel.copyWith.fieldName(...)`
class _$StoryContentDbModelCWProxyImpl implements _$StoryContentDbModelCWProxy {
  const _$StoryContentDbModelCWProxyImpl(this._value);

  final StoryContentDbModel _value;

  @override
  StoryContentDbModel id(int id) => this(id: id);

  @override
  StoryContentDbModel title(String? title) => this(title: title);

  @override
  StoryContentDbModel plainText(String? plainText) =>
      this(plainText: plainText);

  @override
  StoryContentDbModel createdAt(DateTime createdAt) =>
      this(createdAt: createdAt);

  @override
  StoryContentDbModel pages(List<List<dynamic>>? pages) => this(pages: pages);

  @override
  StoryContentDbModel metadata(String? metadata) => this(metadata: metadata);

  @override
  StoryContentDbModel draft(bool? draft) => this(draft: draft);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `StoryContentDbModel(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// StoryContentDbModel(...).copyWith(id: 12, name: "My name")
  /// ````
  StoryContentDbModel call({
    Object? id = const $CopyWithPlaceholder(),
    Object? title = const $CopyWithPlaceholder(),
    Object? plainText = const $CopyWithPlaceholder(),
    Object? createdAt = const $CopyWithPlaceholder(),
    Object? pages = const $CopyWithPlaceholder(),
    Object? metadata = const $CopyWithPlaceholder(),
    Object? draft = const $CopyWithPlaceholder(),
  }) {
    return StoryContentDbModel(
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as int,
      title: title == const $CopyWithPlaceholder()
          ? _value.title
          // ignore: cast_nullable_to_non_nullable
          : title as String?,
      plainText: plainText == const $CopyWithPlaceholder()
          ? _value.plainText
          // ignore: cast_nullable_to_non_nullable
          : plainText as String?,
      createdAt: createdAt == const $CopyWithPlaceholder()
          ? _value.createdAt
          // ignore: cast_nullable_to_non_nullable
          : createdAt as DateTime,
      pages: pages == const $CopyWithPlaceholder()
          ? _value.pages
          // ignore: cast_nullable_to_non_nullable
          : pages as List<List<dynamic>>?,
      metadata: metadata == const $CopyWithPlaceholder()
          ? _value.metadata
          // ignore: cast_nullable_to_non_nullable
          : metadata as String?,
      draft: draft == const $CopyWithPlaceholder()
          ? _value.draft
          // ignore: cast_nullable_to_non_nullable
          : draft as bool?,
    );
  }
}

extension $StoryContentDbModelCopyWith on StoryContentDbModel {
  /// Returns a callable class that can be used as follows: `instanceOfStoryContentDbModel.copyWith(...)` or like so:`instanceOfStoryContentDbModel.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$StoryContentDbModelCWProxy get copyWith =>
      _$StoryContentDbModelCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StoryContentDbModel _$StoryContentDbModelFromJson(Map<String, dynamic> json) =>
    StoryContentDbModel(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String?,
      plainText: json['plain_text'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      pages: (json['pages'] as List<dynamic>?)
          ?.map((e) => e as List<dynamic>)
          .toList(),
      metadata: json['metadata'] as String?,
      draft: json['draft'] as bool?,
    );

Map<String, dynamic> _$StoryContentDbModelToJson(
        StoryContentDbModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'plain_text': instance.plainText,
      'created_at': instance.createdAt.toIso8601String(),
      'draft': instance.draft,
      'metadata': instance.metadata,
      'pages': instance.pages,
    };
