import 'package:dart_wom_connector/dart_wom_connector.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:pos/src/exceptions.dart';
import 'package:pos/src/offers/application/offers.dart';
import 'package:pos/src/screens/password/reset_password.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:validatorless/validatorless.dart';

import '../../my_logger.dart';

class RequestResetPasswordScreen extends HookConsumerWidget {
  const RequestResetPasswordScreen({Key? key}) : super(key: key);
  static const String path = 'requestReset';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = useMemoized(GlobalKey<FormState>.new);
    final passwordController =
        useTextEditingController();
    final isLoading = useState(false);
    return Scaffold(
      appBar: AppBar(
        title: Text('request_password_title'.tr()),
      ),
      body: LoadingOverlay(
        isLoading: isLoading.value,
        child: Form(
          key: formKey,
          child: ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              Text('request_password_description'.tr()),
              const SizedBox(height: 24),
              TextFormField(
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (v) {},
                controller: passwordController,
                keyboardType: TextInputType.visiblePassword,
                decoration: InputDecoration(
                  labelText: 'Email',
                  hintText: 'write_here'.tr(),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: Validatorless.multiple(
                  [
                    Validatorless.email(
                      'email_not_valid'.tr(),
                    ),
                    Validatorless.required(
                      'mandatory_field'.tr(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    try {
                      isLoading.value = true;
                      await ref
                          .read(getPosProvider)
                          .requestResetPassword(passwordController.text.trim());

                      context.go(
                          '/${ResetPasswordScreen.path}?email=${passwordController.text.trim()}');
                    } on ServerException catch (ex) {
                      isLoading.value = false;
                      logger.e(ex);
                      Alert(
                        context: context,
                        // title: 'sign_up_error'.tr(),
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
                    } catch (ex, st) {
                      isLoading.value = false;
                      logger.e(ex);
                      logger.e(st);
                      Alert(
                        context: context,
                        title: 'sign_up_error'.tr(),
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
                  }
                },
                child: Text('continue'.tr()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
