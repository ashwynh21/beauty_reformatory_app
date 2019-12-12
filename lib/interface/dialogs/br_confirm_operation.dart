import 'package:flutter/material.dart';
import 'package:beautyreformatory/utilities/resources.dart';

class BrConfirmOperation extends StatefulWidget {
  String message;
  Future Function(BrConfirmOperation, bool) callback;

  BrConfirmOperation({Key key,
    @required this.message,
    @required this.callback,
  }) : super(key: key);

  @override
  _BrConfirmOperationState createState() => _BrConfirmOperationState();
}

class _BrConfirmOperationState extends State<BrConfirmOperation> {
  @override
  Widget build(BuildContext context) {
    return  Dialog(
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 112,

        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),

          child: Container(
            color: Colors.white,

            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,

              children: <Widget>[
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(top: 12, bottom: 8),
                        alignment: Alignment.centerLeft,

                        child: Text((widget.message != null) ? widget.message.toString() : '',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            )
                        ),
                      ),
                    ],
                  ),
                ),

                /*
                      Buttons are here
                       */
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      MaterialButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        child: Text('CANCEL',
                          style: TextStyle(
                            color: resources.colors.primary,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      MaterialButton(
                        onPressed: () {
                          widget.callback(widget, true).then((_) {
                            Navigator.of(context).pop();
                          });
                        },
                        child: Text('YES',
                          style: TextStyle(
                            color: resources.colors.primary,
                            fontSize: 12,
                          ),
                        ),
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}