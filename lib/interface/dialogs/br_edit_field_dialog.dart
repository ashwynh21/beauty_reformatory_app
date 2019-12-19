import 'package:beautyreformatory/interface/components/br_input.dart';
import 'package:beautyreformatory/utilities/resources.dart';
import 'package:flutter/material.dart';

class BrEditFieldDialog extends StatefulWidget {
  String placeholder, value, icon, instruction, submit;
  TextInputType type;
  bool obscure;
  Future Function(BrEditFieldDialog, String) callback;

  BrEditFieldDialog({Key key,
    @required this.placeholder,
    @required this.value,
    @required this.callback,
    this.instruction,
    this.icon,
    this.type = TextInputType.text,
    this.obscure = false,
    this.submit = 'SAVE',
  }) : super(key: key);

  @override
  _BrEditFieldDialogState createState() => _BrEditFieldDialogState();
}

class _BrEditFieldDialogState extends State<BrEditFieldDialog> {
  bool loadin = false;

  BrInput field;

  @override
  void initState() {
    field = BrInput(
      icon: widget.icon,
      placeholder: widget.placeholder,
      value: widget.value,
      autofocus: true,
      type: widget.type,
      obscure: widget.obscure,
    );

    super.initState();
  }
  @override
  void didChangeDependencies() {
    load();

    super.didChangeDependencies();
  }
  @override
  Widget build(BuildContext context) {
    return  SafeArea(
      child: Material(
        color: Colors.black.withOpacity(0.64),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            AnimatedContainer(
              duration: Duration(milliseconds: 245),
              curve: Curves.easeOutCubic,
              transform: Matrix4.identity()..translate(0.0, (loadin) ? 0.0 : 212, 0.0),
              width: MediaQuery.of(context).size.width,
              height: 196,

              child: ClipRRect(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),

                  child: Container(
                    color: Colors.white,

                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,

                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 32),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(top: 24, bottom: 16),

                                child: Text((widget.instruction != null) ? widget.instruction.toString() : '',
                                    style: TextStyle(
                                      color: resources.colors.primary,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    )
                                ),
                              ),
                              field,
                            ],
                          ),
                        ),

                        /*
                        Buttons are here
                         */
                        Container(
                          margin: EdgeInsets.only(top: 12, right: 32, bottom: 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              MaterialButton(
                                onPressed: () {
                                  return unload().then((value) {
                                    Navigator.of(context).pop();
                                    return false;
                                  }).catchError((error) => Navigator.of(context).pop());
                                },
                                splashColor: resources.colors.primary.withOpacity(0.08),
                                highlightColor: resources.colors.primary.withOpacity(0.24),
                                child: Text('CANCEL',
                                  style: TextStyle(
                                    color: resources.colors.primary,
                                  ),
                                ),
                              ),
                              MaterialButton(
                                onPressed: () {
                                  widget.callback(widget, field.value).then((_) {
                                    unload().then((value) {
                                      Navigator.of(context).pop();
                                      return false;
                                    });
                                  }).catchError((error) => Navigator.of(context).pop());
                                },
                                child: Text(widget.submit,
                                  style: TextStyle(
                                    color: resources.colors.primary,
                                  ),
                                ),
                                splashColor: resources.colors.primary.withOpacity(0.08),
                                highlightColor: resources.colors.primary.withOpacity(0.24),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
              ),
            ),

            /*
            This padding is for lifting the widget when you open the keyboard
             */
            Padding(
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom)
            ),
          ],
        ),
      ),
    );
  }

  void load() {
    Future.delayed(Duration(milliseconds: 80), () {
      setState(() {
        loadin = true;
      });
    });
  }
  Future unload() async {
    setState(() {
      loadin = false;
    });
    return Future.delayed(Duration(milliseconds: 256), () async {
    });
  }
}