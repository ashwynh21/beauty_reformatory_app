import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:beautyreformatory/utilities/validators.dart';

class BrAvatar extends StatefulWidget {
  double elevation, size, frame, radius;
  String src, hero;
  Color stroke;

  void Function(BrAvatar) click;

  BrAvatar({Key key,
    @required this.src,
    this.size,
    this.frame = 0,
    this.elevation = 0,
    this.stroke = Colors.white,
    this.radius = 0,
    this.hero,
    this.click,
  }) : super(key: key);

  @override
  _BrAvatarState createState() => _BrAvatarState();
}

class _BrAvatarState extends State<BrAvatar> {
  @override
  Widget build(BuildContext context) {
    return rescue();
  }

  Widget rescue() {
    return (widget.hero == null)
        ?
    Material(
        elevation: widget.elevation,
        borderRadius: BorderRadius.circular(widget.radius),
        color: Colors.transparent,

        child: ClipRRect(
          borderRadius: BorderRadius.circular(widget.radius),

          child: Container(
            height: widget.size,
            width: widget.size,
            alignment: Alignment.center,
            color: widget.stroke,

            child: ClipRRect(
              borderRadius: BorderRadius.circular(widget.radius),
              child: Material(
                  child: InkWell(
                    onTap: () => widget.click != null ? widget.click(widget) : false,
                    child: Container(
                      height: widget.size - widget.frame,
                      width: widget.size - widget.frame,
                      alignment: Alignment.center,

                      child: Container(
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                image: image(widget.src)
                            )
                        ),
                      ),
                    ),
                  )
              ),
            ),
          ),
        )
    )
        :
    Material(
      elevation: widget.elevation,
      borderRadius: BorderRadius.circular(widget.radius),
      color: Colors.transparent,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(widget.radius),
        child: Material(
          child: InkWell(
            onTap: () => widget.click != null ? widget.click(widget) : false,
            child: Container(
              height: widget.size,
              width: widget.size,
              alignment: Alignment.center,
              color: widget.stroke,

              child: ClipRRect(
                borderRadius: BorderRadius.circular(widget.radius),
                child: Container(
                  height: widget.size - widget.frame,
                  width: widget.size - widget.frame,
                  alignment: Alignment.center,
                  child: Container(
                    alignment: Alignment.center,
                    child: herowidget(),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
  Hero herowidget() {
    return Hero(
      tag: widget.hero,
      child: Container(
        height: widget.size,
        width: widget.size,

        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
            fit: BoxFit.cover,
            image: image(widget.src)
          )
        ),
      ),
    );
  }
  ImageProvider image(String image) {
    if(image != null) {
      if (isURL(image)) {
        return Image.network(image, fit: BoxFit.fitWidth,
          alignment: Alignment.center,).image;
      } else {
        try{
          return Image.memory(base64Decode(image), fit: BoxFit.fitWidth,
            alignment: Alignment.center,).image;
        } catch(e) {
          return Image.asset(image, fit: BoxFit.fitWidth,
            alignment: Alignment.center,).image;
        }
      }
    } else {
      return null;
    }
  }
}