import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:pos/src/create_new_pos/application/create_pos_notifier.dart';
import 'package:pos/src/signup/data/custom_form_field.dart';
import 'package:pos/src/signup/ui/screens/create_merchant.dart';
import 'package:dart_wom_connector/dart_wom_connector.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:pos/src/exceptions.dart';
import 'package:pos/src/screens/root/root.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class CreatePOSScreen extends HookConsumerWidget {
  static const String path = 'newPOS';
  final String merchantId;

  const CreatePOSScreen({Key? key, required this.merchantId}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(createPOSNotifierProvider(merchantId), (previous, next) {
      if (next is CreatePOSStateError) {
        Alert(
          context: context,
          type: AlertType.error,
          desc: next.error is ServerException
              ? (next.error as ServerException).errorDescription
              : null,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('somethings_wrong'.tr()),
            ],
          ),
          buttons: [
            DialogButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ).show();
      } else if (next is CreatePOSStateComplete) {
        Alert(
            context: context,
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 50,
                ),
                Text('creation_complete'.tr())
              ],
            ),
            buttons: [
              DialogButton(
                child: Text('back_to_home'.tr()),
                onPressed: () {
                  Navigator.of(context).pop();
                  context.go(RootScreen.path);
                },
              ),
            ]).show();
      }
    });
    final isLoading = ref.watch(createPOSNotifierProvider(merchantId)
        .select((value) => value is CreatePOSStateLoading));

    return Scaffold(
      appBar: AppBar(
        title: Text('create_pos_title'.tr()),
      ),
      body: LoadingOverlay(
        isLoading: isLoading,
        child: CustomFormWidget(
          buttonText: "Salva",
          onSubmit: (answers) async {
            FocusScope.of(context).requestFocus(new FocusNode());
            await ref
                .read(createPOSNotifierProvider(merchantId).notifier)
                .createPOS(
                  name: answers['name']!,
                  city: answers['city']!,
                  country: answers['country']!,
                  googleMapsPlaceId: answers['placeId'],
                  streetName: answers['streetName'],
                  streetNumber: answers['streetNumber'],
                  formattedAddress: answers['formattedAddress'] as String,
                  lat: double.tryParse(answers['lat'] ?? '0.0') ?? 0.0,
                  long: double.tryParse(answers['long'] ?? '0.0') ?? 0.0,
                  description: answers['description'] != null
                      ? answers['description']!.isEmpty
                          ? null
                          : answers['description']
                      : null,
                  url: answers['url'] != null
                      ? answers['url']!.isEmpty
                          ? null
                          : 'https://${answers['url']}'
                      : null,
                );
          },
          forms: [
            FormData(
              field: CustomFormField.name,
              keyboardType: TextInputType.name,
              hintText: 'pos_name'.tr(),
              labelText: 'pos_name'.tr(),
              minLength: 8,
            ),
            FormData(
              type: FormType.searchAddress,
              field: CustomFormField.address,
              keyboardType: TextInputType.streetAddress,
              // customKey: 'google_address',
              hintText: 'merchant_address'.tr(),
              labelText: 'merchant_address'.tr(),
            ),
            FormData(
              field: CustomFormField.zip,
              hintText: 'merchant_zip_code'.tr(),
              labelText: 'merchant_zip_code'.tr(),
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              keyboardType: TextInputType.number,
            ),
            FormData(
              field: CustomFormField.city,
              hintText: 'merchant_city'.tr(),
              labelText: 'merchant_city'.tr(),
            ),
            FormData(
              field: CustomFormField.country,
              hintText: 'merchant_country'.tr(),
              labelText: 'merchant_country'.tr(),
            ),
            FormData(
              field: CustomFormField.custom,
              customKey: 'description',
              hintText: 'merchant_description'.tr(),
              labelText: 'merchant_description'.tr(),
              maxLines: 3,
              mandatory: false,
            ),
            FormData(
              field: CustomFormField.url,
              keyboardType: TextInputType.url,
              prefix: 'https://',
              hintText: 'miomerchant.it',
              labelText: 'merchant_url'.tr(),
              validators: [
                UrlValidator(errorText: 'invalid_url_warning'.tr()),
              ],
              mandatory: false,
            ),
          ],
        ),
      ),
    );
  }
}
