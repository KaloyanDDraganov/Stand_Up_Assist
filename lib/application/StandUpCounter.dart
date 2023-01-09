import 'dart:async';

import 'package:stand_up_assist/widgets/states/HomePageState.dart';
import '../widgets/NudgerAlert.dart';

class StandUpCounter {
  late HomePageState _homePageState;

  var _accYBaseline = 0;
  final ALPHA = 0.125;
  final STAND_UP_THRESHOLD = 33;
  var _totalStandUps = 0;
  var _goalStandUps = 12;
  var _stoodThisHour = false;

  DateTime currentDate = DateTime.now();

  void setState(HomePageState state) {
    _homePageState = state;
  }

  void handleUpdate(int accX, int accY, int accZ) {
    _detectStandUp(accY);
    _updateAccYBaseline(accY);
  }

  void _updateAccYBaseline(int accY) {
    _accYBaseline = (accY * ALPHA + _accYBaseline * (1 - ALPHA)) as int;
  }

  void _detectStandUp(int accY) {
    if (!_stoodThisHour) {
      if ((accY - _accYBaseline).abs() > STAND_UP_THRESHOLD) {
        _stoodThisHour = true;
        _totalStandUps++;
        _homePageState.updateStandUpHours(_totalStandUps);
      }
    }
  }

  void initCounting() {
    _scheduleNextHour();
    _scheduleNextDay();
    _scheduleNextNudge();
  }

  void _scheduleNextHour() {
    var now = DateTime.now();
    var nextHour = DateTime(now.year, now.month, now.day, now.hour + 1);
    var delay = nextHour.difference(now);
    Timer(delay, _handleNewHour);
  }

  void _scheduleNextNudge() {
    var now = DateTime.now();
    DateTime nextHour;
    if (now.minute < 50) {
      nextHour = DateTime(now.year, now.month, now.day, now.hour, 50);
    } else {
      nextHour = DateTime(now.year, now.month, now.day, now.hour + 1, 50);
    }
    var delay = nextHour.difference(now);
    Timer(delay, _handleNewNudge);
  }

  void _scheduleNextDay() {
    var now = DateTime.now();
    var nextHour = DateTime(now.year, now.month, now.day + 1, now.hour);
    var delay = nextHour.difference(now);
    Timer(delay, _handleNewDay);
  }

  void _handleNewHour() {
    _stoodThisHour = false;
    Timer(const Duration(hours: 1), _handleNewHour);
  }

  void _handleNewNudge() {
    if (!_stoodThisHour && _totalStandUps < _goalStandUps) {
      NudgerAlert().showAlertDialog(_homePageState.context);
    } else if (_totalStandUps < _goalStandUps) {
      Timer(const Duration(hours: 1), _handleNewNudge);
    }
  }

  void _handleNewDay() {
    _totalStandUps = 0;
    _stoodThisHour = false;
    Timer(const Duration(days: 1), _handleNewDay);
  }
}
