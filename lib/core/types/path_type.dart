import 'package:easy_localization/easy_localization.dart';

enum PathType {
  docs,
  bins,
  archives;

  String get localized {
    switch (this) {
      case docs:
        return tr("general.path_type.docs");
      case bins:
        return tr("general.path_type.bins");
      case archives:
        return tr("general.path_type.archives");
    }
  }

  static PathType? fromString(String name) {
    return values.where((e) => e.name == name).firstOrNull;
  }
}
