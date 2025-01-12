import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spooky/core/base/base_view_model.dart';
import 'package:spooky/core/objects/backup_object.dart';
import 'package:spooky/core/objects/cloud_file_object.dart';
import 'package:spooky/core/services/messenger_service.dart';
import 'package:spooky/providers/backup_provider.dart';
import 'package:spooky/views/backup/local_widgets/backup_content_viewer.dart';
import 'package:spooky/widgets/sp_nested_navigation.dart';
import 'backup_view.dart';

class BackupViewModel extends BaseViewModel {
  final BackupRoute params;

  BackupViewModel({
    required this.params,
    required BuildContext context,
  }) {
    load(context);
  }

  bool loading = true;

  Map<String, BackupObject> loadedBackups = {};
  List<CloudFileObject>? files;

  bool get hasData => files?.isNotEmpty == true;

  Future<void> load(BuildContext context) async {
    loading = true;
    files = await context.read<BackupProvider>().source.fetchAllCloudFiles().then((e) => e?.files);
    if (context.mounted) deleteOldBackupsSilently(context);

    loading = false;
    notifyListeners();
  }

  void deleteOldBackupsSilently(BuildContext context) {
    Set<String> toRemoveBackupsIds = {};

    Map<String, List<CloudFileObject>> backupsGroupByDevice = SplayTreeMap();
    for (CloudFileObject file in files ?? []) {
      backupsGroupByDevice[file.getFileInfo()?.device.id ?? 'N/A'] ??= [];
      backupsGroupByDevice[file.getFileInfo()?.device.id ?? 'N/A']?.add(file);
      backupsGroupByDevice[file.getFileInfo()?.device.id ?? 'N/A']
          ?.sort((a, b) => a.getFileInfo()!.createdAt.compareTo(b.getFileInfo()!.createdAt));
    }

    for (final entry in backupsGroupByDevice.entries) {
      if (entry.value.length > 1) {
        // delete old backup & keep last 1
        toRemoveBackupsIds = entry.value.take(entry.value.length - 1).map((e) => e.id).toSet();
        files?.removeWhere((e) => toRemoveBackupsIds.contains(e.id));
      }
    }

    for (String id in toRemoveBackupsIds) {
      context.read<BackupProvider>().queueDeleteBackupByCloudFileId(id);
    }
  }

  Future<void> openCloudFile(
    BuildContext context,
    CloudFileObject cloudFile,
  ) async {
    BackupObject? backup = loadedBackups[cloudFile.id] ??
        await MessengerService.of(context).showLoading(
          future: () => context.read<BackupProvider>().source.getBackup(cloudFile),
          debugSource: '$runtimeType#openBackup',
        );

    if (backup != null && context.mounted) {
      loadedBackups[cloudFile.id] = backup;
      SpNestedNavigation.maybeOf(context)?.push(BackupContentViewer(backup: backup));
    }
  }

  Future<void> deleteCloudFile(BuildContext context, CloudFileObject file) async {
    await MessengerService.of(context).showLoading(
      debugSource: 'BackupViewModel#delete',
      future: () async {
        await context.read<BackupProvider>().deleteCloudFile(file.id);
        files?.removeWhere((e) => e.id == file.id);
        notifyListeners();
      },
    );
  }

  Future<void> signOut(BuildContext context) async {
    await context.read<BackupProvider>().signOut();

    if (!context.mounted) return;
    if (context.read<BackupProvider>().source.isSignedIn == true) return;

    Navigator.maybePop(context);
  }
}
