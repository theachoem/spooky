// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'asset_db_model.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$AssetDbModelCWProxy {
  AssetDbModel id(int id);

  AssetDbModel originalSource(String originalSource);

  AssetDbModel cloudDestinations(
      Map<String, Map<String, Map<String, String>>> cloudDestinations);

  AssetDbModel createdAt(DateTime createdAt);

  AssetDbModel updatedAt(DateTime updatedAt);

  AssetDbModel lastSavedDeviceId(String? lastSavedDeviceId);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AssetDbModel(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AssetDbModel(...).copyWith(id: 12, name: "My name")
  /// ````
  AssetDbModel call({
    int id,
    String originalSource,
    Map<String, Map<String, Map<String, String>>> cloudDestinations,
    DateTime createdAt,
    DateTime updatedAt,
    String? lastSavedDeviceId,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfAssetDbModel.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfAssetDbModel.copyWith.fieldName(...)`
class _$AssetDbModelCWProxyImpl implements _$AssetDbModelCWProxy {
  const _$AssetDbModelCWProxyImpl(this._value);

  final AssetDbModel _value;

  @override
  AssetDbModel id(int id) => this(id: id);

  @override
  AssetDbModel originalSource(String originalSource) =>
      this(originalSource: originalSource);

  @override
  AssetDbModel cloudDestinations(
          Map<String, Map<String, Map<String, String>>> cloudDestinations) =>
      this(cloudDestinations: cloudDestinations);

  @override
  AssetDbModel createdAt(DateTime createdAt) => this(createdAt: createdAt);

  @override
  AssetDbModel updatedAt(DateTime updatedAt) => this(updatedAt: updatedAt);

  @override
  AssetDbModel lastSavedDeviceId(String? lastSavedDeviceId) =>
      this(lastSavedDeviceId: lastSavedDeviceId);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AssetDbModel(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AssetDbModel(...).copyWith(id: 12, name: "My name")
  /// ````
  AssetDbModel call({
    Object? id = const $CopyWithPlaceholder(),
    Object? originalSource = const $CopyWithPlaceholder(),
    Object? cloudDestinations = const $CopyWithPlaceholder(),
    Object? createdAt = const $CopyWithPlaceholder(),
    Object? updatedAt = const $CopyWithPlaceholder(),
    Object? lastSavedDeviceId = const $CopyWithPlaceholder(),
  }) {
    return AssetDbModel(
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as int,
      originalSource: originalSource == const $CopyWithPlaceholder()
          ? _value.originalSource
          // ignore: cast_nullable_to_non_nullable
          : originalSource as String,
      cloudDestinations: cloudDestinations == const $CopyWithPlaceholder()
          ? _value.cloudDestinations
          // ignore: cast_nullable_to_non_nullable
          : cloudDestinations as Map<String, Map<String, Map<String, String>>>,
      createdAt: createdAt == const $CopyWithPlaceholder()
          ? _value.createdAt
          // ignore: cast_nullable_to_non_nullable
          : createdAt as DateTime,
      updatedAt: updatedAt == const $CopyWithPlaceholder()
          ? _value.updatedAt
          // ignore: cast_nullable_to_non_nullable
          : updatedAt as DateTime,
      lastSavedDeviceId: lastSavedDeviceId == const $CopyWithPlaceholder()
          ? _value.lastSavedDeviceId
          // ignore: cast_nullable_to_non_nullable
          : lastSavedDeviceId as String?,
    );
  }
}

extension $AssetDbModelCopyWith on AssetDbModel {
  /// Returns a callable class that can be used as follows: `instanceOfAssetDbModel.copyWith(...)` or like so:`instanceOfAssetDbModel.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$AssetDbModelCWProxy get copyWith => _$AssetDbModelCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AssetDbModel _$AssetDbModelFromJson(Map<String, dynamic> json) => AssetDbModel(
      id: (json['id'] as num).toInt(),
      originalSource: json['original_source'] as String,
      cloudDestinations:
          (json['cloud_destinations'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(
            k,
            (e as Map<String, dynamic>).map(
              (k, e) => MapEntry(k, Map<String, String>.from(e as Map)),
            )),
      ),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      lastSavedDeviceId: json['last_saved_device_id'] as String?,
    );

Map<String, dynamic> _$AssetDbModelToJson(AssetDbModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'original_source': instance.originalSource,
      'cloud_destinations': instance.cloudDestinations,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
      'last_saved_device_id': instance.lastSavedDeviceId,
    };
