import 'package:dart_wom_connector/dart_wom_connector.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:package_info/package_info.dart';

import 'package:pos/src/blocs/authentication/bloc.dart';
import 'package:pos/src/constants.dart';
import 'package:pos/src/extensions.dart';
import 'package:pos/src/model/flavor_enum.dart';
import 'package:pos/src/pos_handler/ui/screens/pos_manager.dart';
import 'package:pos/src/screens/intro/intro.dart';
import 'package:pos/src/screens/root/root.dart';
import 'package:pos/src/screens/settings/change_language.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../../utils.dart';

class SettingsScreen extends ConsumerWidget {
  static const String path = 'settings';
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final posUser = ref.watch(posUserProvider);
    final posCount = posUser?.merchants.fold<int>(
        0, (previousValue, element) => previousValue + element.posList.length);
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text(
          'settings_title'.tr(),
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        // brightness: Brightness.dark,
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
      ),
      body: ListView(
        children: <Widget>[
          if (posUser != null && !posUser.isAnonymous) ...[
            ListTile(
              leading: Icon(Icons.account_circle_outlined),
              title: Text('${posUser.name} ${posUser.surname}'),
              subtitle: Text(posUser.email),
              contentPadding: EdgeInsets.only(left: 16.0, right: 24.0),
            ),
            ListTile(
              leading: Icon(Icons.manage_accounts),
              title: Text('handlePos'.tr()),
              subtitle: Text('handlePosDesc'.tr()),
              onTap: () {
                if (posCount == null) return;
                context.go('/${SettingsScreen.path}/${POSManagerScreen.path}');
              },
              trailing: Icon(Icons.arrow_forward_ios_sharp),
              contentPadding: EdgeInsets.only(left: 16.0, right: 24.0),
            ),
          ],
          ListTile(
            title: Text('wom_platform'.tr()),
            subtitle: Text('go_to_site'.tr()),
            leading: Icon(Icons.public),
            trailing: Icon(Icons.arrow_forward_ios_sharp),
            contentPadding: EdgeInsets.only(left: 16.0, right: 24.0),
            onTap: () => launchUrl('https://wom.social'),
          ),
          ListTile(
            title: Text('Tutorial'),
            subtitle: Text('tutorial_desc'.tr()),
            leading: Icon(Icons.info_outline),
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
          ListTile(
            title: Text('change_language').tr(),
            leading: Icon(Icons.language),
            contentPadding: EdgeInsets.only(left: 16.0, right: 24.0),
            trailing: Icon(Icons.arrow_forward_ios_sharp),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChangeLanguageScreen(),
              ),
            ),
          ),
          ListTile(
            title: Text('Privacy Policy'),
            subtitle: Text('read_privacy'.tr()),
            leading: Icon(Icons.privacy_tip_outlined),
            trailing: Icon(Icons.arrow_forward_ios_sharp),
            contentPadding: EdgeInsets.only(left: 16.0, right: 24.0),
            onTap: () => launchUrl('https://wom.social/privacy/pos'),
          ),
          const VersionInfo(),
          Divider(),
          ListTile(
            title: Text('sign_out'.tr()),
            subtitle: Text('sign_out_desc'.tr()),
            leading: const Icon(Icons.exit_to_app),
            trailing: Icon(Icons.arrow_forward_ios_sharp),
            contentPadding: const EdgeInsets.only(left: 16.0, right: 24.0),
            onTap: () {
              _showLogoutDialog(context, () {
                ref.read(authNotifierProvider.notifier).logOut();
              });
            },
          ),
          Divider(),
          if (posUser != null && !posUser.isAnonymous) ...[
            const SizedBox(height: 24),
            TextButton(
              onPressed: () async {
                final merchants = posUser.merchants
                    .where((element) => element.access == MerchantAccess.admin);
                final count = merchants.length;
                final res = await askChoice(
                  context,
                 'doYouWantDeleteAccount'.tr(),
                );

                if (res) {
                  await ref.read(authNotifierProvider.notifier).deleteAccount();
                  context.go(RootScreen.path);
                }
              },
              child: Text(
                'deleteAccount'.tr(),
                style: TextStyle(color: Colors.red),
              ),
            )
          ],
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
      title: 'logout_message'.tr(),
      buttons: [
        DialogButton(
          child: Text('No'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        DialogButton(
          child: Text('yes'.tr()),
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
            title: Text('version_app').tr(),
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
