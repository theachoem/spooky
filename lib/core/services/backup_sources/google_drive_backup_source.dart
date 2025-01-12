import 'dart:io';
import 'package:spooky/core/objects/cloud_file_list_object.dart';
import 'package:spooky/core/objects/cloud_file_object.dart';
import 'package:spooky/core/services/backup_sources/base_backup_source.dart';
import 'package:spooky/core/services/google_drive/google_drive_service.dart';

class GoogleDriveBackupSource extends BaseBackupSource {
  @override
  String get cloudId => "google_drive";

  final GoogleDriveService _service = GoogleDriveService();

  @override
  String? get email => _service.googleSignIn.currentUser?.email;

  @override
  String? get displayName => _service.googleSignIn.currentUser?.displayName;

  @override
  String? get smallImageUrl => _service.googleSignIn.currentUser?.photoUrl;

  @override
  String? get bigImageUrl => _maximizeImage(_service.googleSignIn.currentUser?.photoUrl);

  String? _maximizeImage(String? imageUrl) {
    if (imageUrl == null) return null;
    String lowQuality = "s96-c";
    String highQuality = "s0";
    return imageUrl.replaceAll(lowQuality, highQuality);
  }

  @override
  Future<bool> checkIsSignedIn() => _service.googleSignIn.isSignedIn();

  Future<bool> _recheckIsSignedIn() async {
    isSignedIn = await checkIsSignedIn();
    return isSignedIn!;
  }

  @override
  Future<bool> reauthenticate() async {
    await _service.googleSignIn.signInSilently();
    return _recheckIsSignedIn();
  }

  @override
  Future<bool> signIn() async {
    await _service.googleSignIn.signIn();
    return _recheckIsSignedIn();
  }

  @override
  Future<bool> signOut() async {
    await _service.googleSignIn.signOut();
    return _recheckIsSignedIn().then((isSignedIn) => !isSignedIn);
  }

  @override
  Future<CloudFileListObject?> fetchAllCloudFiles({
    String? nextToken,
  }) {
    return _service.fetchAll(null);
  }

  @override
  Future<bool> uploadFile(String fileName, File file) async {
    CloudFileObject? result = await _service.uploadFile(fileName, file);
    return result != null;
  }

  @override
  Future<CloudFileObject?> getLastestBackupFile() {
    return _service.fetchLatestFile();
  }

  @override
  Future<CloudFileObject?> getFileByFileName(String fileName) {
    return _service.findFileByName(fileName);
  }

  @override
  Future<String?> getFileContent(CloudFileObject cloudFile) {
    return _service.getFileContent(cloudFile);
  }

  @override
  Future<void> deleteCloudFile(String id) {
    return _service.delete(id);
  }
}
