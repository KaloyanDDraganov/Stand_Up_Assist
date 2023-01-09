import 'dart:typed_data';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:stand_up_assist/application/StandUpCounter.dart';

import '../widgets/states/HomePageState.dart';

class BluetoothHandler {
  late HomePageState _pageState;
  late StandUpCounter _standUpCounter;

  int _accX = 0;
  int _accY = 0;
  int _accZ = 0;

  bool _isConnected = false;

  bool earConnectFound = false;

  void setState(HomePageState state) {
    _pageState = state;
  }

  void setStandUpCounter(StandUpCounter standUpCounter) {
    _standUpCounter = standUpCounter;
  }

  void updateAccelerometer(rawData) {
    Int8List bytes = Int8List.fromList(rawData);

    // description based on placing the earable into your right ear canal
    _accX = bytes[14];
    _accY = bytes[16];
    _accZ = bytes[18];

    _standUpCounter.handleUpdate(_accX, _accY, _accZ);
  }

  int twosComplimentOfNegativeMantissa(int mantissa) {
    if ((4194304 & mantissa) != 0) {
      return (((mantissa ^ -1) & 16777215) + 1) * -1;
    }

    return mantissa;
  }

  void connect() {
    FlutterBlue flutterBlue = FlutterBlue.instance;

    // start scanning
    flutterBlue.startScan(timeout: Duration(seconds: 4));

    // listen to scan results
    var subscription;
    subscription = flutterBlue.scanResults.listen((results) async {
      // do something with scan results
      for (ScanResult r in results) {
        if (r.device.name == "earconnect" && !earConnectFound) {
          earConnectFound =
              true; // avoid multiple connects attempts to same device

          await flutterBlue.stopScan();

          r.device.state.listen((state) async {
            // listen for connection state changes
            var isConnectedNew = state == BluetoothDeviceState.connected;
            if (_isConnected != isConnectedNew) {
              _pageState.updateConnectionStatus(isConnectedNew);
              if (state == BluetoothDeviceState.disconnected ||
                  state == BluetoothDeviceState.disconnecting) {
                await r.device.disconnect();
                subscription.cancel();
                earConnectFound = false;
                return;
              }
            }
            _isConnected = isConnectedNew;
          });

          await r.device.connect();

          var services = await r.device.discoverServices();

          for (var service in services) {
            // iterate over services
            for (var characteristic in service.characteristics) {
              // iterate over characterstics
              switch (characteristic.uuid.toString()) {
                case "0000a001-1212-efde-1523-785feabcd123":
                  print("Starting sampling ...");
                  await characteristic.write([
                    0x32,
                    0x31,
                    0x39,
                    0x32,
                    0x37,
                    0x34,
                    0x31,
                    0x30,
                    0x35,
                    0x39,
                    0x35,
                    0x35,
                    0x30,
                    0x32,
                    0x34,
                    0x35
                  ]);
                  await Future.delayed(const Duration(
                      seconds:
                          2)); // short delay before next bluetooth operation otherwise BLE crashes
                  characteristic.value
                      .listen((rawData) => {updateAccelerometer(rawData)});
                  await characteristic.setNotifyValue(true);
                  await Future.delayed(const Duration(seconds: 2));
                  break;
              }
            }
          }
        }
      }
    });
  }
}
