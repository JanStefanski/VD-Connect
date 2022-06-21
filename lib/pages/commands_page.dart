import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:vd_app/providers/config_provider.dart';
import 'package:vd_app/providers/websocket_provider.dart';

class CommandsPage extends StatefulWidget {
  const CommandsPage({Key? key}) : super(key: key);

  @override
  State<CommandsPage> createState() => _CommandsPageState();
}

class _CommandsPageState extends State<CommandsPage> {
  var ledColour = 'off';
  var basicColours = <String>['red', 'green', 'blue'];

  @override
  Widget build(BuildContext context) {
    var configProvider = context.watch<ConfigProvider>();
    var websocketProvider = context.watch<WebSocketProvider>();
    if (websocketProvider.isConnected) {
      websocketProvider.closeSilent();
      websocketProvider.connectSilent(
          'ws://${configProvider.config['targetAddress']}:${configProvider.config['targetPort']}');
    return ListView(
        children: <Widget>[
          ListTile(
            title: Text(AppLocalizations.of(context)!.rgb_led_switch),
            trailing: Switch(
              value: configProvider.config['rgb_led_switch'],
              onChanged: (value) {
                if (value) {
                  websocketProvider.send('turn_on_led');
                } else {
                  websocketProvider.send('turn_off_led');
                }
                configProvider.setConfig('rgb_led_switch', value);
              },
            ),
          ),
          ListTile(
            title: Text(AppLocalizations.of(context)!.rgb_led_color),
            trailing: DropdownButton<String>(
              value: configProvider.config['rgb_led_color'],
              items: basicColours.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value == 'red' ? AppLocalizations.of(context)!.red : value == 'green'
                      ? AppLocalizations.of(context)!.green
                      : AppLocalizations.of(context)!.blue),
                );
              }).toList(),
              onChanged: (String? newValue) {
                Map<String, dynamic> colourData = {};
                for (var colour in basicColours) {
                  colourData[colour] = colour == newValue ? 1 : 0;
                }
                configProvider.setConfig('rgb_led_color', newValue);
                websocketProvider.send('set_led_color_${jsonEncode(colourData)}');
              },
            ),
          ),
        ]);
    } else {
      return Center(
        child: Text(AppLocalizations.of(context)!.commands_page_description),
      );
    }
  }
}