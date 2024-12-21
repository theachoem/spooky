import 'package:spooky/core/extensions/string_extension.dart';

enum PathType {
  docs,
  bins,
  archives;

  String get localized {
    return name.capitalize;
  }
}
