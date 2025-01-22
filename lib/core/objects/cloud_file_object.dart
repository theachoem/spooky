import 'package:googleapis/drive/v3.dart' as drive;
import 'package:spooky/core/objects/backup_file_object.dart';
import 'package:spooky/core/objects/device_info_object.dart';

class CloudFileObject {
  final String? fileName;
  final String id;
  final String? description;

  CloudFileObject({
    required this.fileName,
    required this.id,
    required this.description,
  });

  factory CloudFileObject.fromGoogleDrive(drive.File file) {
    return CloudFileObject(
      fileName: file.name,
      id: file.id!,
      description: file.description,
    );
  }

  factory CloudFileObject.fromLegacyStoryPad(drive.File file) {
    return CloudFileObject(
      fileName: file.name,
      id: file.id!,
      description: file.description,
    );
  }

  // story2025-01-20 21:31:05.234761.zip
  BackupFileObject? getFileInfo() {
    if (fileName == null) return null;

    if (fileName?.startsWith("story") == true) {
      String createdAtStr = fileName!.replaceAll("story", "").replaceAll(".zip", "");
      DateTime? createdAt = DateTime.tryParse(createdAtStr);

      return BackupFileObject(
        createdAt: createdAt!,
        device: DeviceInfoObject('StoryPad', 'legacy-model-id'),
      );
    } else {
      return BackupFileObject.fromFileName(fileName!);
    }
  }
}
