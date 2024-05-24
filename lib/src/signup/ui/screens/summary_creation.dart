import 'package:dart_wom_connector/dart_wom_connector.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:pos/src/blocs/authentication/authentication_bloc.dart';
import 'package:pos/src/exceptions.dart';
import 'package:pos/src/my_logger.dart';
import 'package:pos/src/screens/root/root.dart';
import 'package:pos/src/signup/application/create_merchant.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class SummaryCreationScreen extends HookConsumerWidget {
  final String name;
  final String fiscalCode;
  final String address;
  final String primaryActivity;
  final String zipCode;
  final String city;
  final String country;
  final String googleMapsPlaceId;
  final String streetName;
  final String? streetNumber;
  final String? formattedAddress;
  final double? lat;
  final double? long;
  final String? description;
  final String? url;

  const SummaryCreationScreen({
    Key? key,
    required this.name,
    required this.fiscalCode,
    required this.address,
    required this.primaryActivity,
    required this.zipCode,
    required this.city,
    required this.country,
    required this.googleMapsPlaceId,
    required this.streetName,
    required this.streetNumber,
    required this.formattedAddress,
    required this.lat,
    required this.long,
    required this.description,
    required this.url,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = useState(false);
    final verificationCodeController = useTextEditingController();
    return LoadingOverlay(
      isLoading: isLoading.value,
      child: Scaffold(
        appBar: AppBar(
          title: Text('create_merchant.title'.tr()),
          actions: [
            IconButton(
              icon: Icon(Icons.exit_to_app),
              color: Colors.white,
              onPressed: () {
                ref.read(authNotifierProvider.notifier).logOut();
              },
            ),
          ],
        ),
        body: ListView(
          padding: EdgeInsets.all(16),
          children: [
            Text(
              'create_merchant.verify_data'.tr(),
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 16),
            SummaryInfo(
              label: 'name'.tr(),
              value: name,
            ),
            SummaryInfo(
              label: 'create_merchant.fiscal_code'.tr(),
              value: fiscalCode,
            ),
            SummaryInfo(
              label: 'create_merchant.activity'.tr(),
              value: primaryActivity,
            ),
            SummaryInfo(
              label: 'create_merchant.address'.tr(),
              value: streetName,
            ),
            SummaryInfo(
              label: 'create_merchant.street_number'.tr(),
              value: streetNumber,
            ),
            SummaryInfo(
              label: 'create_merchant.zip_code'.tr(),
              value: zipCode,
            ),
            SummaryInfo(
              label: 'create_merchant.city'.tr(),
              value: city,
            ),
            SummaryInfo(
              label: 'country'.tr(),
              value: country,
            ),
            SummaryInfo(
              label: 'create_merchant.description'.tr(),
              value: description,
            ),
            SummaryInfo(
              label: 'create_merchant.url'.tr(),
              value: url,
            ),
            const SizedBox(height: 8),
            Text('create_merchant.activation_code_desc'.tr()),
             const SizedBox(height: 8),
            TextFormField(
              controller: verificationCodeController,
              maxLines: 1,
              decoration: InputDecoration(
                labelText: 'create_merchant.activation_code'.tr(),
                hintText: 'create_merchant.activation_code'.tr(),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () async {
                try {
                  final nav = Navigator.of(context);
                  final router = GoRouter.of(context);
                  isLoading.value = true;

                  await ref
                      .read(createMerchantNotifierProvider.notifier)
                      .createMerchant(
                        name: name,
                        fiscalCode: fiscalCode,
                        address: address,
                        primaryActivity: primaryActivity,
                        zipCode: zipCode,
                        city: city,
                        country: country,
                        googleMapsPlaceId: googleMapsPlaceId,
                        streetName: streetName,
                        streetNumber: streetNumber,
                        formattedAddress: formattedAddress,
                        lat: lat,
                        long: long,
                        description: description,
                        url: url,
                        activationCode: verificationCodeController.text.trim(),
                      );

                  isLoading.value = false;
                  Alert(
                    context: context,
                    title: 'created'.tr(),
                    buttons: [
                      DialogButton(
                        child: Text('back_to_home'.tr()),
                        onPressed: () {
                          nav.pop();
                          router.go(RootScreen.path);
                        },
                      ),
                    ],
                  ).show();
                } on ServerException catch (ex) {
                  isLoading.value = false;
                  Alert(
                    context: context,
                    title: 'create_merchant.error'.tr(),
                    desc: ex.errorDescription,
                    buttons: [
                      DialogButton(
                        child: Text('Ok'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ).show();
                  logger.e(ex);
                } catch (ex, st) {
                  logger.e('createMerchant', error: ex, stackTrace: st);
                  isLoading.value = false;
                  Alert(
                    context: context,
                    title: 'create_merchant.error'.tr(),
                    buttons: [
                      DialogButton(
                        child: Text('Ok'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ).show();
                }
              },
              child: Text('create_merchant.create'.tr()),
            ),
          ],
        ),
      ),
    );
  }
}

class SummaryInfo extends StatelessWidget {
  final String label;
  final String? value;

  const SummaryInfo({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
          ),
          Text(
            value ?? '-',
            style: TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }
}
