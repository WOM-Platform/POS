import 'package:dart_wom_connector/dart_wom_connector.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';


import 'package:pos/src/blocs/payment_request/payment_request_bloc.dart';
import 'package:pos/src/model/payment_request.dart';
import 'package:pos/src/model/request_status_enum.dart';
import 'package:pos/src/offers/application/offers.dart';
import 'package:pos/src/offers/ui/empty_offers.dart';

import 'package:pos/src/screens/create_payment/create_payment.dart';
import 'package:pos/src/screens/home/home.dart';
import 'package:pos/src/screens/home/widgets/card_request.dart';
import 'package:pos/src/screens/request_confirm/bloc.dart';
import 'package:pos/src/screens/request_confirm/request_confirm.dart';
import 'package:pos/src/screens/request_datails/request_datails.dart';
import 'package:pos/src/services/pdf_creator.dart';

import 'package:share/share.dart';

import '../../../db/payment_database/payment_database.dart';
import '../../../my_logger.dart';

class HomeList extends ConsumerStatefulWidget {
  // final List<PaymentRequest> requests;
  //
  // HomeList({Key? key, required this.requests}) : super(key: key);

  @override
  _HomeListState createState() => _HomeListState();
}

class _HomeListState extends ConsumerState<HomeList> {
  @override
  Widget build(BuildContext context) {
    // final bloc = ref.watch(homeNotifierProvider);
    final state = ref.watch(requestNotifierProvider);
    return state.when(
      data: (data) {
        return data.when(
          requestLoading: () {
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
          noDataConnectionState: () {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'no_connection_title'.tr(),
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'no_connection_aim_desc'.tr(),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  FloatingActionButton.extended(
                      label: Text('try_again'.tr()),
                      onPressed: () {
                        ref.invalidate(requestNotifierProvider);
                      }),
                ],
              ),
            );
          },
          noPosState: () {
            return Center(
              child: WarningWidget(
                text: 'no_pos'.tr(),
              ),
            );
          },
          noMerchantState: () {
            return Center(
              child: WarningWidget(
                text: 'no_merchants'.tr(),
              ),
            );
          },
          requestLoaded: (requests) {
            if (requests.isEmpty) {
              return EmptyOffers();
            }

            return ListView.builder(
              itemCount: requests.length + 1,
              itemBuilder: (context, index) {
                if (index == requests.length) {
                  return const SizedBox(
                    height: 80,
                  );
                }
                return GestureDetector(
                  onTap: requests[index].status == RequestStatus.COMPLETE
                      ? () => goToDetails(requests[index])
                      : null,
                  child: Slidable(
                    startActionPane: ActionPane(
                      extentRatio: 0.5,
                      motion: const BehindMotion(),
                      children: [
                        if (requests[index].status ==
                            RequestStatus.COMPLETE) ...[
                          MySlidableAction(
                            icon: Icons.share,
                            onTap: () {
                              Share.share('${requests[index].deepLink}');
                            },
                            color: Colors.green,
                          ),
                          if (requests[index].persistent)
                            MySlidableAction(
                              icon: Icons.picture_as_pdf,
                              onTap: () async {
                                final pos = ref.read(selectedPosProvider)?.pos;
                                if (pos == null) return;
                                final pdfCreator = PdfCreator();
                                final file = await pdfCreator.buildPdf(
                                    requests[index],
                                    pos,
                                   context.locale
                                            .languageCode ??
                                        'en');
                                Share.shareFiles([file.path]);
                              },
                              color: Colors.pink,
                            ),
                        ],
                        if (requests[index].status != RequestStatus.COMPLETE)
                          MySlidableAction(
                            icon: Icons.edit,
                            onTap: () => onEdit(requests[index]),
                            color: Colors.orange,
                          ),
                      ],
                    ),
                    endActionPane: ActionPane(
                      motion: const DrawerMotion(),
                      extentRatio: 0.25,
                      children: [
                        MySlidableAction(
                          icon: Icons.delete,
                          onTap: () => onDelete(requests[index]),
                          color: Colors.red,
                        ),
                      ],
                    ),
                    child: CardRequest(
                      request: requests[index],
                      onDelete: () => onDelete(requests[index]),
                      onEdit: () => onEdit(requests[index]),
                      onDuplicate: () => onDuplicate(requests[index]),
                    ),
                  ),
                );
              },
            );
          },
          requestsLoadingErrorState: (error) {
            return Center(
              child: Text(
                error.tr(),
                textAlign: TextAlign.center,
              ),
            );
          },
          error: (ex, st) {
            return Center(
              child: Text('error_screen_state'.tr()),
            );
          },
        );
      },
      error: (ex, st) {
        return Center(
          child: Text(
            'error_screen_state'.tr(),
          ),
        );
      },
      loading: () {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  goToDetails(PaymentRequest request) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => RequestDetails.fromPaymentRequest(request, () async {
          final pos = ref.read(selectedPosProvider)?.pos;
          if (pos == null) return;
          final pdfCreator = PdfCreator();
          final file = await pdfCreator.buildPdf(
            request,
            pos,
           context.locale.languageCode ?? 'en',
          );
          Share.shareFiles([file.path]);
        }),
      ),
    );
  }

  onDuplicate(PaymentRequest request) {
    final pos = ref.read(selectedPosProvider)?.pos;
    if (pos == null) return;
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => ProviderScope(
          overrides: [
            paymentRequestProvider.overrideWith((ref) => request.copyFrom()),
            requestConfirmNotifierProvider.overrideWith(
              (ref) => RequestConfirmBloc(
                ref: ref,
                pos: ref.read(getPosProvider),
                pointOfSale: pos,
              ),
            ),
          ],
          child: RequestConfirmScreen(),
        ),
      ),
    );
  }

  onEdit(PaymentRequest request) {
    final id = ref.read(selectedPosProvider)?.pos?.id;
    if (id == null) return;
    final provider = ProviderScope(
      child: GenerateWomScreen(),
      overrides: [
        createPaymentNotifierProvider.overrideWith((ref) =>
            CreatePaymentRequestBloc(
                ref: ref,
                posId: id,
                draftRequest: request,
                languageCode:
                   context.locale.languageCode))
      ],
    );
    Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => provider));
  }

  onDelete(PaymentRequest request) async {
    logger.i("onDelete");
    if (request.id == null) return;
    final result = await PaymentDatabase.get().deleteRequest(request.id!);
    logger.i("onDelete from DB complete: $result");
    if (result > 0) {
      ref.invalidate(requestNotifierProvider);
    }
  }
}

class MySlidableAction extends StatelessWidget {
  final Color? color;
  final Function()? onTap;
  final IconData icon;

  const MySlidableAction({Key? key, this.color, this.onTap, required this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Flexible(
      fit: FlexFit.tight,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4),
          decoration: BoxDecoration(
              color: color, borderRadius: BorderRadius.circular(16)),
          child: Center(
            child: Icon(
              icon,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
