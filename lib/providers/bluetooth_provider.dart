import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

class BluetoothProvider extends ChangeNotifier {
  FlutterBlue flutterBlue = FlutterBlue.instance;
  List<BluetoothDevice> _devices = [];
  List<BluetoothDevice> get devices => _devices.toList();
  late BluetoothDevice _device;
  Map <String, dynamic> deviceInfo = {};
  bool get isConnected => false;


  void scanAndRetrieve() {
    flutterBlue.isAvailable.then((isAvailable) {
      if (isAvailable) {
        flutterBlue.isOn.then(((isOn) {
          if (isOn) {
            flutterBlue.startScan(timeout: const Duration(seconds: 15));
            flutterBlue.scanResults.listen((scanResult) async {
              for (ScanResult r in scanResult) {
                if (!(_devices.map((d) => d.id).contains(r.device.id))) {
                  _devices.add(r.device);
                }
                debugPrint('Device: ${r.device.toString()}');
              }
              // debugPrint(scanResult.toString());
              notifyListeners();
            });
          } else {
            debugPrint('Bluetooth is off');
          }
        }));
      } else {
        debugPrint('Bluetooth not available');
      }
    });
  }

  Future<void> connectToDevice(BluetoothDevice device) async {
    _device = device;
    await _device.connect().then((_) async {
      debugPrint('Connected to device');
      List<BluetoothService> services = await _device.discoverServices();
      for (var service in services) {
        debugPrint('Service: ${service.uuid.toString()}');
        for (var characteristic in service.characteristics) {
          debugPrint('Characteristic: ${characteristic.uuid.toString()}');
        }
      }
      notifyListeners();
    });
    notifyListeners();
  }

  void cancelScan() {
    flutterBlue.stopScan().then((value) => debugPrint('Scanning stopped'));
    notifyListeners();
  }

  void debugSimulate() {

    notifyListeners();
  }

}