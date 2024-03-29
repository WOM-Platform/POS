import 'package:dart_wom_connector/dart_wom_connector.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:pos/src/exceptions.dart';
import 'package:pos/src/my_logger.dart';
import 'package:pos/src/signup/application/sign_up_notifier.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:validatorless/validatorless.dart';

class SignUpScreen extends HookConsumerWidget {
  static const String path = 'signUp';

  const SignUpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = useState(false);
    final formKey = useMemoized(GlobalKey<FormState>.new);

    final emailFocusNode = useFocusNode();
    final emailController = useTextEditingController();

    final nameFocusNode = useFocusNode();
    final nameController = useTextEditingController();

    final surnameFocusNode = useFocusNode();
    final surnameController = useTextEditingController();

    final passwordFocusNode = useFocusNode();
    final passwordController = useTextEditingController();
    final _obscurePassword = useState(true);

    return Scaffold(
      appBar: AppBar(
        title: Text('sign_up_title'.tr()),
      ),
      body: LoadingOverlay(
        isLoading: isLoading.value,
        child: Form(
          key: formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                focusNode: emailFocusNode,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (v) {
                  nameFocusNode.requestFocus();
                },
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  hintText: 'write_here'.tr(),
                  prefixIcon: const Icon(Icons.alternate_email),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: Validatorless.multiple(
                  [
                    Validatorless.email('email_not_valid'.tr()),
                    Validatorless.required(
                      'mandatory_field'.tr(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                textCapitalization: TextCapitalization.words,
                keyboardType: TextInputType.name,
                focusNode: nameFocusNode,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (v) {
                  surnameFocusNode.requestFocus();
                },
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'name'.tr(),
                  hintText: 'write_here'.tr(),
                  prefixIcon: const Icon(Icons.person_outline),
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
                textCapitalization: TextCapitalization.words,
                keyboardType: TextInputType.name,
                focusNode: surnameFocusNode,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (v) {
                  passwordFocusNode.requestFocus();
                },
                controller: surnameController,
                decoration: InputDecoration(
                  labelText: 'surname'.tr(),
                  hintText: 'write_here'.tr(),
                  prefixIcon: const Icon(Icons.person_outline),
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
                focusNode: passwordFocusNode,
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
                  ],
                ),
              ),
              const SizedBox(height: 32),
              Text(
                'terms_and_conditions'.tr(),
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () async {
                  FocusScope.of(context).requestFocus(new FocusNode());
                  try {
                    if (formKey.currentState!.validate()) {
                      isLoading.value = true;

                      final email = emailController.text.trim();
                      final name = nameController.text.trim();
                      final surname = surnameController.text.trim();
                      final password = passwordController.text.trim();

                      await ref.read(signUpNotifierProvider.notifier).singUp(
                            email,
                            name,
                            surname,
                            password,
                          );
                      context.pop();
                      // isLoading.value = false;
                    }
                  } on ServerException catch (ex) {
                    isLoading.value = false;
                    Alert(
                      context: context,
                      title: 'sign_up_error'.tr(),
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
                },
                child: Text('sign_up'.tr()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
