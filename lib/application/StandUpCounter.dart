import 'dart:async';

import 'package:stand_up_assist/widgets/GoalAccomplishedAlert.dart';
import 'package:stand_up_assist/widgets/states/HomePageState.dart';

import '../widgets/NudgerAlert.dart';

class StandUpCounter {
  late HomePageState _homePageState;

  int _acc_y_baseline = 0;
  final double ALPHA = 0.125;
  final double STAND_UP_THRESHOLD = 0.8;
  int _total_stand_ups = 0;
  bool _stand_up_this_hour = false;

  DateTime currentDate = DateTime.now();

  void setState(HomePageState state) {
    this._homePageState = state;
  }

  void handleUpdate(int acc_x, int acc_y, int acc_z) {
    _updateAccYBaseline(acc_y);
    _detectStandUp(acc_y);
  }

  void _updateAccYBaseline(int _acc_y) {
    _acc_y_baseline = (_acc_y * ALPHA + _acc_y_baseline * (1 - ALPHA)) as int;
  }

  void _detectStandUp(int _acc_y) {
    if (!_stand_up_this_hour) {
      if (_acc_y - _acc_y_baseline > STAND_UP_THRESHOLD) {
        _stand_up_this_hour = true;
        _total_stand_ups++;
        _homePageState.updateStandUpHours(_total_stand_ups);
      }
    }
  }

  void initCounting() {
    _scheduleNextHour();
    _scheduleNextDay();
    _scheduleNextNudge();
  }

  void _scheduleNextHour() {
    var now = new DateTime.now();
    var nextHour = new DateTime(now.year, now.month, now.day, now.hour + 1);
    var delay = nextHour.difference(now);
    new Timer(delay, _handleNewHour);
  }

  void _scheduleNextNudge() {
    var now = new DateTime.now();
    var nextHour;
    if (now.minute < 50) {
      nextHour = new DateTime(now.year, now.month, now.day, now.hour, 50);
    } else {
      nextHour = new DateTime(now.year, now.month, now.day, now.hour + 1, 50);
    }
    var delay = nextHour.difference(now);
    new Timer(delay, _handleNewNudge);
  }

  //TODO: delete me :)
  void testIncr() {
    _total_stand_ups++;
    _homePageState.updateStandUpHours(_total_stand_ups);
    new Timer(Duration(seconds: 10), testIncr);

    if (_total_stand_ups == 2) {
      new GoalAccomplishedAlert().showAlertDialog(_homePageState.context);
      new NudgerAlert().showAlertDialog(_homePageState.context);
    }
  }

  void _scheduleNextDay() {
    var now = new DateTime.now();
    var nextHour = new DateTime(now.year, now.month, now.day + 1, now.hour);
    var delay = nextHour.difference(now);
    new Timer(delay, _handleNewDay);
  }

  void _handleNewHour() {
    _stand_up_this_hour = false;
    new Timer(Duration(hours: 1), _handleNewHour);
  }

  void _handleNewNudge() {
    if (!_stand_up_this_hour) {
      new NudgerAlert().showAlertDialog(_homePageState.context);
    }
    new Timer(Duration(hours: 1), _handleNewHour);
  }

  void _handleNewDay() {
    _total_stand_ups = 0;
    new Timer(Duration(days: 1), _handleNewDay);
  }
}
