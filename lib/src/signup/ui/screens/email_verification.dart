import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:pos/src/blocs/authentication/authentication_bloc.dart';
import 'package:pos/src/blocs/authentication/authentication_state.dart';
import 'package:pos/src/my_logger.dart';
import 'package:pos/src/signup/application/sign_up_notifier.dart';

class EmailVerificationScreen extends HookConsumerWidget {
  static const String path = 'emailVerification';
  final bool startTimer;

  const EmailVerificationScreen({
    Key? key,
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
    final state = ref.watch(authNotifierProvider);
    final email = state is AuthenticationEmailNotVerified ? state.email : null;
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
        title: Text('Verifica il tuo account'),
      ),
      body: LoadingOverlay(
        isLoading: isLoading.value,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              'Abbiamo inviato una mail di verifica${email != null ? ' a $email' : ' al tuo indirizzo email'}.\n\n'
              'Clicca sul link contenuto nella email per confermare il tuo account e poi torna nell\'app e clicca sul pulsante seguente.',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              onPressed: () async {
                try {
                  isLoading.value = true;
                  await ref
                      .read(authNotifierProvider.notifier)
                      .checkEmailVerification();
                  isLoading.value = false;
                } catch (ex) {
                  logger.e(ex);
                }
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.check),
                  const SizedBox(width: 8),
                  Text('Ok, ho verificato la mia email'),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Divider(),
            Text(
              'Non hai ricevuto nessuna email? Verifica nella cartella dello '
              'spam oppure clicca sul seguente pulsante per ottenere un nuovo link di verifica.',
            ),
            // Text('se non trovi l\'email'),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: remainingSeconds.value > 0
                  ? null
                  : () async {
                      await ref
                          .read(authNotifierProvider.notifier)
                          .sendEmailVerification();
                      remainingSeconds.value = 60;
                    },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.refresh),
                  const SizedBox(width: 8),
                  Text('Richiedi una nuova email di verifica'),
                ],
              ),
            ),

            if (remainingSeconds.value > 0) ...[
              Text(
                'Attendi ${remainingSeconds.value} secondi per inviare di nuovo la mail',
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
                'Torna al login',
                style: TextStyle(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
