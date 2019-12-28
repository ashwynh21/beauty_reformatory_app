import 'dart:math';

import 'package:beautyreformatory/services/controllers/message_controller.dart';
import 'package:beautyreformatory/services/middleware/message_middleware.dart';
import 'package:beautyreformatory/services/middleware/user_middleware.dart';
import 'package:beautyreformatory/services/models/message.dart';
import 'package:beautyreformatory/services/models/user.dart';
import 'package:beautyreformatory/utilities/environment.dart';
import 'package:beautyreformatory/utilities/resources.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BrChatItem extends StatefulWidget {
  Message message;
  bool origin;

  BrChatItem({Key key,
    @required this.message,
    this.origin = true,
  }) : super(key: key);

  @override
  _BrChatItemState createState() => _BrChatItemState();
}

class _BrChatItemState extends State<BrChatItem> {

  @override
  void initState() {
    if(widget.message.state == sending){
      UserMiddleware.fromSave().then((User u) {
        MessageController().resend(email: u.email, token: u.token, friend: widget.message.recipient.email, message: widget.message).then((Message message) {
          if(message != null) {
            setState(() {
              widget.message = message;
            });
          }
        }).catchError((error) {
          setState(() {});
        });
      });
    }

    if(widget.message.state != read){
      UserMiddleware.fromSave().then((User u) {
        if(u.id == widget.message.recipient.id){
          widget.message.state = read;
          MessageMiddleware.toSave(widget.message);
          MessageController().read(email: u.email, token: u.token, message: widget.message);
          setState(() {});
        }
      });
    }

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        onTap: () {},

        splashColor: resources.colors.light.withOpacity(0.04),
        highlightColor: resources.colors.light.withOpacity(0.24),

        child: Container(

          child: Stack(
            alignment: (widget.origin) ? Alignment.bottomRight : Alignment.bottomLeft,
            children: <Widget>[
              Container(
                margin: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                height: findheight(),
                width: double.infinity,

                child: CustomPaint(
                    painter: ChatBubble(
                      color: (widget.origin) ? resources.colors.chat : resources.colors.recipient,
                      width: findwidth() + 28,
                      height: findheight(),
                      direction: widget.origin
                    )
                ),
              ),
              /*
              The actual message is here
               */
              Container(
                width: findwidth(),
                margin: EdgeInsets.only(right: 26, left: 28, bottom: 16),

                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.end,
                  runAlignment: WrapAlignment.end,
                  alignment: WrapAlignment.end,
                  children: <Widget>[
                    Container(
                      alignment: Alignment.topLeft,
                      width: findmessagewidth(),

                      child: Text(
                        widget.message.message,
                        style: TextStyle(
                          height: 1.4
                        ),
                      ),
                    ),
                    /*
                    The time in which the message was sent will be here.
                     */
                    Container(
                      width: findtimewidth(),
                      padding: EdgeInsets.only(left: 12,),
                      
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            child: Text(
                              (DateTime.parse(widget.message.date['date'])).hour.toString().padLeft(2, '0') + ':' + (DateTime.parse(widget.message.date['date'])).minute.toString().padLeft(2, '0'),
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.black54,
                                height: 1.64,
                              ),
                              textAlign: TextAlign.end,
                            ),
                          ),
                          (widget.origin) ?
                          Container(
                            margin: EdgeInsets.only(left: 8),
                            child: SvgPicture.asset(
                              statetostring(),
                              height: 14,
                              width: 14,
                              fit: BoxFit.contain,
                              color: Colors.black45,
                            )
                          )
                              :
                              Container()
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      )
    );
  }

  /*
  Since we using a custom painted bubble we need to find a way to properly
  dimension the bubble as responsively as possible by considering all the
  components that will be hosted in the bubble. For this to work we can create
  a function to calculate these dimensions.
   */
  double findwidth() {
    return findmessagewidth() + findtimewidth() - ((widget.message.message.length <= 24) ? 0 : 92);
  }
  double findheight() {
    return findmessageheight() + ((widget.message.message.length <= 24) ? 0 : findtimeheight());
  }
  double findmessagewidth() {

    return 8.0 + ((widget.message.message.length <= 40) ? widget.message.message.length * 7.6 : 40.0 * 7.6);
  }
  double findmessageheight() {
    /*
    Recall that we must consider the effect of new line characters
     */
    return 16.0 + ((widget.message.message.length / 44.0).ceil() + (widget.message.message.split('\n').length - 1)) * 21.54;
  }
  /*
  Now we make functions that will calculate the date or timestamp size
   */
  double findtimewidth() {
    String time = (DateTime.parse(widget.message.date['date'])).hour.toString().padLeft(2, '0') + ':' + (DateTime.parse(widget.message.date['date'])).minute.toString().padLeft(2, '0');

    return time.length * 6.6 + ((widget.origin) ? 34.0 : 16.0);
  }
  double findtimeheight() {
    return 24;
  }

  String statetostring() {
    switch(widget.message.state) {
      case sent:
        return 'lib/interface/assets/icons/sent.svg';
      case recieved:
      return 'lib/interface/assets/icons/recieved.svg';
      case read:
        return 'lib/interface/assets/icons/recieved.svg';
      case delivered:
        return 'lib/interface/assets/icons/recieved.svg';
      default:
        return 'lib/interface/assets/icons/clock.svg';
    }
  }
}

/*
Here we are going to create a custom shape for the chat bubble. We could SVG
but the prblem would be how it scales across variations of aspect ratios.
 */
class ChatBubble extends CustomPainter {
  Color color;
  double width, height;
  bool direction;

  ChatBubble({
    @required this.color,
    this.height = 160,
    this.width = 160,
    this.direction = true,
  });

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..style = PaintingStyle.fill
      ..color = color
      ..isAntiAlias = true;

    List<Point> bubble = (direction) ? [
      Point(size.width, 0.0),
      Point(size.width - width, 0.0),
      Point(size.width - width, size.height),
      Point(size.width - 10.0, size.height),
      Point(size.width - 10.0, 12.0),
    ] : [
      Point(0.0, 0.0),
      Point(width, 0.0),
      Point(width, size.height),
      Point(10.0, size.height),
      Point(10.0, 12.0),
    ];

    var path = Path();
    bubble.add(bubble[0]);
    bubble.add(bubble[1]);
    var p0 = _LineInterCircle.intersectionPoint(bubble[1], bubble[0], 8.0);
    path.moveTo(p0.x, p0.y);
    for (int i = 0; i < bubble.length - 2; i++) {
      var p1 = bubble[i];
      var p2 = bubble[i + 1];
      var p3 = bubble[i + 2];

      switch(i) {
        case 3:
          makearc([p1, p2, p3], path, clockwise: direction, distance: 2, circularity: 2.0);
          break;
        case 4:
          makearc([p1, p2, p3], path, clockwise: !direction, distance: 4, circularity: 0.5);
          break;
        default:
          makearc([p1, p2, p3], path, clockwise: !direction, circularity: 1, distance: 8.0);
          break;
      }
    }

    canvas.drawShadow(path, Colors.black54, 3.2, true);
    canvas.drawPath(path, paint);

    canvas.save();
    canvas.restore();
  }
  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

  void makearc(List<Point> points, Path path, {double distance = 8.0, double circularity = 0.5, bool clockwise = true}) {
    assert (points.length == 3);

    var interP1 = _LineInterCircle.intersectionPoint(points[0], points[1], distance);
    var interP2 = _LineInterCircle.intersectionPoint(points[2], points[1], distance);

    path.lineTo(interP1.x, interP1.y);
    path.arcToPoint(
        Offset(interP2.x, interP2.y),
        radius: Radius.circular(distance * circularity),
        clockwise: clockwise
    );
  }
}

class _Line {
  ///y = kx + c
  static double normalLine(x, {k = 0, c = 0}) {
    return k * x + c;
  }

