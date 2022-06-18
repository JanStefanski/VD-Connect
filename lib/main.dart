import 'package:flutter/material.dart';
// import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:vd_app/pages_index.dart';
import 'package:vd_app/providers/bluetooth_provider.dart';
import 'package:vd_app/routes/bluetooth_list.dart';
import 'package:vd_app/providers/websocket_provider.dart';
import 'package:vd_app/providers/config_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() => runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => BluetoothProvider()),
        ChangeNotifierProvider(create: (_) => WebSocketProvider()),
        ChangeNotifierProvider(create: (_) => ConfigProvider()),
      ],
      child: VDApp(),
    ));

class VDApp extends StatefulWidget {
  const VDApp({Key? key}) : super(key: key);

  @override
  _VDAppState createState() => _VDAppState();

}

class _VDAppState extends State<VDApp> {
  static const String _title = 'VD App';
  Locale? _locale;
  ThemeMode _theme = ThemeMode.system;

  changeLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  changeTheme(ThemeMode theme) {
    setState(() {
      _theme = theme;
    });
  }

  @override
  Widget build(BuildContext context) {
    var configProvider = context.watch<ConfigProvider>();
    configProvider.addListener(() {
      changeLocale(Locale.fromSubtags(languageCode: configProvider.config['language']));
      changeTheme(configProvider.config['theme']);
    });
    return MaterialApp(
      title: _title,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: const [
        Locale('en', ''),
        Locale('pl', ''),
        Locale('zh', ''),
        Locale('zh', 'Hans'),
      ],
      locale: _locale,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: _theme,
      home: MainWidget(),
    );
  }
}




class MainWidget extends StatefulWidget {
  const MainWidget({Key? key}) : super(key: key);

  @override
  State<MainWidget> createState() => _MainWidgetState();
}

class _MainWidgetState extends State<MainWidget> {
  int _selectedIndex = 0;
  static const List<Widget> _widgetOptions = <Widget>[
    DashboardPage(),
    CommandsPage(),
    SettingsPage(),
  ];

  void _onItemTapped(int index) {
    // _widgetOptions.elementAt(_selectedIndex).dispose();
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    var configProvider = context.watch<ConfigProvider>();
    if (!configProvider.configLoaded) {
      configProvider.loadPreferences();
    }
    var websocketProvider = context.watch<WebSocketProvider>();
    return Scaffold(
      appBar: AppBar(
        title: Text('${AppLocalizations.of(context)!.appTitle}${websocketProvider.isConnected ? ' - ${AppLocalizations.of(context)!.connected}' : ''}'),
        backgroundColor: (websocketProvider.isConnected) ? Colors.green : Theme.of(context).primaryColor,
        actions: <Widget>[
          (configProvider.config['connectionType'] == 'Bluetooth' ? IconButton(
            icon: const Icon(Icons.bluetooth),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const BluetoothListPage(),
                ),
              );
            },
          ): Container()),
        ],
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: const Icon(Icons.dashboard),
            label: AppLocalizations.of(context)!.dashboard,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.terminal),
            label: AppLocalizations.of(context)!.commands,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.settings),
            label: AppLocalizations.of(context)!.settings,
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.green,
        onTap: _onItemTapped,
      ),
    );
  }
}
