import 'dart:async';
import 'dart:math';

import 'package:stand_up_assist/widgets/states/HomePageState.dart';
import '../widgets/NudgerAlert.dart';

enum SleepPosition {
  LEFT, RIGHT, BACK, BELLY
}

class SleepAnalyzer {
  late HomePageState _homePageState;

  static const ANGLE_RANGE = 5;
  int _leftAngle = -1;
  SleepPosition _curPosition = SleepPosition.LEFT;
  var active = false;

  SleepAnalyzer(HomePageState state) {
    _homePageState = state;
  }

  void start() {
    _curPosition = SleepPosition.LEFT;
    active = true;
  }

  void reset() {
    active = false;
    _homePageState.resetSleepPositionCounters();
  }

  Map<SleepPosition, int> _positionToAngleMap() {
    return {SleepPosition.LEFT: _leftAngle, SleepPosition.RIGHT: -_leftAngle, SleepPosition.BACK: 0, SleepPosition.BELLY: -60};
  }

  void handleUpdate(int angle) {
    _leftAngle = angle;
    if (!active) {
      return;
    }

    var positionMap = _positionToAngleMap();
    // Restrict the angle to a valid value by selecting the one it is closest to
    var fixedAngle = positionMap.values.reduce((a, b) => (a - angle).abs() <= (b - angle).abs() ? a : b);
    var newPosition = positionMap.keys.firstWhere((position) => positionMap[position] == fixedAngle);

    if (newPosition != _curPosition) {
      _homePageState.incrementSleepPositionCounter(newPosition);
      _curPosition = newPosition;
    }
  }
}
