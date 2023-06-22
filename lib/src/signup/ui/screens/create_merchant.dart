import 'package:dart_wom_connector/dart_wom_connector.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_codice_fiscale/codice_fiscale.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:go_router/go_router.dart';
import 'package:google_places_autocomplete_text_field/google_places_autocomplete_text_field.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:pos/src/exceptions.dart';
import 'package:pos/src/screens/root/root.dart';
import 'package:pos/src/signup/application/create_merchant.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import '../../../my_logger.dart';
import 'package:collection/collection.dart';

enum MerchantActivity {
  agricolture,
  construction,
  manifacture,
  retailCommerce,
  transport,
  lodging,
  food,
  information,
  finance,
  travel,
  education,
  health,
  sports,
  services,
  entertainment,
  organizations;

  String get text {
    switch (this) {
      case MerchantActivity.agricolture:
        return this.name;
      case MerchantActivity.construction:
        return this.name;
      case MerchantActivity.manifacture:
        return this.name;
      case MerchantActivity.retailCommerce:
        return this.name;
      case MerchantActivity.transport:
        return this.name;
      case MerchantActivity.lodging:
        return this.name;
      case MerchantActivity.food:
        return this.name;
      case MerchantActivity.information:
        return this.name;
      case MerchantActivity.finance:
        return this.name;
      case MerchantActivity.travel:
        return this.name;
      case MerchantActivity.education:
        return this.name;
      case MerchantActivity.health:
        return this.name;
      case MerchantActivity.sports:
        return this.name;
      case MerchantActivity.services:
        return this.name;
      case MerchantActivity.entertainment:
        return this.name;
      case MerchantActivity.organizations:
        return this.name;
    }
  }
}

/* Name (min length 8)
- FiscalCode (min 11, max 16)
- PrimaryActivity (vedi messaggio sotto)
- Address
- ZIP code
- City
- Country
- Description (opzionale)
- Url (opzionale)*/

class CreateMerchantScreen extends HookConsumerWidget {
  static const String path = 'createMerchant';

