import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:vd_app/providers/bluetooth_provider.dart';

class BluetoothListPage extends StatefulWidget {
  const BluetoothListPage({Key? key}) : super(key: key);

  @override
  State<BluetoothListPage> createState() => _BluetoothListPageState();
}

class _BluetoothListPageState extends State<BluetoothListPage> {

  static const String _title = 'Bluetooth List';

  @override
  Widget build(BuildContext context) {
    var bluetoothProvider = context.watch<BluetoothProvider>();
    bluetoothProvider.addListener(() {
      debugPrint('bluetoothProvider changed');
      setState(() {});
    });
    return Scaffold(
      appBar: AppBar(
        title: Text('$_title ${bluetoothProvider.devices.length.toString()}'),
      ),
      body: ListView.builder(
        itemCount: bluetoothProvider.devices.length,
        itemBuilder: (context, index) {
          final BluetoothDevice device = bluetoothProvider.devices[index];
          return ListTile(
            title: Text(device.name != '' ? device.name : 'Unknown device'),
            trailing: Text(device.id.toString()),
            onTap: () {
              bluetoothProvider.connectToDevice(device);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          bluetoothProvider.scanAndRetrieve();
        },
        child: const Icon(Icons.search),
      ),
    );
  }
}