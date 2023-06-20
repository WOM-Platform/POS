import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pos/src/signup/application/create_merchant.dart';

class FirstLoginScreen extends ConsumerWidget {
  const FirstLoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(createMerchantNotifierProvider);
    return Container();
  }
}