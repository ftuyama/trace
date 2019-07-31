import 'package:Trace/presentation/custom_icons.dart';
import 'package:Trace/service/binance.dart';
import 'package:flutter/material.dart';
import 'package:qr_reader/qr_reader.dart';
import '../main.dart';

class AccountPlugin extends StatefulWidget {
  AccountPlugin(
      {this.savePreferences,
      this.toggleTheme,
      this.darkEnabled,
      this.themeMode,
      this.switchOLED,
      this.darkOLED});
  final Function savePreferences;
  final Function toggleTheme;
  final bool darkEnabled;
  final String themeMode;
  final Function switchOLED;
  final bool darkOLED;

  @override
  AccountPluginState createState() => new AccountPluginState();
}

class AccountPluginState extends State<AccountPlugin> {
  @override
  void initState() {
    super.initState();
  }

  void scanApi() {
    new QRCodeReader()
        .setAutoFocusIntervalInMs(200)
        .setForceAutoFocus(true)
        .setTorchEnabled(true)
        .setHandlePermissions(true)
        .setExecuteAfterPermissionGranted(true)
        .scan().then((credentials) {
      setState(() {
        binance.storeCredentials(credentials);
        loadExchangeData();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new PreferredSize(
          preferredSize: const Size.fromHeight(appBarHeight),
          child: new AppBar(
            backgroundColor: Theme.of(context).primaryColor,
            titleSpacing: 0.0,
            elevation: appBarElevation,
            title: new Text("Account plugin", style: Theme.of(context).textTheme.title),
          ),
        ),
        body: new ListView(
          children: <Widget>[
            new Container(
              padding: const EdgeInsets.all(10.0),
              child: new Text("Exchanges",
                  style: Theme.of(context).textTheme.body2),
            ),
            new Container(
                color: Theme.of(context).cardColor,
                child: new ListTile(
                  onTap: scanApi,
                  leading: new Icon(CustomIcons.binance_coin_seeklogo_com),
                  title: new Text("Binance"),
                  subtitle: new Text(binance.credentials != null ? 'Connected' : 'Tap to connect'),
                  trailing: binance.credentials != null ? new Icon(Icons.check) : new Text(''),
                )),
          ])
    );
  }
}
