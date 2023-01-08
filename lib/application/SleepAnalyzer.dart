import 'dart:async';

import 'package:stand_up_assist/widgets/states/HomePageState.dart';
import '../widgets/NudgerAlert.dart';

class SleepAnalyzer {
  late HomePageState _homePageState;

  var _leftAngle = 0;
  final ALPHA = 0.125;
  final STAND_UP_THRESHOLD = 0.8;
  var _totalStandUps = 0;
  var _goalStandUps = 12;
  var _stoodThisHour = false;

  DateTime currentDate = DateTime.now();

  void setState(HomePageState state) {
    _homePageState = state;
  }

  void handleUpdate(int accZ) {
    // _updateAccYBaseline(accY);
    // _detectStandUp(accY);
  }

  void _detectStandUp(int accY) {
    // if (!_stoodThisHour) {
    //   if (accY - _accYBaseline > STAND_UP_THRESHOLD) {
    //     _stoodThisHour = true;
    //     _totalStandUps++;
    //     _homePageState.updateStandUpHours(_totalStandUps);
    //   }
    // }
  }
}