  ///Calculate the param K in y = kx +c
  static double paramK(Point p1, Point p2) {
    if (p1.x == p2.x) return 0;
    return (p2.y - p1.y) / (p2.x - p1.x);
  }

  ///Calculate the param C in y = kx +c
  static double paramC(Point p1, Point p2) {
    return p1.y - paramK(p1, p2) * p1.x;
  }
}
class _LineInterCircle {
  /// start point p1, end point p2,p2 is center of the circle,r is its radius.
  /// param a: y = kx +c intersect with circle,which has the center with point2 and radius R .
  /// when derive to x2+ ax +b = 0 equation. the param a is here.
  static double paramA(Point p1, Point p2) {
    return (2 * _Line.paramK(p1, p2) * _Line.paramC(p1, p2) -
        2 * _Line.paramK(p1, p2) * p2.y -
        2 * p2.x) /
        (_Line.paramK(p1, p2) * _Line.paramK(p1, p2) + 1);
  }

  /// start point p1, end point p2,p2 is center of the circle,r is its radius.
  /// param b: y = kx +c intersect with circle,which has the center with point2 and radius R .
  /// when derive to x2+ ax +b = 0 equation. the param b is here.
  static double paramB(Point p1, Point p2, double r) {
    return (p2.x * p2.x -
        r * r +
        (_Line.paramC(p1, p2) - p2.y) * (_Line.paramC(p1, p2) - p2.y)) /
        (_Line.paramK(p1, p2) * _Line.paramK(p1, p2) + 1);
  }

  ///the circle has the intersection or not
  static bool isIntersection(Point p1, Point p2, double r) {
    var delta = sqrt(paramA(p1, p2) * paramA(p1, p2) - 4 * paramB(p1, p2, r));
    return delta >= 0.0;
  }

  ///the x coordinate whether or not is between two point we give.
  static bool _betweenPoint(x, Point p1, Point p2) {
    if (p1.x > p2.x) {
      return x > p2.x && x < p1.x;
    } else {
      return x > p1.x && x < p2.x;
    }
  }

  static Point _equalX(Point p1, Point p2, double r) {
    if (p1.y > p2.y) {
      return Point(p2.x, p2.y + r);
    } else if (p1.y < p2.y) {
      return Point(p2.x, p2.y - r);
    } else {
      return p2;
    }
  }

  static Point _equalY(Point p1, Point p2, double r) {
    if (p1.x > p2.x) {
      return Point(p2.x + r, p2.y);
    } else if (p1.x < p2.x) {
      return Point(p2.x - r, p2.y);
    } else {
      return p2;
    }
  }

  ///intersection point
  static Point intersectionPoint(Point p1, Point p2, double r) {
    if (p1.x == p2.x) return _equalX(p1, p2, r);
    if (p1.y == p2.y) return _equalY(p1, p2, r);
    var delta = sqrt(paramA(p1, p2) * paramA(p1, p2) - 4 * paramB(p1, p2, r));
    if (delta < 0.0) {
      //when no intersection, i will return the center of the circ  le.
      return p2;
    }
    var a_2 = -paramA(p1, p2) / 2.0;
    var x1 = a_2 + delta / 2;
    if (_betweenPoint(x1, p1, p2)) {
      var y1 = _Line.paramK(p1, p2) * x1 + _Line.paramC(p1, p2);
      return Point(x1, y1);
    }
    var x2 = a_2 - delta / 2;
    var y2 = _Line.paramK(p1, p2) * x2 + _Line.paramC(p1, p2);
    return Point(x2, y2);
  }
}