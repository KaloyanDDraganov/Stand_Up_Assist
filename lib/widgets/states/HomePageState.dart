import 'package:flutter/cupertino.dart';
import '../HomePage.dart';
import '../GoalAccomplishedAlert.dart';
import '../ConnectedAlert.dart';
import '../DisconnectedAlert.dart';
import '../../application/BluetoothHandler.dart';
import '../../application/StandUpCounter.dart';

class HomePageState extends State<HomePage> {
  final _bleHandler = BluetoothHandler();
  var _bleConnectionStatus = "Disconnected";
  final _standUpCounter = StandUpCounter();
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
    _bleHandler.setStandUpCounter(_standUpCounter);
    _standUpCounter.setState(this);
    _standUpCounter.initCounting();
    init = true;
  }

  @override
  Widget build(BuildContext context) {
    if (!init) {
      _initialize();
    }
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: Text(widget.title),
          trailing: CupertinoButton(
            onPressed: _bleHandler.connect,
            child: const Icon(CupertinoIcons.bluetooth),
          ),
        ),
        child: Padding(
          padding:
              const EdgeInsets.only(left: 40, right: 40, top: 60, bottom: 60),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                    flex: 3,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                                flex: 6,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 20.0),
                                        child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text('Achieved'.toUpperCase(),
                                                  style: const TextStyle(
                                                      fontSize: 12.0,
                                                      color: CupertinoColors
                                                          .systemGrey))
                                            ])),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          '$_standUpHours',
                                          style: const TextStyle(
                                              height: 1, fontSize: 48.0),
                                        ),
                                        const Text(
                                          'hrs',
                                          style: TextStyle(
                                              height: 2, fontSize: 24.0),
                                        )
                                      ],
                                    )
                                  ],
                                )),
                            const Expanded(
                                flex: 2,
                                child: Center(
                                  child: Text(
                                    '/',
                                    style: TextStyle(
                                        fontSize: 96.0,
                                        color: CupertinoColors.systemGrey),
                                  ),
                                )),
                            Expanded(
                              flex: 6,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 20.0),
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text('Goal'.toUpperCase(),
                                                style: const TextStyle(
                                                    fontSize: 12.0,
                                                    color: CupertinoColors
                                                        .systemGrey))
                                          ])),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        '$_goalStandUpHours',
                                        style: const TextStyle(
                                            height: 1, fontSize: 48.0),
                                      ),
                                      const Text(
                                        'hrs',
                                        style: TextStyle(
                                            height: 2, fontSize: 24.0),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                                padding: EdgeInsets.only(top: 20, bottom: 20),
                                child: Text(
                                    '$_completion % complete'.toUpperCase(),
                                    style: const TextStyle(
                                        fontSize: 12.0,
                                        color: CupertinoColors.systemGrey)))
                          ],
                        ),
                      ],
                    )),
                Expanded(
                    flex: 4, child: Image.asset('assets/images/standing.png')),
                Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Earables: ',
                              style: TextStyle(
                                  height: 1,
                                  fontSize: 12.0,
                                  color: CupertinoColors.systemGrey)),
                          Text(_bleConnectionStatus.toUpperCase(),
                              style: const TextStyle(
                                  height: 1,
                                  fontSize: 12.0,
                                  color: CupertinoColors.systemGrey))
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