  const CreateMerchantScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = useState<bool>(false);
    return Scaffold(
      appBar: AppBar(
        title: Text('Crea il tuo merchant'),
      ),
      body: LoadingOverlay(
        isLoading: isLoading.value,
        child: CustomFormWidget(
          buttonText: "Salva",
          onSubmit: (answers) async {
            // answers.forEach(print);
            try {
              final nav = Navigator.of(context);
              final router = GoRouter.of(context);
              isLoading.value = true;
              await ref
                  .read(createMerchantNotifierProvider.notifier)
                  .createMerchant(
                    name: answers['name']!,
                    fiscalCode: answers['cf']!,
                    address: answers['address']!,
                    primaryActivity: answers['activity']!,
                    zipCode: answers['zip']!,
                    city: answers['city']!,
                    country: answers['country']!,
                    googleMapsPlaceId: answers['placeId'],
                    streetName: answers['streetName'],
                    streetNumber: answers['streetNumber'],
                    formattedAddress: answers['formattedAddress'],
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

              isLoading.value = false;
              Alert(
                context: context,
                title: 'merchant_created'.tr(),
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
                title: 'merchant_creation_error'.tr(),
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
              isLoading.value = false;
              Alert(
                context: context,
                title: 'merchant_creation_error'.tr(),
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
              logger.e(st);
            }
          },
          forms: [
            FormData(
              field: FormField.name,
              hintText: 'merchant_name'.tr(),
              labelText: 'merchant_name'.tr(),
              minLength: 8,
            ),
            FormData(
              field: FormField.cf,
              hintText: 'merchant_fiscal_code'.tr(),
              labelText: 'merchant_fiscal_code'.tr(),
              minLength: 11,
              maxLength: 16,
              inputFormatters: [UpperCaseTextFormatter()],
              validators: <FieldValidator>[
                CFValidator(errorText: 'invalid_fiscal_code'.tr()),
              ],
            ),
            FormData<MerchantActivity>(
              field: FormField.custom,
              customKey: 'activity',
              type: FormType.dropdown,
              items: MerchantActivity.values
                  .map((e) => DropdownData(e.name, e.text.tr()))
                  .toList(),
              hintText: 'merchant_select_activity'.tr(),
              labelText: 'merchant_select_activity'.tr(),
              validators: [],
            ),
            FormData(
              type: FormType.searchAddress,
              field: FormField.address,
              // customKey: 'google_address',
              hintText: 'merchant_address'.tr(),
              labelText: 'merchant_address'.tr(),
            ),
            // FormData(
            //   field: FormField.address,
            //   hintText: 'Indirizzo',
            //   labelText: 'Indirizzo',
            // ),
            FormData(
              field: FormField.zip,
              hintText: 'merchant_zip_code'.tr(),
              labelText: 'merchant_zip_code'.tr(),
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              keyboardType: TextInputType.number,
            ),
            FormData(
              field: FormField.city,
              hintText: 'merchant_city'.tr(),
              labelText: 'merchant_city'.tr(),
            ),
            FormData(
              field: FormField.country,
              hintText: 'merchant_country'.tr(),
              labelText: 'merchant_country'.tr(),
            ),
            FormData(
              field: FormField.custom,
              customKey: 'description',
              hintText: 'merchant_description'.tr(),
              labelText: 'merchant_description'.tr(),
              maxLines: 3,
              mandatory: false,
            ),
            FormData(
              field: FormField.url,
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

enum FormType { textField, dropdown, searchAddress }

enum FormField { name, surname, address, cf, zip, city, country, url, custom }

class DropdownData {
  final String key;
  final String value;

  DropdownData(this.key, this.value);
}

class FormData<T extends Enum> {
  final String? customKey;
  final FormField field;
  final FormType type;
  final String? hintText;
  final String? labelText;
  final bool mandatory;
  final int maxLines;
  final String? prefix;
  final int? minLength;
  final int? maxLength;
  final TextInputType keyboardType;
  final List<FieldValidator<dynamic>> validators;
  final List<DropdownData>? items;
  final List<TextInputFormatter>? inputFormatters;

  FormData({
    this.customKey,
    this.type = FormType.textField,
    this.hintText,
    this.prefix,
    this.minLength,
    this.maxLength,
    this.labelText,
    this.inputFormatters,
    this.maxLines = 1,
    required this.field,
    this.keyboardType = TextInputType.text,
    this.validators = const [],
    this.mandatory = true,
    this.items,
  });

  String get key =>
      field == FormField.custom ? customKey ?? 'custom' : field.name;
}

class CustomFormWidget extends HookConsumerWidget {
  final List<FormData> forms;
  final Function(Map<String, String?>)? onSubmit;
  final String buttonText;

  const CustomFormWidget({
    Key? key,
    required this.forms,
    this.onSubmit,
    required this.buttonText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = useMemoized(GlobalKey<FormState>.new);

    final formattedAddress = useState<String?>(null);
    final placeId = useState<String?>(null);
    final streetName = useState<String?>(null);
    final streetNumber = useState<String?>(null);
    final latitude = useState<String?>(null);
    final longitude = useState<String?>(null);

    final controllers = <String, dynamic>{};
    final focuses = <FocusNode>[];
    for (final f in forms) {
      focuses.add(useFocusNode());
      if (f.type == FormType.textField || f.type == FormType.searchAddress) {
        controllers[f.key] = useTextEditingController();
      } else if (f.type == FormType.dropdown) {
        controllers[f.key] = useState<String?>(null);
      }
    }

    return Form(
      key: formKey,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          for (int i = 0; i < forms.length; i++)
            if (forms[i].type == FormType.dropdown)
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: DropdownButtonFormField<String?>(
                  validator: forms[i].mandatory
                      ? (value) {
                          return value?.isEmpty ?? true
                              ? 'mandatory_field'.tr()
                              : null;
                        }
                      : null,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 1),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  items: forms[i]
                      .items
                      ?.map(
                        (e) => DropdownMenuItem<String>(
                          child: Text(e.value),
                          value: e.key,
                          onTap: () {
                            controllers[forms[i].key].value = e.key;
                          },
                          // enabled: controllers[forms[i].key].value == e,
                        ),
                      )
                      .toList(),
                  hint: Text(forms[i].hintText ?? ''),
                  value: controllers[forms[i].key].value?.toString(),
                  onChanged: (item) {},
                ),
              )
            else if (forms[i].type == FormType.searchAddress)
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: GooglePlacesAutoCompleteTextFormField(
                    inputDecoration: InputDecoration(
                      prefixText: forms[i].prefix,
                      labelText: forms[i].labelText,
                      hintText: forms[i].hintText,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 1),
                      ),
                    ),
                    textEditingController: controllers[forms[i].key],
                    googleAPIKey: "AIzaSyBnSeX3CiELwq6CWBXFbcmW7DeZ3BGLaag",
                    debounceTime: 400,
                    countries: ["it"],
                    isLatLngRequired: true,
                    getPlaceDetailWithLatLng: (prediction, details) {
                      final addressComponents =
                          details.result?.addressComponents ?? [];
                      final number = addressComponents
                          .firstWhereOrNull((c) =>
                              c.types?.contains('street_number') ?? false)
                          ?.longName;
                      final address = addressComponents
                          .firstWhereOrNull(
                              (c) => c.types?.contains('route') ?? false)
                          ?.longName;
                      final locality = addressComponents
                          .firstWhereOrNull(
                              (c) => c.types?.contains('locality') ?? false)
                          ?.longName;
                      final postcode = addressComponents
                          .firstWhereOrNull(
                              (c) => c.types?.contains('postal_code') ?? false)
                          ?.longName;
                      final country = addressComponents
                          .firstWhereOrNull(
                              (c) => c.types?.contains('country') ?? false)
                          ?.longName;

                      final pId = prediction.placeId;
                      final lat = prediction.lat;
                      final long = prediction.lng;
                      latitude.value = lat;
                      longitude.value = long;
                      placeId.value = pId;

                      formattedAddress.value = prediction.description;
                      streetNumber.value = number;
                      streetName.value = address;

                      // Set address
                      final fullAddress =
                          prediction.structuredFormatting?.mainText;
                      if (controllers.containsKey('google_address')) {
                        final addressController = controllers['google_address'];
                        if (addressController is TextEditingController) {
                          final currentText = addressController.text;
                          addressController.text =
                              fullAddress ?? streetName.value ?? currentText;
                        }
                      }

                      if (controllers.containsKey(FormField.address.name)) {
                        final addressController =
                            controllers[FormField.address.name];
                        if (addressController is TextEditingController) {
                          final currentText = addressController.text;
                          addressController.text =
                              fullAddress ?? streetName.value ?? currentText;
                        }
                      }

                      // Set city
                      if (controllers.containsKey(FormField.city.name)) {
                        final cityController = controllers[FormField.city.name];
                        if (cityController is TextEditingController) {
                          final currentText = cityController.text;
                          cityController.text = locality ?? currentText ?? '';
                        }
                      }

                      // Set country
                      if (controllers.containsKey(FormField.country.name)) {
                        final countryController =
                            controllers[FormField.country.name];
                        if (countryController is TextEditingController) {
                          final currentText = countryController.text;
                          countryController.text = country ?? currentText;
                        }
                      }

                      // Set CAP
                      if (controllers.containsKey(FormField.zip.name)) {
                        final capController = controllers[FormField.zip.name];
                        if (capController is TextEditingController) {
                          final currentText = capController.text;
                          capController.text = postcode ?? currentText;
                        }
                      }
                    },
                    // this callback is called when isLatLngRequired is true
                    itmClick: (prediction) {
                      controllers[forms[i].key].text = prediction.description;
                      controllers[forms[i].key].selection =
                          TextSelection.fromPosition(TextPosition(
                              offset: prediction.description!.length));
                    }),
              )
            else
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: TextFormField(
                  focusNode: focuses[i],
                  inputFormatters: forms[i].inputFormatters,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (v) {
                    if (i < forms.length - 1) {
                      focuses[i + 1].requestFocus();
                    }
                  },
                  keyboardType: forms[i].keyboardType,
                  controller: controllers[forms[i].key],
                  maxLines: forms[i].maxLines,
                  maxLength: forms[i].maxLength,
                  decoration: InputDecoration(
                    prefixText: forms[i].prefix,
                    labelText: forms[i].labelText,
                    hintText: forms[i].hintText,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  validator: MultiValidator(
                    [
                      if (forms[i].mandatory)
                        RequiredValidator(
                          errorText: 'mandatory_field'.tr(),
                        ),
                      if (forms[i].minLength != null && forms[i].minLength! > 0)
                        MinLengthValidator(
                          forms[i].minLength!,
                          errorText: 'minimum_chars_warning'.tr(
                            args: [
                              forms[i].minLength!.toString(),
                            ],
                          ),
                        ),
                      if (forms[i].maxLength != null && forms[i].maxLength! > 0)
                        MaxLengthValidator(
                          forms[i].maxLength!,
                          errorText: 'max_chars_warning'.tr(),
                        ),
                      for (int j = 0; j < forms[i].validators.length; j++)
                        forms[i].validators[j],
                    ],
                  ),
                ),
              ),
          ElevatedButton(
            onPressed: () {
              final f =
                  forms.firstWhereOrNull((element) => element.key == 'url');
              if (f != null) {
                final String text = controllers[f.key].text.trim();
                if (text.contains('://')) {
                  controllers[f.key].text = text
                      .replaceFirst('https://', '')
                      .replaceFirst('http://', '');
                }
              }

              if (formKey.currentState!.validate()) {
                final map = <String, String?>{};
                for (final f in forms) {
                  switch (f.type) {
                    case FormType.searchAddress:
                    case FormType.textField:
                      map[f.key] = controllers[f.key].text.trim();
                      break;
                    case FormType.dropdown:
                      map[f.key] = controllers[f.key].value;
                      break;
                  }
                  if (f.type == FormType.textField) {
                  } else if (f.type == FormType.dropdown) {}
                }
                if (latitude.value != null && longitude.value != null) {
                  map['lat'] = latitude.value!;
                  map['long'] = longitude.value!;
                }
                map['placeId'] = placeId.value!;
                map['streetName'] = streetName.value;
                map['streetNumber'] = streetNumber.value;
                map['formattedAddress'] = formattedAddress.value;
                onSubmit?.call(map);
              }
            },
            child: Text(buttonText),
          ),
        ],
      ),
    );
  }
}

class UrlValidator extends TextFieldValidator {
  UrlValidator({String errorText = 'invalid url'}) : super(errorText);

  @override
  bool get ignoreEmptyValues => false;

  @override
  bool isValid(String? value) {
    final uri = Uri.tryParse(value!);
    if (uri == null) return false;
    return true;
  }
}

class CFValidator extends TextFieldValidator {
  CFValidator({String errorText = 'Il codice fiscale non è valido'})
      : super(errorText);

  @override
  bool get ignoreEmptyValues => false;

  @override
  bool isValid(String? value) {
    if (value == null) return false;
    if (value.length > 11 && value.length < 16) return false;
    if (value.length == 11) return true;
    if (CodiceFiscale.check(value)) {
      return true;
    }
    return false;
/*
    if (value.toUpperCase() == 'NA') {
      return true;
    } else if (value.length == 16) {
      return true;
    }
    return false;*/
  }
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}
