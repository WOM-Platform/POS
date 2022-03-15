import 'package:dart_wom_connector/dart_wom_connector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:pos/localization/app_localizations.dart';
import 'package:pos/src/blocs/home/bloc.dart';
import 'package:pos/src/blocs/payment_request/payment_request_bloc.dart';
import 'package:pos/src/model/payment_request.dart';
import 'package:pos/src/model/request_status_enum.dart';

import 'package:pos/src/screens/create_payment/create_payment.dart';
import 'package:pos/src/screens/home/widgets/card_request.dart';
import 'package:pos/src/screens/request_confirm/bloc.dart';
import 'package:pos/src/screens/request_confirm/request_confirm.dart';
import 'package:pos/src/screens/request_datails/request_datails.dart';
import 'package:pos/src/services/pdf_creator.dart';

import 'package:share/share.dart';

import '../../../my_logger.dart';

class HomeList extends StatefulWidget {
  final List<PaymentRequest> requests;

  HomeList({Key? key, required this.requests}) : super(key: key);

  @override
  _HomeListState createState() => _HomeListState();
}

class _HomeListState extends State<HomeList> {
  late HomeBloc bloc;

  @override
  Widget build(BuildContext context) {
    bloc = BlocProvider.of<HomeBloc>(context);
    return ListView.builder(
      itemCount: widget.requests.length + 1,
      itemBuilder: (context, index) {
        if (index == widget.requests.length) {
          return const SizedBox(
            height: 80,
          );
        }
        return GestureDetector(
          onTap: widget.requests[index].status == RequestStatus.COMPLETE
              ? () => goToDetails(index)
              : null,
          child: Slidable(
            startActionPane: ActionPane(
              extentRatio: 0.5,
              motion: const BehindMotion(),
              children: [
                if (widget.requests[index].status ==
                    RequestStatus.COMPLETE) ...[
                  MySlidableAction(
                    icon: Icons.share,
                    onTap: () {
                      Share.share('${widget.requests[index].deepLink}');
                    },
                    color: Colors.green,
                  ),
                  if (widget.requests[index].persistent)
                    MySlidableAction(
                      icon: Icons.picture_as_pdf,
                      onTap: () async {
                        final pos = context.read<HomeBloc>().selectedPos;
                        if (pos == null) return;
                        final pdfCreator = PdfCreator();
                        final file = await pdfCreator.buildPdf(
                            widget.requests[index],
                            pos,
                            AppLocalizations.of(context)?.locale.languageCode ??
                                'en');
                        Share.shareFiles([file.path]);
                      },
                      color: Colors.pink,
                    ),
                ],
                if (widget.requests[index].status != RequestStatus.COMPLETE)
                  MySlidableAction(
                    icon: Icons.edit,
                    onTap: () => onEdit(index),
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
                  onTap: () => onDelete(index),
                  color: Colors.red,
                ),
              ],
            ),
            child: CardRequest(
              request: widget.requests[index],
              onDelete: () => onDelete(index),
              onEdit: () => onEdit(index),
              onDuplicate: () => onDuplicate(index),
            ),
          ),
        );
      },
    );
  }

  void _showSnackBar(BuildContext context, String text) {
    Scaffold.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  goToDetails(int index) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => RequestDetails(
          paymentRequest: widget.requests[index],
        ),
      ),
    );
  }

  onDuplicate(int index) {
    final pos = context.read<HomeBloc>().selectedPos;
    if (pos == null) return;
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => BlocProvider(
          create: (c) => RequestConfirmBloc(
            pos: context.read<PosClient>(),
            pointOfSale: pos,
            paymentRequest: widget.requests[index].copyFrom(),
          ),
          child: RequestConfirmScreen(),
        ),
      ),
    );
  }

  onEdit(int index) {
    final id = context.read<HomeBloc>().selectedPos?.id;
    if (id == null) return;
    final provider = BlocProvider(
      child: GenerateWomScreen(),
      create: (ctx) => CreatePaymentRequestBloc(
          posId: id,
          draftRequest: widget.requests[index],
          languageCode: AppLocalizations.of(context)?.locale.languageCode),
    );
    Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => provider));
  }

  onDelete(int index) async {
    logger.i("onDelete");
    if (widget.requests[index].id == null) return;
    final result = await bloc.deleteRequest(widget.requests[index].id!);
    logger.i("onDelete from DB complete: $result");
    if (result > 0) {
      setState(() {
        widget.requests.removeAt(index);
      });
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
