import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vd_app/providers/config_provider.dart';
import 'package:vd_app/providers/websocket_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  List<String> connTypes = ['Wifi', 'Bluetooth'];
  String connType = "Wifi";
  String targetAddress = "";
  String targetPort = "";

  void setTargetAddress(String address) {
    setState(() {
      targetAddress = address;
    });
  }

  void setTargetPort(String port) {
    setState(() {
      targetPort = port;
    });
  }

  void setConnectionType(String type) {
    setState(() {
      connType = type;
    });
  }

  @override
  Widget build(BuildContext context) {
    var configProvider = context.watch<ConfigProvider>();
    var websocketProvider = context.watch<WebSocketProvider>();
    return ListView(children: <Widget>[
      ListTile(
          shape:
              Border(bottom: BorderSide(color: Theme.of(context).dividerColor)),
          leading: Icon(configProvider.config['connectionType'] == 'Wifi'
              ? Icons.wifi
              : Icons.bluetooth),
          title: Text(AppLocalizations.of(context)!.connection_type),
          trailing: Text(configProvider.config['connectionType']),
          onTap: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return SimpleDialog(
                  title: Text(AppLocalizations.of(context)!.connection_type),
                  children: connTypes.map((String type) {
                    return SimpleDialogOption(
                      onPressed: () {
                        Navigator.pop(context);
                        setConnectionType(type);
                        configProvider.setConfig("connectionType", type);
                      },
                      child: Text(type),
                    );
                  }).toList(),
                );
              },
            );
          }),
      ListTile(
        shape:
            Border(bottom: BorderSide(color: Theme.of(context).dividerColor)),
        leading: const Icon(Icons.phonelink),
        title: Text(AppLocalizations.of(context)!.target_device_address),
        subtitle: configProvider.config['targetAddress'] != ""
            ? Text(configProvider.config['targetAddress'])
            : null,
        onTap: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text(AppLocalizations.of(context)!.target_device_address),
              content: TextField(
                keyboardType: TextInputType.number,
                onChanged: (String address) {
                  setTargetAddress(address);
                },
              ),
              actions: <Widget>[
                MaterialButton(
                  child: Text(AppLocalizations.of(context)!.cancel),
                  onPressed: () {
                    setTargetAddress(configProvider.config['targetAddress']);
                    Navigator.of(context).pop();
                  },
                ),
                MaterialButton(
                  child: Text(AppLocalizations.of(context)!.ok),
                  onPressed: () {
                    configProvider.setConfig("targetAddress", targetAddress);
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        },
      ),
      ListTile(
        shape: Border(bottom: BorderSide(color: Theme.of(context).dividerColor)),
        leading: const Icon(Icons.wifi),
        title: Text(AppLocalizations.of(context)!.target_device_port),
        subtitle: configProvider.config['targetPort'] != "" ? Text(configProvider.config['targetPort']) : null,
        enabled: configProvider.config['connectionType'] == 'Wifi',
        onTap: () {
          if (configProvider.config['connectionType'] == 'Wifi') {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text(AppLocalizations.of(context)!.target_device_port),
                content: TextField(
                  keyboardType: TextInputType.number,
                  onChanged: (String port) {
                    setTargetPort(port);
                  },
                ),
                actions: <Widget>[
                  MaterialButton(
                    child: Text(AppLocalizations.of(context)!.cancel),
                    onPressed: () {
                      setTargetPort(configProvider.config['targetPort']);
                      Navigator.of(context).pop();
                    },
                  ),
                  MaterialButton(
                    child: Text(AppLocalizations.of(context)!.ok),
                    onPressed: () {
                      configProvider.setConfig("targetPort", targetPort);
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            );
          }
        },
      ),
      ListTile(
        shape:
            Border(bottom: BorderSide(color: Theme.of(context).dividerColor)),
        leading: const Icon(Icons.language),
        title: Text(AppLocalizations.of(context)!.language),
        trailing: Text(configProvider.config['languages']
            [configProvider.config['language']]),
        onTap: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return SimpleDialog(
                title: Text(AppLocalizations.of(context)!.language),
                children: <Widget>[
                  SimpleDialogOption(
                    onPressed: () {
                      Navigator.pop(context);
                      configProvider.setConfig("language", "en");
                    },
                    child: Text(configProvider.config['languages']['en']),
                  ),
                  SimpleDialogOption(
                    onPressed: () {
                      Navigator.pop(context);
                      configProvider.setConfig("language", "pl");
                    },
                    child: Text(configProvider.config['languages']['pl']),
                  ),
                  SimpleDialogOption(
                    onPressed: () {
                      Navigator.pop(context);
                      configProvider.setConfig("language", "zh");
                    },
                    child: Text(configProvider.config['languages']['zh']),
                  ),
                ],
              );
            },
          );
        },
      ),
      ListTile(
          shape:
              Border(bottom: BorderSide(color: Theme.of(context).dividerColor)),
          leading: const Icon(Icons.settings_brightness),
          title: Text(AppLocalizations.of(context)!.theme),
          onTap: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return SimpleDialog(
                  title: Text(AppLocalizations.of(context)!.select_theme),
                  children: <Widget>[
                    SimpleDialogOption(
                      onPressed: () {
                        Navigator.pop(context);
                        configProvider.setConfig("theme", ThemeMode.light);
                      },
                      child: Text(AppLocalizations.of(context)!.theme_light),
                    ),
                    SimpleDialogOption(
                      onPressed: () {
                        Navigator.pop(context);
                        configProvider.setConfig("theme", ThemeMode.dark);
                      },
                      child: Text(AppLocalizations.of(context)!.theme_dark),
                    ),
                  ],
                );
              },
            );
          }),
      ListTile(
        title: Text(AppLocalizations.of(context)!.about),
        onTap: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text(AppLocalizations.of(context)!.about),
              content: Text(AppLocalizations.of(context)!.about_text),
              actions: <Widget>[
                MaterialButton(
                  child: Text(AppLocalizations.of(context)!.ok),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        },
      ),
    ]);
  }
}
