import 'package:beautyreformatory/interface/components/br_icon.dart';
import 'package:beautyreformatory/interface/dialogs/br_edit_field_dialog.dart';
import 'package:beautyreformatory/services/controllers/user_controller.dart';
import 'package:beautyreformatory/services/models/user.dart';
import 'package:flutter/material.dart';
import 'package:beautyreformatory/utilities/dialogs.dart';
import 'package:beautyreformatory/utilities/resources.dart';

class StatusUpdate extends StatefulWidget {
  User user;

  StatusUpdate({Key key,
    @required this.user
  }) : super(key: key);

  @override
  _StatusUpdateState createState() => _StatusUpdateState();
}

class _StatusUpdateState extends State<StatusUpdate> {

  @override
  Widget build(BuildContext context) {
    return
      /*
      User's status is here
       */
      Container(
        padding: EdgeInsets.only(left: 24, right: 24, top: 32, bottom: 12),

        child: Flex(
          direction: Axis.horizontal,

          children: <Widget>[
            Expanded(
              flex: 2,

              child: Container(
                  alignment: Alignment.center,
                  child: Tooltip(
                      waitDuration: Duration.zero,
                      decoration: BoxDecoration(
                        color: resources.colors.primary.withOpacity(0.32),
                        borderRadius: BorderRadius.circular(4)
                      ),
                      message: 'describe who you are.',
                      textStyle: TextStyle(
                          color: Colors.white
                      ),
                      child: BrIcon(
                        src: 'lib/interface/assets/icons/status.svg',
                        color: Colors.black26,
                        click: (view) {},
                      )
                  )
              ),
            ),
            Expanded(
              flex: 10,

              child: Container(
                alignment: Alignment.centerLeft,
                child: Text(widget.user.status??'type a status',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    fontFamily: 'Handle',
                    color: Colors.black54.withOpacity((widget.user.status != null) ? 1 : 0.12),
                    letterSpacing: 1.0,
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 2,

              child: Container(
                child: BrIcon(
                  src: 'lib/interface/assets/icons/pencil.svg',
                  color: Colors.black26,
                  size: 36,
                  click: (view) {

                    dialogs.editfield(context,
                        placeholder: 'Status update',
                        value: widget.user.status,
                        icon: 'lib/interface/assets/flares/status_icon.flr',
                        instruction: 'Type a status about yourself.',
                        callback: (BrEditFieldDialog dialog, String value) {
                          setState(() {
                            dialogs.loader.show(true);
                          });

                          return UserController().update(
                            email: widget.user.email,
                            token: widget.user.token,
                            status: value,
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
        )
      );
  }
}