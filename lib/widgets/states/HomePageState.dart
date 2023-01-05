import 'package:flutter/cupertino.dart';
import '../HomePage.dart';
import '../GoalAccomplishedAlert.dart';
import '../../application/BluetoothHandler.dart';
import '../../application/StandUpCounter.dart';

class HomePageState extends State<HomePage> {
  final BluetoothHandler _bleHandler = BluetoothHandler();
  String _bleConnectionStatus = "Disconnected";
  final StandUpCounter _standUpCounter = StandUpCounter();
  bool init = false;

  int _standUpHours = 0;
  final int _goalStandUpHours = 12;

  void updateConnectionStatus(bool isConnected) {
    setState(() {
      _bleConnectionStatus = (isConnected) ? "Connected" : "Disconnected";
    });
  }

  void updateStandUpHours(int hours) {
    setState(() {
      _standUpHours = hours;

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
    _standUpCounter.testIncr();
    init = true;
  }

  @override
  Widget build(BuildContext context) {
    if (!init) {
      _initialize();
    }
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        middle: Text(widget.title),
        trailing: CupertinoButton(
          onPressed: _bleHandler.connect,
          child: const Icon(CupertinoIcons.bluetooth),
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Expanded(
                flex: 2,
                child: Padding(
                    padding: const EdgeInsets.only(
                        left: 60, right: 60, top: 120, bottom: 60),
                    child: Row(
                      children: [
                        Expanded(
                            flex: 6,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                    padding:
                                        const EdgeInsets.only(bottom: 10.0),
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
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      '$_standUpHours',
                                      style: const TextStyle(
                                          height: 1, fontSize: 48.0),
                                    ),
                                    const Text(
                                      'hrs',
                                      style:
                                          TextStyle(height: 2, fontSize: 24.0),
                                    )
                                  ],
                                )
                              ],
                            )),
                        Expanded(
                          flex: 1,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Text(
                                    '/',
                                    style: TextStyle(
                                        height: 1,
                                        fontSize: 48.0,
                                        color: CupertinoColors.systemGrey),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 6,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                  padding: const EdgeInsets.only(bottom: 10.0),
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text('Goal'.toUpperCase(),
                                            style: const TextStyle(
                                                fontSize: 12.0,
                                                color:
                                                    CupertinoColors.systemGrey))
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
                                    style: TextStyle(height: 2, fontSize: 24.0),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    ))),
            Expanded(
                flex: 2,
                child: FractionallySizedBox(
                  widthFactor: 0.8,
                  heightFactor: 1.0,
                  child: Image.asset('assets/images/standing.png'),
                )),
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 60),
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
              ),
            )
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
