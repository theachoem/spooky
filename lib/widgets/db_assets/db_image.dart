// ignore_for_file: depend_on_referenced_packages

import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:ui' as ui;
import 'package:storypad/core/databases/models/asset_db_model.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:http/http.dart' as http;

class DbImage extends ImageProvider<DbImage> {
  final String assetLink;
  final double scale;
  final GoogleSignInAccount? currentUser;

  static BaseCacheManager defaultCacheManager = DefaultCacheManager();

  DbImage({
    required this.assetLink,
    required this.currentUser,
    this.scale = 1,
  });

  @override
  Future<DbImage> obtainKey(ImageConfiguration configuration) {
    return SynchronousFuture<DbImage>(this);
  }

  @override
  ImageStreamCompleter loadImage(DbImage key, ImageDecoderCallback decode) {
    return MultiFrameImageStreamCompleter(
      codec: _loadAsync(key, decode: decode),
      scale: key.scale,
      debugLabel: key.assetLink,
      informationCollector: () => <DiagnosticsNode>[
        ErrorDescription('AssetLink: $assetLink'),
      ],
    );
  }

  Future<ui.Codec> _loadAsync(
    DbImage key, {
    required ImageDecoderCallback decode,
  }) async {
    assert(key == this);

    AssetDbModel? asset = await AssetDbModel.findBy(assetLink: assetLink);
    File? localFile = asset?.localFile;

    if (localFile == null && currentUser == null && asset?.getGoogleDriveForEmails()?.isNotEmpty == true) {
      throw StateError('Login with ${asset?.getGoogleDriveForEmails()?.join(" or ")} to see the image.');
    }

    if (currentUser?.email != null && asset?.getGoogleDriveIdForEmail(currentUser!.email) != null) {
      final imageUrl = asset!.getGoogleDriveUrlForEmail(currentUser!.email);
      if (imageUrl == null) throw StateError('$assetLink with $imageUrl cannot be loaded');

      final downloadedFile = File(asset.downloadFilePath);
      if (!downloadedFile.existsSync()) {
        try {
          final response = await http.get(
            Uri.parse(imageUrl),
            headers: await currentUser?.authHeaders ?? {},
          );

          final downloadedFile = File(asset.downloadFilePath);
          await downloadedFile.create(recursive: true);
          await downloadedFile.writeAsBytes(response.bodyBytes);

          localFile = downloadedFile;
        } catch (e) {
          if (e is HttpException && e.message.contains('403')) {
            throw StateError('Sign in with ${currentUser!.email} to see image.');
          }
          rethrow;
        }
      }
    }

    if (localFile != null) {
      return decode(await ui.ImmutableBuffer.fromFilePath(localFile.path));
    } else {
      throw StateError('$assetLink cannot be loaded.');
    }
  }

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is DbImage &&
        other.assetLink == assetLink &&
        currentUser?.email == other.currentUser?.email &&
        other.scale == scale;
  }

  @override
  int get hashCode => Object.hash(assetLink, scale);

  @override
  String toString() => '${objectRuntimeType(this, 'DbImage')}("$assetLink", scale: ${scale.toStringAsFixed(1)})';
}
