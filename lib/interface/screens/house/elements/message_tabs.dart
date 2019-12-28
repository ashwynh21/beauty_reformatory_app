import 'package:beautyreformatory/interface/components/br_icon.dart';
import 'package:beautyreformatory/interface/components/br_tab_navigation.dart';
import 'package:beautyreformatory/interface/screens/house/messaging/messaging.dart';
import 'package:beautyreformatory/interface/screens/house/search/search.dart';
import 'package:beautyreformatory/utilities/resources.dart';
import 'package:flutter/material.dart';

class MessageTabs extends StatelessWidget {
  int tab;
  void Function(MessageTabs, int) ontab;

  MessageTabs({Key key,
    @required this.ontab,
    @required this.tab,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      margin: EdgeInsets.only(bottom: 24, right: 0),

      child: Stack(
        children: <Widget>[
          Container(
            alignment: Alignment.centerRight,
            child: Hero(
              tag: 'search',
              child: Container(
                width: 0,
                child: Material(
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(0), bottomLeft: Radius.circular(0)),
                    child: Container(
                      color: resources.colors.primary,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(right: 8),
            child: Flex(
              direction: Axis.horizontal,
              children: <Widget>[
                Expanded(
                  flex: 9,
                  child: BrTabNavigation(
                      tabs: ['inbox', 'friends', 'influencers'],
                      stream: Messaging.page_controller.stream,
                      ontab: (view, index) => ontab(this, index),
                      width: (MediaQuery.of(context).size.width - 8) * 9 / 10,
                      height: 52,
                      selected: tab,
                  ),
                ),
                Expanded(
                    flex: 1,
                  child: Container(
                    child: BrIcon(
                        src: 'lib/interface/assets/icons/search.svg',
                        color: resources.colors.primary,
                        click: (view) {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (BuildContext context, __, ___) => Search(),
                              transitionDuration: Duration(milliseconds: 320),
                            ),
                          );
                        }
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
