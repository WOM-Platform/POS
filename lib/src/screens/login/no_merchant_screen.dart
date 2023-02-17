import 'package:flutter/material.dart';
import 'package:pos/localization/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

class NoMerchantScreen extends StatelessWidget {
  const NoMerchantScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final url = 'https://wom.social/user/home';
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                  'assets/logo_wom.png',
                  fit: BoxFit.fitWidth,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                AppLocalizations.of(context)?.translate('noMerchant') ?? '-',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              Text(AppLocalizations.of(context)?.translate('createYourMerchant') ?? '-',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  textAlign: TextAlign.center),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () async {
                  if (await canLaunch(url)) {
                    launch(url);
                  }
                },
                child: Text('https://wom.social',
                    style: TextStyle(
                        decoration: TextDecoration.underline,
                        fontSize: 18,
                        fontWeight: FontWeight.w600),
                    textAlign: TextAlign.center),
              ),
              const SizedBox(height: 16),
              Text(AppLocalizations.of(context)?.translate('backHereAndLogin') ?? '-',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  textAlign: TextAlign.center),
              const Spacer(),
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(AppLocalizations.of(context)?.translate('backToLogin') ?? '-')),
            ],
          ),
        ),
      ),
    );
  }
}
