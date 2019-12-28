import 'package:beautyreformatory/utilities/resources.dart';
import 'package:flutter/material.dart';

import 'br_avatar.dart';

class BrAvatarButton extends StatelessWidget {
  double width, height;
  String src, hero;
  Future Function(BrAvatarButton) click;

  BrAvatarButton({Key key,
    @required this.src,
    @required this.click,
    this.width = 64,
    this.height: 40,
    this.hero
  });
  
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(height / 2.0),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(height / 2.0),
        child: InkWell(
          splashColor: Colors.white.withOpacity(0.12),
          highlightColor: Colors.white.withOpacity(0.24),
          onTap: () => click(this),
          child: Container(
            padding: EdgeInsets.all(2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Icon(Icons.arrow_back, color: Colors.white,),
                BrAvatar(
                  src: src,
                  elevation: 0,
                  frame: 2,
                  stroke: Colors.white,
                  size: height - 4,
                  radius: (height - 4) / 2,
                  hero: hero,
                  click: (view) => click(this),
                )
              ],
            )
          )
        ),
      ),
    );
  }
}
