import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:storypad/core/services/app_store_opener_service.dart';
import 'package:storypad/core/types/in_app_update_status.dart';
import 'package:storypad/widgets/packages/new_version_plus.dart';

class InAppUpdateProvider extends ChangeNotifier {
  InAppUpdateProvider() {
    _load();
  }

  InAppUpdateStatus? get displayStatus => _displayStatus;
  InAppUpdateStatus? _displayStatus;

  void setDisplayStatus(InAppUpdateStatus? value) {
    _displayStatus = value;
    notifyListeners();
  }

  VersionStatus? _versionStatus;
  AppUpdateInfo? _androidInAppUpdateInfo;

  Future<void> _load() async {
    _versionStatus = await NewVersionPlus().getVersionStatus();
    _androidInAppUpdateInfo = await _getAndroidInAppUpdateInfo();

    debugPrint("💫 App Update Status: ${_versionStatus?.canUpdate} ${_versionStatus?.originalStoreVersion}");

    if (_versionStatus?.canUpdate == true || _androidInAppUpdateInfo?.canUpdate == true) {
      setDisplayStatus(InAppUpdateStatus.updateAvailable);
      if (Platform.isAndroid && _androidInAppUpdateInfo != null) _listenToInAppUpdateStatus();
    }
  }

  Future<void> update() async {
    bool supportInAppUpdate = _androidInAppUpdateInfo != null;

    if (supportInAppUpdate) {
      await _updateDireclyInApp();
    } else {
      await _openApplicationStore();
    }
  }

  Future<void> _openApplicationStore() async {
    await AppStoreOpenerService.call();
  }

  Future<void> _updateDireclyInApp() async {
    _androidInAppUpdateInfo = await _getAndroidInAppUpdateInfo();

    switch (_androidInAppUpdateInfo!.installStatus) {
      case InstallStatus.pending:
      case InstallStatus.downloading:
      case InstallStatus.installing:
      case InstallStatus.installed:
        break;
      case InstallStatus.unknown:
      case InstallStatus.failed:
      case InstallStatus.canceled:
        if (_androidInAppUpdateInfo!.flexibleUpdateAllowed) {
          InAppUpdate.startFlexibleUpdate().catchError((e) => AppUpdateResult.inAppUpdateFailed);
        } else if (_androidInAppUpdateInfo!.immediateUpdateAllowed) {
          InAppUpdate.performImmediateUpdate().catchError((e) => AppUpdateResult.inAppUpdateFailed);
        }
        break;
      case InstallStatus.downloaded:
        InAppUpdate.completeFlexibleUpdate();
        break;
    }
  }

  void _listenToInAppUpdateStatus() {
    InAppUpdate.installUpdateListener.listen((status) {
      switch (status) {
        case InstallStatus.unknown:
        case InstallStatus.installed:
          setDisplayStatus(null);
          break;
        case InstallStatus.pending:
        case InstallStatus.downloading:
        case InstallStatus.installing:
          setDisplayStatus(InAppUpdateStatus.downloading);
        case InstallStatus.failed:
        case InstallStatus.canceled:
          setDisplayStatus(InAppUpdateStatus.updateAvailable);
          break;
        case InstallStatus.downloaded:
          setDisplayStatus(InAppUpdateStatus.installAvailable);
          break;
      }
    });
  }

  Future<AppUpdateInfo?> _getAndroidInAppUpdateInfo() async {
    Future<AppUpdateInfo?> call() async {
      if (!Platform.isAndroid) return null;
      return InAppUpdate.checkForUpdate();
    }

    return call().catchError((error) {
      debugPrint("🪲 $error");
      return null;
    });
  }
}

extension on AppUpdateInfo {
  bool get canUpdate => updateAvailability == UpdateAvailability.updateAvailable;
}
