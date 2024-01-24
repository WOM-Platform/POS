import 'package:dart_wom_connector/dart_wom_connector.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:easy_rich_text/easy_rich_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:pos/src/blocs/authentication/authentication_bloc.dart';
import 'package:pos/src/exceptions.dart';
import 'package:pos/src/offers/application/offers.dart';
import 'package:pos/src/screens/home/widgets/card_request.dart';
import 'package:pos/src/screens/root/root.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:validatorless/validatorless.dart';

import '../../my_logger.dart';

class ResetPasswordScreen extends HookConsumerWidget {
  static const String path = 'reset-password';
  final String? code;
  final String email;

  const ResetPasswordScreen({
    Key? key,
    this.code,
    required this.email,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = useMemoized(GlobalKey<FormState>.new);

    final emailController = useTextEditingController(text: email);
    final codeController = useTextEditingController(text: code);
    final passwordController = useTextEditingController();
    final repeatPasswordController = useTextEditingController();
    final _obscurePassword = useState(true);
    final _obscureRepeatPassword = useState(true);

    final isLoading = useState(false);
    return Scaffold(
      appBar: AppBar(
        title: Text('reset_password_title'.tr()),
      ),
      body: LoadingOverlay(
        isLoading: isLoading.value,
        child: Form(
          key: formKey,
          child: ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              EasyRichText(
                'reset_password_description'
                    .tr(args: [email]),
                patternList: [
                  EasyRichTextPattern(
                    targetString: email,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                enabled: false,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (v) {},
                controller: emailController,
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
                    Validatorless.required(
                      'mandatory_field'.tr(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                enabled: code == null,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (v) {},
                controller: codeController,
                keyboardType: TextInputType.visiblePassword,
                maxLength: 4,
                decoration: InputDecoration(
                  labelText: 'Codice',
                  hintText: 'write_here'.tr(),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: Validatorless.multiple(
                  code != null
                      ? []
                      : [
                          Validatorless.max(4, 'token_four_char'.tr()),
                          Validatorless.required('mandatory_field'.tr()),
                        ],
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (v) {},
                obscureText: _obscurePassword.value,
                controller: passwordController,
                keyboardType: TextInputType.visiblePassword,
                decoration: InputDecoration(
                  labelText: 'Password',
                  hintText: 'write_here'.tr(),
                  prefixIcon: const Icon(Icons.password),
                  suffixIcon: IconButton(
                      onPressed: () {
                        _obscurePassword.value = !_obscurePassword.value;
                      },
                      icon: _obscurePassword.value
                          ? const Icon(Icons.visibility_outlined)
                          : const Icon(Icons.visibility_off_outlined)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: Validatorless.multiple(
                  [
                    Validatorless.required(
                      'mandatory_field'.tr(),
                    ),
                    Validatorless.min(8, 'password_too_short'.tr()),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (v) {},
                obscureText: _obscureRepeatPassword.value,
                controller: repeatPasswordController,
                keyboardType: TextInputType.visiblePassword,
                decoration: InputDecoration(
                  labelText: 'Ripeti Password',
                  hintText: 'write_here'.tr(),
                  prefixIcon: const Icon(Icons.password),
                  suffixIcon: IconButton(
                      onPressed: () {
                        _obscureRepeatPassword.value =
                            !_obscureRepeatPassword.value;
                      },
                      icon: _obscureRepeatPassword.value
                          ? const Icon(Icons.visibility_outlined)
                          : const Icon(Icons.visibility_off_outlined)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: Validatorless.multiple(
                  [
                    Validatorless.compare(
                        passwordController, 'passwords_not_equals'.tr()),
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
                      FocusScope.of(context).requestFocus(new FocusNode());
                      isLoading.value = true;
                      await ref.read(getPosProvider).resetPassword(
                            emailController.text,
                            codeController.text,
                            repeatPasswordController.text,
                          );
                      await ref.read(authNotifierProvider.notifier).login(
                            emailController.text,
                            repeatPasswordController.text,
                          );
                      context.go(RootScreen.path);
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
                child: Text('reset_password'.tr()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
