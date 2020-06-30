import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:pos/localization/app_localizations.dart';
import 'package:pos/src/screens/intro/intro.dart';

import '../../../app.dart';
import '../../utils.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text(
          AppLocalizations.of(context).translate('settings_title'),
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        brightness: Brightness.dark,
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.account_circle),
            title: Text('${user.name} ${user.surname}'),
            subtitle: Text(user.email),
            contentPadding: EdgeInsets.only(left: 16.0, right: 24.0),
          ),
          ListTile(
            title: Text('La piattaforma WOM'),
            subtitle: Text('Visita il sito'),
            leading: Icon(Icons.public),
            contentPadding: EdgeInsets.only(left: 16.0, right: 24.0),
            onTap: () => launchUrl('https://wom.social'),
          ),
          ListTile(
            title: Text('Tutorial'),
            subtitle: Text('Visita il tutorial iniziale'),
            leading: Icon(Icons.info),
            contentPadding: EdgeInsets.only(left: 16.0, right: 24.0),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => IntroScreen(
                        fromSettings: true,
                      )),
            ),
          ),
          VersionInfo(),
          /*if (Config.appFlavor == Flavor.DEVELOPMENT) ...[
            ListTile(
              title: Text('Visita WOM DB'),
              trailing: Icon(Icons.data_usage),
              contentPadding: EdgeInsets.only(left: 16.0, right: 24.0),
              onTap: () async {
                final woms = await WomDB.get().getWoms(womStatus: null);
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) =>
                        WomDbTablePage(woms: woms)));
              },
            ),
          ],*/
        ],
      ),
    );
  }
}

class SettingsItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  const SettingsItem(
      {Key key,
      @required this.title,
      @required this.subtitle,
      this.icon,
      this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
//    TextStyle whiteText = const TextStyle(color: Colors.white);

    return ListTile(
      onTap: onTap,
      title: Text(
        title,
        style: TextStyle(fontSize: 18.0, color: Theme.of(context).primaryColor),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(fontSize: 12.0, color: Colors.grey),
      ),
      trailing: Icon(
        icon,
        color: Theme.of(context).primaryColor,
      ),
    );
  }
}

class VersionInfo extends StatelessWidget {
  const VersionInfo({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PackageInfo>(
      future: PackageInfo.fromPlatform(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final pkg = snapshot.data;
          return ListTile(
            title: Text('Versione dell\'app'),
            subtitle: Text(pkg.version),
            leading: Icon(Icons.perm_device_information),
            contentPadding: EdgeInsets.only(left: 16.0, right: 24.0),
            onTap: null,
          );
        }
        return Container();
      },
    );
  }
}
