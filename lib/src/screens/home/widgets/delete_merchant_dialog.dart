import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pos/src/blocs/authentication/authentication_bloc.dart';
import 'package:pos/src/offers/application/offers.dart';
import 'package:pos/src/services/user_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'delete_merchant_dialog.freezed.dart';

part 'delete_merchant_dialog.g.dart';

@freezed
class DeleteMerchantData with _$DeleteMerchantData {
  const factory DeleteMerchantData({
    required bool operationPerformed,
    required int countOfDeletedMerchants,
    required int countOfDeletedPos,
    required int countOfDeletedOffers,
  }) = _DeleteMerchantData;
}

@riverpod
class DeleteMerchantNotifier extends _$DeleteMerchantNotifier {
  late String merchantId;
  String? token;

  Future<DeleteMerchantData> build(String merchantId) async {
    this.merchantId = merchantId;
    token = await ref.read(userRepositoryProvider).getToken();
    if (token == null) throw Exception('token is null');
    final response = await ref.read(getPosProvider).deleteMerchant(
          merchantId: merchantId,
          token: token!,
          dryRun: true,
        );
    return DeleteMerchantData(
      operationPerformed: response.operationPerformed,
      countOfDeletedMerchants: response.countOfDeletedMerchants,
      countOfDeletedPos: response.countOfDeletedPos,
      countOfDeletedOffers: response.countOfDeletedOffers,
    );
  }

  Future confirmDeletion() async {
    state = AsyncLoading();
    final token = await ref.read(userRepositoryProvider).getToken();
    if (token == null) throw Exception('token is null');
    final response = await ref
        .read(getPosProvider)
        .deleteMerchant(merchantId: merchantId, token: token);
    state = AsyncData(DeleteMerchantData(
      operationPerformed: response.operationPerformed,
      countOfDeletedMerchants: response.countOfDeletedMerchants,
      countOfDeletedPos: response.countOfDeletedPos,
      countOfDeletedOffers: response.countOfDeletedOffers,
    ));
    ref.read(authNotifierProvider.notifier).refresh();
  }
}

class DeleteMerchantDialog extends ConsumerWidget {
  final String merchantId;

  const DeleteMerchantDialog({
    Key? key,
    required this.merchantId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(deleteMerchantNotifierProvider(merchantId));

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: state.when(
        data: (info) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (info.operationPerformed) ...[
                Text('Il merchant è stato cancellato correttamente'),
                Icon(
                  Icons.check_circle,
                  color: Colors.green,
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Ok'),
                ),
              ] else ...[
                const SizedBox(height: 16),
                Text(
                  'Con l\'eliminazione di questo merchant verranno cancellati anche i POS abbinati e le offerte create:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 8),
                Text('POS: ${info.countOfDeletedPos}'),
                Text('Offerte: ${info.countOfDeletedOffers}'),
                const SizedBox(height: 16),
                Text(
                  'Sei sicuro di voler cancellare questo Merchant?',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('cancel'.tr()),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        ref
                            .read(deleteMerchantNotifierProvider(merchantId)
                                .notifier)
                            .confirmDeletion();
                      },
                      child: Text('yes'.tr()),
                    ),
                  ],
                )
              ]
            ],
          );
        },
        error: (ex, st) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('somethings_wrong'.tr()),
              if (kDebugMode) Text(ex.toString()),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('close'.tr()),
              ),
            ],
          );
        },
        loading: () {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Stiamo recuperando le informazioni...'),
              const SizedBox(height: 16),
              SizedBox(
                height: 50,
                width: 50,
                child: CircularProgressIndicator(),
              ),
            ],
          );
        },
      ),
    );
  }
}
