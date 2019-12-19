import 'package:beautyreformatory/interface/components/br_icon.dart';
import 'package:beautyreformatory/interface/components/br_icon_button.dart';
import 'package:beautyreformatory/interface/screens/house/messaging/messaging.dart';
import 'package:beautyreformatory/utilities/resources.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class StatusBar extends StatefulWidget {
  StatusBar({Key key}) : super(key: key);

  @override
  _StatusBarState createState() => _StatusBarState();
}

class _StatusBarState extends State<StatusBar> {
  BrIcon heart, notifications, messages;
  BrIconButton share;

  @override
  void initState() {
    _inputinit();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Material(
        elevation: 12,
        shadowColor: Colors.black26,

        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 80,
          color: resources.colors.white,

          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(left: 24),
                child: Wrap(
                  children: <Widget>[
                    Container(
                        child: heart
                    ),
                    Container(
                        child: notifications
                    ),
                    Container(
                        child: messages
                    )
                  ],
                ),
              ),
              Container(
                  margin: EdgeInsets.only(right: 24),
                child: SvgPicture.asset('lib/interface/assets/icons/logo.svg', width: 40,)
              ),
              Row(
                children: <Widget>[
                  Container(
                      margin: EdgeInsets.only(right: 8),
                      child: Text('journal',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                          fontFamily: 'Jandys Dua',
                          color: resources.colors.primary
                        ),
                      )),
                  Container(
                      width: 36,
                      height: 36,
                      margin: EdgeInsets.only(right: 24),
                      child: share),
                ],
              )
            ],
          )
        ),
      ),
    );
  }
  void _inputinit() {
    heart = BrIcon(
      src: 'lib/interface/assets/icons/heart.svg',
      color: resources.colors.primary,
      click: (view) {

      }
    );
    notifications = BrIcon(
        src: 'lib/interface/assets/icons/notifications.svg',
        color: resources.colors.primary,
        click: (view) {

        }
    );
    messages = BrIcon(
        src: 'lib/interface/assets/icons/messages.svg',
        color: resources.colors.primary,
        click: (view) {

        }
    );
    share = BrIconButton(
      src: 'lib/interface/assets/icons/journal.svg',
      color: resources.colors.white,
      background: resources.colors.primary,
      elevation: 4,
      padding: 10,
      click: (view) {

      }
    );
  }
}