import 'package:beautyreformatory/interface/components/br_icon.dart';
import 'package:beautyreformatory/utilities/resources.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchLightroom extends StatefulWidget {
  SearchLightroom({Key key}) : super(key: key);

  @override
  _SearchLightroomState createState() => _SearchLightroomState();
}

class _SearchLightroomState extends State<SearchLightroom> {
  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 0,
      
      color: Color(0xFFEFEFEF),
      borderRadius: BorderRadius.circular(12.0),
      child: Container(
        height: 48,
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 4.0),

        child: Flex(
          direction: Axis.horizontal,
          children: <Widget>[
            Expanded(
              flex: 1,
              child: BrIcon(
                src: 'lib/interface/assets/icons/search.svg',
                size: 38,
                color: Colors.black54,
                click: (view) {}
              )
            ),
            Expanded(
              flex: 9,
              child: TextField(
                textInputAction: TextInputAction.search,

                decoration: InputDecoration(
                  border: InputBorder.none,
                  hasFloatingPlaceholder: false,
                  hintText: 'Search for an article',
                  hintStyle: TextStyle(
                    color: Colors.black54,
                    fontWeight: FontWeight.w500
                  )
                ),
              )
            )
          ],
        )
      )
    );
  }
}