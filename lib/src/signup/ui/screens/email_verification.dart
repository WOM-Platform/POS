import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:easy_rich_text/easy_rich_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:pos/src/blocs/authentication/authentication_bloc.dart';
import 'package:pos/src/my_logger.dart';
import 'package:pos/src/screens/root/root.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:validatorless/validatorless.dart';

class EmailVerificationScreen extends HookConsumerWidget {
  static const String path = 'verify';
  final bool startTimer;
  final String? code;
  final String? email;

  const EmailVerificationScreen({
    Key? key,
    this.code,
    this.email,
    this.startTimer = false,
  }) : super(key: key);

  void useInterval(VoidCallback callback, Duration delay) {
    final savedCallback = useRef(callback);
    savedCallback.value = callback;

    useEffect(() {
      final timer = Timer.periodic(delay, (_) => savedCallback.value());
      return timer.cancel;
    }, [delay]);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final codeController = useTextEditingController(text: code);
    // final state = ref.watch(authNotifierProvider);
    final isLoading = useState(false);
    final remainingSeconds = useState<int>(60);
    useInterval(() {
      final tmp = remainingSeconds.value;
      if (tmp > 0) {
        remainingSeconds.value = tmp - 1;
      }
    }, Duration(seconds: 1));
    return Scaffold(
      appBar: AppBar(
        title: Text('verify_account'.tr()),
      ),
      body: LoadingOverlay(
        isLoading: isLoading.value,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            EasyRichText(
              'email_sent'.tr(
                args: ['${email != null ? ' $email' : ''}'],
              ),
              defaultStyle: TextStyle(fontSize: 18),
              patternList: [
                EasyRichTextPattern(
                  targetString: email,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            // Text(
            //   'email_sent'.tr(
            //     args: ['${email != null ? ' $email' : ''}'],
            //   ),
            //   style: TextStyle(fontSize: 18),
            // ),
            const SizedBox(height: 24),
            TextFormField(
              enabled: code == null,
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (v) {},
              controller: codeController,
              keyboardType: TextInputType.visiblePassword,
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
                        Validatorless.required('mandatory_field'.tr()),
                      ],
              ),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              onPressed: () async {
                try {
                  FocusScope.of(context).requestFocus(new FocusNode());
                  isLoading.value = true;
                  final c = codeController.text.trim();
                  if (email != null && c.isNotEmpty) {
                    final (verified, needToLogin) = await ref
                        .read(authNotifierProvider.notifier)
                        .verifyEmail(email!, codeController.text.trim());
                    if (!verified) {
                      Alert(
                        context: context,
                        type: AlertType.error,
                        title: 'somethings_wrong'.tr(),
                        desc: 'email_verification_error'.tr(),
                        buttons: [
                          DialogButton(
                            child: Text('Ok'),
                            onPressed: () {
                              context.pop();
                            },
                          ),
                        ],
                      ).show();
                    } else if (needToLogin) {
                      Alert(
                        context: context,
                        title: 'verification_done'.tr(),
                        desc: 'now_go_to_login'.tr(),
                        buttons: [
                          DialogButton(
                            child: Text('Ok'),
                            onPressed: () {
                              context.pop();
                              context.go(RootScreen.path);
                            },
                          ),
                        ],
                      ).show();
                    } else {
                      context.go(RootScreen.path);
                    }
                  }
                  isLoading.value = false;
                } catch (ex) {
                  isLoading.value = false;
                  logger.e(ex);
                  Alert(
                    context: context,
                    type: AlertType.error,
                    title: 'somethings_wrong'.tr(),
                    buttons: [
                      DialogButton(
                        child: Text('Ok'),
                        onPressed: () {
                          context.pop();
                        },
                      ),
                    ],
                  ).show();
                }
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.check),
                  const SizedBox(width: 8),
                  Text('i_verified_my_email'.tr()),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Divider(),
            Text('didnt_receive_email'.tr()),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: remainingSeconds.value > 0
                  ? null
                  : () async {
                      if (email != null) {
                        await ref
                            .read(authNotifierProvider.notifier)
                            .sendEmailVerification(email!);
                        remainingSeconds.value = 60;
                      }
                    },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.refresh),
                  const SizedBox(width: 8),
                  Text('request_new_email'.tr()),
                ],
              ),
            ),
            if (remainingSeconds.value > 0) ...[
              Text(
                'wait_seconds'.tr(args: ['${remainingSeconds.value}']),
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black54),
              ),
            ],
            const SizedBox(height: 32),
            TextButton(
              onPressed: () {
                ref.read(authNotifierProvider.notifier).logOut();
              },
              child: Text(
                'back_to_login'.tr(),
                style: TextStyle(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
