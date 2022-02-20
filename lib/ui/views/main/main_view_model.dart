import 'package:flutter/material.dart';
import 'package:spooky/app.dart';
import 'package:spooky/core/security/security_service.dart';
import 'package:spooky/core/storages/local_storages/security/lock_life_circle_duration_storage.dart';
import 'package:spooky/utils/constants/app_constant.dart';
import 'package:spooky/utils/mixins/schedule_mixin.dart';
import 'package:stacked/stacked.dart';

class MainViewModel extends BaseViewModel with ScheduleMixin, WidgetsBindingObserver {
  late final ValueNotifier<bool> shouldShowBottomNavNotifier;
  late final ValueNotifier<bool> shouldScrollToTopNotifier;
  late final ValueNotifier<double?> bottomNavigationHeight;

  final SecurityService service = SecurityService();

  Map<int, ScrollController> scrollControllers = {};
  ScrollController? get currentScrollController {
    if (scrollControllers.containsKey(activeIndex)) {
      return scrollControllers[activeIndex];
    }
    return null;
  }

  void setScrollController({
    required int index,
    required ScrollController controller,
  }) {
    scrollControllers[index] = controller;
  }

  MainViewModel() {
    shouldShowBottomNavNotifier = ValueNotifier(true);
    shouldScrollToTopNotifier = ValueNotifier(false);
    bottomNavigationHeight = ValueNotifier(null);
    DateTime date = DateTime.now();
    year = date.year;
    month = date.month;
    day = date.day;
    WidgetsBinding.instance?.addObserver(this);
  }

  @override
  void dispose() {
    shouldShowBottomNavNotifier.dispose();
    shouldScrollToTopNotifier.dispose();
    bottomNavigationHeight.dispose();
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }

  int activeIndex = 0;
  void setActiveIndex(int index) {
    activeIndex = index;
    notifyListeners();
  }

  void Function()? storyListReloader;

  late int year;
  late int month;
  late int day;

  DateTime get date {
    final now = DateTime.now();
    return DateTime(
      year,
      month,
      day,
      now.hour,
      now.minute,
      now.second,
      now.millisecond,
      now.microsecond,
    );
  }

  void onTabChange(int month) {
    this.month = month;
  }

  void setShouldScrollToTop(bool value) {
    shouldScrollToTopNotifier.value = value;
  }

  void setShouldShowBottomNav(bool value) {
    shouldShowBottomNavNotifier.value = value;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        cancelTimer(ValueKey("SecurityService"));
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
        LockLifeCircleDurationStorage().read().then((e) {
          scheduleAction(
            () => service.showLockIfHas(App.navigatorKey.currentContext),
            key: ValueKey("SecurityService"),
            duration: Duration(seconds: e ?? AppConstant.lockLifeDefaultCircleDuration.inSeconds),
          );
        });
        break;
    }
  }
}
