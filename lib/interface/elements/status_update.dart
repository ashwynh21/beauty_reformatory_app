import 'package:beautyreformatory/interface/components/br_icon.dart';
import 'package:beautyreformatory/interface/dialogs/br_edit_field_dialog.dart';
import 'package:beautyreformatory/services/controllers/user_controller.dart';
import 'package:beautyreformatory/services/middleware/user_middleware.dart';
import 'package:beautyreformatory/services/models/user.dart';
import 'package:flutter/material.dart';
import 'package:beautyreformatory/utilities/dialogs.dart';
import 'package:beautyreformatory/utilities/resources.dart';

class StatusUpdate extends StatefulWidget {

  StatusUpdate({Key key,
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

        child: StreamBuilder(
          stream: UserController.stream.stream,
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if(snapshot.hasData) {
              return Flex(
                direction: Axis.horizontal,

                children: <Widget>[
                  Expanded(
                    flex: 2,

                    child: Container(
                      alignment: Alignment.center,
                      child: Tooltip(
                        waitDuration: Duration.zero,
                        decoration: BoxDecoration(
                          color: resources.colors.primary.withOpacity(0.32)
                        ),
                        message: 'status',
                        child: BrIcon(
                          src: 'lib/interface/assets/icons/status.svg',
                          color: Colors.black26,
                          click: (view) {},
                        )
                      )
                    ),
                  ),
                  Expanded(
                    flex: 9,

                    child: Container(
                      alignment: Alignment.centerLeft,
                      child: Text((snapshot.data.status != null) ? snapshot.data.status : 'type a status about yourself.',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                          fontFamily: 'Jandys Dua',
                          color: Colors.black54.withOpacity((snapshot.data.status != null) ? 1 : 0.12),
                          letterSpacing: 1.2,
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
                              value: snapshot.data.status,
                              icon: 'lib/interface/assets/flares/status_icon.flr',
                              instruction: 'Type a status about yourself.',
                              callback: (BrEditFieldDialog dialog, String value) {
                                setState(() {
                                  loader.show(true);
                                });
                                return UserMiddleware.fromSave().then((User user) {
                                  return UserController().update(
                                    email: user.email,
                                    token: user.token,
                                    status: value,
                                  ).then((User user) {
                                    if(user != null){
                                      UserMiddleware.toSave(user).then((_){
                                        snack.show('Hey, your profile has been updated!');
                                        setState(() {
                                          loader.show(false);
                                        });
                                      });
                                    }
                                  }).catchError((error) {
                                    snack.show(error.message);
                                    setState(() {
                                      loader.show(false);
                                    });
                                  });
                                });
                              }
                          );
                        },
                      ),
                    ),
                  )
                ],
              );
            }

            return Container();
          }
        )
      );
  }
}