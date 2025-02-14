// ignore_for_file: non_constant_identifier_names, depend_on_referenced_packages

import 'dart:ui';
import 'package:intl/intl.dart';

class DateFormatService {
  static String E(DateTime date, Locale locale) {
    return DateFormat.E(locale.toLanguageTag()).format(date);
  }

  static String MMM(DateTime date, Locale locale) {
    return DateFormat.MMM(locale.toLanguageTag()).format(date);
  }

  static String yMEd_jm(DateTime date, Locale locale) {
    return DateFormat.yMEd(locale.toLanguageTag())
        .addPattern("- ${DateFormat.jm(locale.toLanguageTag()).pattern!}")
        .format(date);
  }

  static String? yMEd_jmNullable(DateTime? date, Locale locale) {
    if (date == null) return null;
    return DateFormat.yMEd(locale.toLanguageTag())
        .addPattern("- ${DateFormat.jm(locale.toLanguageTag()).pattern!}")
        .format(date);
  }

  static String? yMEdNullable(DateTime? date, Locale locale) {
    if (date == null) return null;
    return DateFormat.yMEd(locale.toLanguageTag()).format(date);
  }

  static String yMEd(DateTime date, Locale locale) {
    return DateFormat.yMEd(locale.toLanguageTag()).format(date);
  }

  static String jms(DateTime date, Locale locale) {
    return DateFormat.jms(locale.toLanguageTag()).format(date);
  }

  static String yMd(DateTime date, Locale locale) {
    return DateFormat.yMd(locale.toLanguageTag()).format(date);
  }

  static String yM(DateTime date, Locale locale) {
    return DateFormat.yM(locale.toLanguageTag()).format(date);
  }
}
