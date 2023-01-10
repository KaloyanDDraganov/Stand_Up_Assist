// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../HomePage.dart';
import '../../application/BluetoothHandler.dart';
import '../../application/SleepAnalyzer.dart';

class HomePageState extends State<HomePage> {
  var _bleIsConnected = false;
  late SleepAnalyzer _sleepAnalyzer;
  late BluetoothHandler _bleHandler;

  HomePageState() {
    _sleepAnalyzer = SleepAnalyzer(this);
    _bleHandler = BluetoothHandler(this, _sleepAnalyzer);
  }

  var _leftSideCount = 0;
  var _rightSideCount = 0;
  var _backCount = 0;
  var _bellyCount = 0;

  void updateConnectionStatus(bool isConnected) {
    setState(() {
      _bleIsConnected = isConnected;
    });
  }

  void incrementSleepPositionCounter(SleepPosition position) {
    setState(() {
      switch (position) {
        case SleepPosition.LEFT:
          _leftSideCount++;
          break;
        case SleepPosition.RIGHT:
          _rightSideCount++;
          break;
        case SleepPosition.BACK:
          _backCount++;
          break;
        case SleepPosition.BELLY:
          _bellyCount++;
          break;
      }
    });
  }

  void resetSleepPositionCounters() {
    setState(() {
      _leftSideCount = 0;
      _rightSideCount = 0;
      _backCount = 0;
      _bellyCount = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    var cancelButton = TextButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    var confirmStartActionBtn = TextButton(
      child: Text("Continue"),
      onPressed: () {
        Navigator.of(context).pop();
        _sleepAnalyzer.start();
      },
    );

    var confirmResetActionBtn = TextButton(
      child: Text("Confirm"),
      onPressed: () {
        Navigator.of(context).pop();
        _sleepAnalyzer.reset();
      },
    );

    var startButton = ElevatedButton(
      onPressed: (!_sleepAnalyzer.active && !_bleIsConnected) ? null : () {
        if (_sleepAnalyzer.active) {
          showDialog(
              context: context,
              builder: (_) => AlertDialog(
                title: Text('Reset the sleep analyzer'),
                content: Text(
                    'Are you sure you wish to reset the analyzer? This will clear all collected data.'),
                actions: [cancelButton, confirmResetActionBtn],
              ));
        } else {
          showDialog(
              context: context,
              builder: (_) => AlertDialog(
                title: Text('Start analyzing sleep'),
                content: Text(
                    'Make sure to lie on your left side with the earables connected, then press "Continue".'),
                actions: [cancelButton, confirmStartActionBtn],
              ));
        }
      },
      child: Text(_sleepAnalyzer.active ? "Reset" : "Start"),
    );

    return Scaffold(
        appBar: AppBar(
          title: const Text('FloatingActionButton Sample'),
        ),
        body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("Status: ${_bleIsConnected ? "Connected" : "Disconnected"}"),
              startButton,
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text('Left side: $_leftSideCount'),
                      Text('Back: $_backCount'),
                      Text('Right side: $_rightSideCount'),
                    ],
                  ),
                  Text('Belly: $_bellyCount'),
                ],
              ),
            ]),
        floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              _bleHandler.connect();
            },
            icon: Icon(Icons.bluetooth),
            label: const Text("Connect")));
  }
}
