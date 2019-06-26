import 'package:flutter/material.dart';
import 'package:pos/src/model/payment_request.dart';
import 'package:wom_package/wom_package.dart';

class CardRequest extends StatelessWidget {
  final PaymentRequest request;
  final Function onDelete;
  final Function onEdit;
  final Function onDuplicate;

  const CardRequest(
      {Key key, this.request, this.onDelete, this.onEdit, this.onDuplicate})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 260.0,
      child: Card(
        margin: const EdgeInsets.all(10),
        clipBehavior: Clip.antiAlias,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              width: 10.0,
              color: request.status == RequestStatus.COMPLETE
                  ? Colors.green
                  : request.status == RequestStatus.DRAFT
                      ? Colors.orange
                      : Colors.red,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  MyRichText(
                    t1: 'ID: ',
                    t2: '#${request.id.toString()}',
                  ),
                  MyRichText(
                    t1: 'Name: ',
                    t2: request.name,
                  ),
                  MyRichText(
                    t1: 'Date: ',
                    t2: request.dateString,
                  ),
                  MyRichText(
                    t1: 'Amount:',
                    t2: request.amount.toString(),
                  ),
                  MyRichText(
                    t1: "Aim: ",
                    t2: request.aimName,
                  ),
                  MyRichText(
                    t1: "Password: ",
                    t2: request.password,
                  ),
                  MyRichText(
                    t1: "MaxAge: ",
                    t2: "${request?.simpleFilter?.maxAge}",
                  ),
                  MyRichText(
                    t1: "Position: ",
                    t2: "${request?.simpleFilter?.bounds.toString()}",
                  ),
                ],
              ),
            ),
            Spacer(),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                IconButton(icon: Icon(Icons.share), onPressed: null),
                IconButton(
                    icon: Icon(request.status == RequestStatus.COMPLETE
                        ? Icons.control_point_duplicate
                        : Icons.edit),
                    onPressed: request.status == RequestStatus.COMPLETE
                        ? onDuplicate
                        : onEdit),
                IconButton(icon: Icon(Icons.delete), onPressed: onDelete),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class MyRichText extends StatelessWidget {
  final String t1;
  final String t2;

  const MyRichText({Key key, this.t1, this.t2}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: t1,
        style: TextStyle(fontSize: 12.0, color: Colors.grey),
        children: <TextSpan>[
          TextSpan(
              text: t2, style: TextStyle(fontSize: 20, color: Colors.black)),
        ],
      ),
    );
  }
}
