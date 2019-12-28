import 'package:beautyreformatory/interface/components/br_icon.dart';
import 'package:beautyreformatory/interface/dialogs/br_edit_field_dialog.dart';
import 'package:beautyreformatory/services/controllers/user_controller.dart';
import 'package:beautyreformatory/services/models/user.dart';
import 'package:flutter/material.dart';
import 'package:beautyreformatory/utilities/dialogs.dart';

class FullnameEditor extends StatefulWidget {
  User user;
  FullnameEditor({Key key,
    @required this.user,
  }) : super(key: key);

  @override
  _FullnameEditorState createState() => _FullnameEditorState();
}

class _FullnameEditorState extends State<FullnameEditor> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12),
      child: Flex(
        direction: Axis.horizontal,
        children: <Widget>[
          Expanded(
            flex: 9,

            child: Container(
              margin: EdgeInsets.only(left: 46),
              alignment: Alignment.center,
              child: Text(widget.user.fullname,
                style: TextStyle(
                  color: Colors.black87.withOpacity(0.64),
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,

            child: Container(
              child: BrIcon(
                src: 'lib/interface/assets/icons/pencil.svg',
                color: Colors.black26,
                size: 36,
                click: (view) {

                  dialogs.editfield(context,
                      placeholder: 'Fullname',
                      value: widget.user.fullname,
                      icon: 'lib/interface/assets/flares/avatar_icon.flr',
                      instruction: 'Enter your fullname',
                      callback: (BrEditFieldDialog dialog, String value) {
                        setState(() {
                          dialogs.loader.show(true);
                        });

                        return UserController().update(
                          email: widget.user.email,
                          token: widget.user.token,
                          fullname: value,
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
            ),
          )
        ],
      ),
    );
  }
}