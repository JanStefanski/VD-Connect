import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vd_app/providers/config_provider.dart';
import 'package:vd_app/routes/bluetooth_list.dart';
import 'package:vd_app/providers/websocket_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  Widget build(BuildContext context) {
    var configProvider = context.watch<ConfigProvider>();
    var websocketProvider = context.watch<WebSocketProvider>();
    // var BluetoothProvider = context.watch<BluetoothProvider>();
    if (websocketProvider.isConnected) {
      websocketProvider.closeSilent();
      websocketProvider.connectSilent(
          'ws://${configProvider.config['targetAddress']}:${configProvider.config['targetPort']}');
      return Center(
          child: ListView(
        children: <Widget>[
          StreamBuilder(
              stream: websocketProvider.stream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data.toString().startsWith('[device_info]')) {
                    var parsedData = snapshot.data.toString().split(']');
                    var parsed = jsonDecode(parsedData[1]);
                    return Column(children: <Widget>[
                      Card(
                          child: Column(children: <Widget>[
                        Container(
                            width: double.infinity,
                            margin: const EdgeInsets.all(20),
                            child: Center(
                                child: Text(
                              '${parsed['cpu_temperature']}°C',
                              style: Theme.of(context).textTheme.headline1!,
                            ))),
                        Container(
                            width: double.infinity,
                            margin: const EdgeInsets.only(bottom: 40),
                            child: Center(
                                child: Text(
                              AppLocalizations.of(context)!.cpu_temperature,
                              style: Theme.of(context).textTheme.headline6!,
                            ))),
                      ])),
                      Card(
                          child: Column(children: <Widget>[
                        Container(
                            width: double.infinity,
                            margin: const EdgeInsets.all(20),
                            child: Center(
                                child: Text(
                              '${parsed['cpu_usage']}%',
                              style: Theme.of(context).textTheme.headline1!,
                            ))),
                        Container(
                            width: double.infinity,
                            margin: const EdgeInsets.only(bottom: 40),
                            child: Center(
                                child: Text(
                              AppLocalizations.of(context)!.cpu_usage,
                              style: Theme.of(context).textTheme.headline6!,
                            ))),
                      ])),
                      Card(
                          child: Column(children: <Widget>[
                        Container(
                            width: double.infinity,
                            margin: const EdgeInsets.all(20),
                            child: Center(
                                child: Text(
                              '${parsed['memory_usage']}%',
                              style: Theme.of(context).textTheme.headline1!,
                            ))),
                        Container(
                            width: double.infinity,
                            margin: const EdgeInsets.only(bottom: 40),
                            child: Center(
                                child: Text(
                              AppLocalizations.of(context)!.ram_usage,
                              style: Theme.of(context).textTheme.headline6!,
                            ))),
                      ])),
                      Card(
                          child: Column(children: <Widget>[
                        Container(
                            width: double.infinity,
                            margin: const EdgeInsets.all(20),
                            child: Center(
                                child: Text(
                              '${parsed['disk_usage']}%',
                              style: Theme.of(context).textTheme.headline1!,
                            ))),
                        Container(
                            width: double.infinity,
                            margin: const EdgeInsets.only(bottom: 40),
                            child: Center(
                                child: Text(
                              AppLocalizations.of(context)!.disk_usage,
                              style: Theme.of(context).textTheme.headline6!,
                            ))),
                      ])),
                      Card(
                          child: Column(children: <Widget>[
                        Container(
                            width: double.infinity,
                            margin: const EdgeInsets.all(20),
                            child: Center(
                                child: Text(
                              '${parsed['network_usage']}',
                              style: Theme.of(context).textTheme.headline4!,
                            ))),
                        Container(
                            width: double.infinity,
                            margin: const EdgeInsets.only(bottom: 10),
                            child: Center(
                                child: Text(
                              AppLocalizations.of(context)!.network_usage,
                              style: Theme.of(context).textTheme.headline6!,
                            ))),
                        Container(
                            width: double.infinity,
                            margin: const EdgeInsets.only(bottom: 20),
                            child: Center(
                                child: Text(
                              AppLocalizations.of(context)!
                                  .network_usage_description,
                              style: Theme.of(context).textTheme.subtitle1!,
                            ))),
                      ])),
                    ]);
                  } else {
                    websocketProvider.send('stream_device_info');
                    return Padding(
                        padding: const EdgeInsets.fromLTRB(0, 100, 0, 20),
                        child: Column(
                          children: [
                            const CircularProgressIndicator(),
                            const SizedBox(height: 20),
                            Text(AppLocalizations.of(context)!.retrieving_data),
                          ],
                        ));
                  }
                } else {
                  return Padding(
                      padding: const EdgeInsets.fromLTRB(0, 100, 0, 20),
                      child: Column(
                        children: [
                          const CircularProgressIndicator(),
                          const SizedBox(height: 20),
                          Text(AppLocalizations.of(context)!.connecting),
                        ],
                      ));
                }
              }),
          Center(
            child: MaterialButton(
              onPressed: () {
                websocketProvider.close();
              },
              color: Colors.red,
              textColor: Colors.white,
              child: Text(AppLocalizations.of(context)!.disconnect),
            ),
          ),
        ],
      ));
    } else {
      return Center(
        child: MaterialButton(
          onPressed: () {
            if (configProvider.config['connectionType'] == 'Wifi') {
              websocketProvider.connect(
                  'ws://${configProvider.config['targetAddress']}:${configProvider.config['targetPort']}');
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const BluetoothListPage(),
                ),
              );
            }
          },
          color: Colors.blue,
          textColor: Colors.white,
          child: Text(AppLocalizations.of(context)!.connect),
        ),
      );
    }
  }
}
