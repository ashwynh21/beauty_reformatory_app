import 'package:beautyreformatory/interface/components/br_icon.dart';
import 'package:beautyreformatory/interface/dialogs/br_edit_field_dialog.dart';
import 'package:beautyreformatory/services/controllers/user_controller.dart';
import 'package:beautyreformatory/services/models/user.dart';
import 'package:flutter/material.dart';
import 'package:beautyreformatory/utilities/dialogs.dart';

class HandleEditor extends StatefulWidget {
  User user;
  HandleEditor({Key key,
    @required this.user,
  }) : super(key: key);

  @override
  _HandleEditorState createState() => _HandleEditorState();
}

class _HandleEditorState extends State<HandleEditor> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12),
      child: Flex(
        direction: Axis.horizontal,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            flex: 9,

            child: Container(
              margin: EdgeInsets.only(left: 46),
              alignment: Alignment.center,
              child: Text(widget.user.handle,
                  style: TextStyle(
                    color: Colors.black26,
                    fontSize: 20,
                    fontWeight: FontWeight.w300,
                  )
              ),
            ),
          ),
          Expanded(
            flex: 1,

            child: BrIcon(
              src: 'lib/interface/assets/icons/pencil.svg',
              color: Colors.black26,
              size: 36,
              click: (view) {
                dialogs.editfield(context,
                    placeholder: 'Handle',
                    value: (widget.user.handle.toString().contains('@')) ? widget.user.handle.toString().split('@')[1] : widget.user.handle.toString(),
                    icon: 'lib/interface/assets/icons/at.svg',
                    instruction: 'Enter your handle',
                    callback: (BrEditFieldDialog dialog, String value) {
                      setState(() {
                        dialogs.loader.show(true);
                      });

                      return UserController().update(
                        email: widget.user.email,
                        token: widget.user.token,
                        handle: '@' + value,
                      ).then((User user) {
                        if(user != null){
                          dialogs.snack.show('Hey, your profile has been updated!');
                          setState(() {
                            widget.user = user;
                            dialogs.loader.show(false);
                          });
                        }
                      }).catchError((error) {
                        dialogs.snack.show(error.message);
                        setState(() {
                          dialogs.loader.show(false);
                        });
                      });
                    }
                );
              },
            ),
          )
        ],
      ),
    );
  }
}