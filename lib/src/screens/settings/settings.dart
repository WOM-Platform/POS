import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:package_info/package_info.dart';
import 'package:pos/localization/app_localizations.dart';
import 'package:pos/src/blocs/authentication/bloc.dart';
import 'package:pos/src/constants.dart';
import 'package:pos/src/extensions.dart';
import 'package:pos/src/model/flavor_enum.dart';
import 'package:pos/src/pos_handler/ui/screens/pos_manager.dart';
import 'package:pos/src/screens/intro/intro.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../../utils.dart';

class SettingsScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final posUser = ref.watch(posUserProvider);
    final posCount = posUser?.merchants.fold<int>(
        0, (previousValue, element) => previousValue + element.posList.length);
    // final selectedPos = ref.watch(selectedPosProvider);
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text(
          AppLocalizations.of(context)?.translate('settings_title') ?? '',
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
          if (posUser != null && !posUser.isAnonymous) ...[
            ListTile(
              leading: Icon(Icons.account_circle),
              title: Text('${posUser.name} ${posUser.surname}'),
              subtitle: Text(posUser.email),
              contentPadding: EdgeInsets.only(left: 16.0, right: 24.0),
            ),
            ListTile(
              leading: Icon(Icons.manage_accounts),
              title: Text('Hai ${posCount ?? '-'} POS'),
              subtitle: Text('Organizza e modifica i tuoi POS'),
              onTap: () {
                if (posCount == null) return;
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => POSManagerScreen(posCount),
                  ),
                );
              },
              trailing: Icon(Icons.arrow_forward_ios_sharp),
              contentPadding: EdgeInsets.only(left: 16.0, right: 24.0),
            ),
          ],
          ListTile(
            title: Text(
                AppLocalizations.of(context)?.translate('wom_platform') ?? ''),
            subtitle: Text(
                AppLocalizations.of(context)?.translate('go_to_site') ?? ''),
            leading: Icon(Icons.public),
            trailing: Icon(Icons.arrow_forward_ios_sharp),
            contentPadding: EdgeInsets.only(left: 16.0, right: 24.0),
            onTap: () => launchUrl('https://wom.social'),
          ),
          ListTile(
            title: Text('Tutorial'),
            subtitle: Text(
                AppLocalizations.of(context)?.translate('tutorial_desc') ?? ''),
            leading: Icon(Icons.info),
            contentPadding: EdgeInsets.only(left: 16.0, right: 24.0),
            trailing: Icon(Icons.arrow_forward_ios_sharp),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => IntroScreen(
                        fromSettings: true,
                      )),
            ),
          ),
          const VersionInfo(),
          Divider(),
          ListTile(
            title:
                Text(AppLocalizations.of(context)?.translate('sign_out') ?? ''),
            subtitle: Text(
                AppLocalizations.of(context)?.translate('sign_out_desc') ?? ''),
            leading: const Icon(Icons.exit_to_app),
            trailing: Icon(Icons.arrow_forward_ios_sharp),
            contentPadding: const EdgeInsets.only(left: 16.0, right: 24.0),
            onTap: () {
              _showLogoutDialog(context, () {
                ref.read(authNotifierProvider.notifier).logOut();
              });
            },
          ),
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

  void _showLogoutDialog(BuildContext context, Function logout) {
    Alert(
      context: context,
      title: AppLocalizations.of(context)?.translate('logout_message') ?? '',
      buttons: [
        DialogButton(
          child: Text('No'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        DialogButton(
          child: Text(AppLocalizations.of(context)?.translate('yes') ?? ''),
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop();
            Navigator.of(context).pop();
            logout();
          },
        ),
      ],
    ).show();
  }
}

class SettingsItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData? icon;
  final VoidCallback? onTap;

  const SettingsItem(
      {Key? key,
      required this.title,
      required this.subtitle,
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
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PackageInfo>(
      future: PackageInfo.fromPlatform(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final pkg = snapshot.data;
          return ListTile(
            title: Text(
                AppLocalizations.of(context)?.translate('version_app') ?? ''),
            subtitle: Text(
                '${flavor == Flavor.DEVELOPMENT ? 'DEV ' : ''}${pkg?.version}'),
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
