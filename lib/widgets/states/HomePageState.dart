// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../HomePage.dart';
import '../GoalAccomplishedAlert.dart';
import '../ConnectedAlert.dart';
import '../DisconnectedAlert.dart';
import '../../application/BluetoothHandler.dart';
import '../../application/SleepAnalyzer.dart';

class HomePageState extends State<HomePage> {
  final _bleHandler = BluetoothHandler();
  var _bleConnectionStatus = "Disconnected";
  final _sleepAnalyzer = SleepAnalyzer();
  var init = false;

  var _standUpHours = 0;
  final _goalStandUpHours = 12;
  var _completion = 0;

  void updateConnectionStatus(bool isConnected) {
    setState(() {
      _bleConnectionStatus = (isConnected) ? "Connected" : "Disconnected";
    });
    if (isConnected) {
      ConnectedAlert().showAlertDialog(context);
    } else {
      DisconnectedAlert().showAlertDialog(context);
    }
  }

  void updateStandUpHours(int hours) {
    setState(() {
      _standUpHours = hours;
      _completion = ((_standUpHours / _goalStandUpHours) * 100).round();

      if (_standUpHours == _goalStandUpHours) {
        GoalAccomplishedAlert().showAlertDialog(context);
      }
    });
  }

  void _initialize() {
    _bleHandler.setState(this);
    _bleHandler.setSleepAnalyzer(_sleepAnalyzer);
    _sleepAnalyzer.setState(this);
    init = true;
  }

  @override
  Widget build(BuildContext context) {
    if (!init) {
      _initialize();
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('FloatingActionButton Sample'),
      ),
      body: Center(child: Column(children: [
        // Start button
        ElevatedButton(
          onPressed: () {
          // Perform some action
          },
          // textColor: Colors.white,
          // color: Colors.blue,
          child: Text("Start"),
        ),
        Column(
          children: [
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                      Text('Left side: 0'),
                      Text('Back: 0'),
                      Text('Right side: 0'),
                  ],
              ),
              Text('Belly: 0'),
          ],
        ),
        ]
      )),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Perform some action
        },
        icon: Icon(Icons.bluetooth),
        label: const Text("Test")
      )
    );
  }
}
