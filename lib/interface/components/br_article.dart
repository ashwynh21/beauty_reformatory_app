import 'package:beautyreformatory/interface/components/br_avatar.dart';
import 'package:beautyreformatory/interface/components/br_icon.dart';
import 'package:beautyreformatory/interface/screens/house/elements/media_count.dart';
import 'package:beautyreformatory/interface/screens/house/elements/participent_users.dart';
import 'package:beautyreformatory/services/middleware/user_middleware.dart';
import 'package:beautyreformatory/services/models/article.dart';
import 'package:beautyreformatory/services/models/user.dart';
import 'package:beautyreformatory/utilities/resources.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:timeago/timeago.dart' as timeago;

class BrArticle extends StatefulWidget {
  Article article;

  BrArticle({Key key,
    @required this.article
  }) : super(key: key);

  @override
  _BrArticleState createState() => _BrArticleState();
}

class _BrArticleState extends State<BrArticle> {

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04), blurRadius: 4.0, spreadRadius: 1.0, offset: Offset(0.0, 2.0)
          )
        ],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Material(
        borderRadius: BorderRadius.circular(16),
        color: Colors.transparent,
        child: Flex(
          direction: Axis.vertical,

          children: <Widget>[
            Container(
              height: 44,

              child: Flex(
                direction: Axis.horizontal,
                children: <Widget>[
                  Container(
                    width: 44,
                    height: 44,
                    child: BrAvatar(
                      src: widget.article.user.image,
                      size: 44,
                      radius: 22,
                    )
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      margin: EdgeInsets.only(left: 16),
                      child: Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Text(
                                  widget.article.user.fullname,
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 4.0),
                            child: Row(
                              children: <Widget>[
                                Container(
                                    child: Text(
                                        widget.article.user.handle,
                                      style: TextStyle(
                                        color: Colors.black26,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w300,
                                      )
                                    )
                                ),
                                Container(
                                  margin: EdgeInsets.all(4.0),
                                  child: Material(
                                    borderRadius: BorderRadius.circular(2.0),
                                    color: Colors.black12,
                                    child: Container(
                                      width: 4,
                                      height: 4,
                                    )
                                  ),
                                ),
                                Container(
                                  child: Text(
                                    timeago.format(DateTime.parse(widget.article.date['date'])),
                                      style: TextStyle(
                                        color: Colors.black26,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w300,
                                      )
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      )
                    )
                  ),
                  Container(
                      width: 32,
                      height: 32,
                      child: BrIcon(
                        src: 'lib/interface/assets/icons/bookmark.svg',
                        background: resources.colors.primary,
                        color: Colors.white,
                        size: 32,
                        click: (view) {}
                      )
                  ),
                ],
              )
            ),
            Container(
              margin: EdgeInsets.only(top: 24),
              child: Flex(
                direction: Axis.horizontal,
                crossAxisAlignment: CrossAxisAlignment.start,
                
                children: <Widget>[
                  Container(
                    width: 24,
                    height: 24,
                    
                    child: SvgPicture.asset('lib/interface/assets/icons/quotes.svg', color: Colors.black.withOpacity(0.08),)
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      margin: EdgeInsets.only(left: 12),
                      decoration: BoxDecoration(
                          border: Border(left: BorderSide(color: Colors.black26.withOpacity(0.08), width: 2.0))
                      ),
                      child: Container(
                        margin: EdgeInsets.only(left: 12),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,

                          children: <Widget>[
                            Container(
                              child: Text(
                                widget.article.title,
                                style: TextStyle(
                                  color: Colors.black.withOpacity(0.64),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              )
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 4.0),
                                child: Text(
                                  widget.article.description.length > 256 ? widget.article.description.substring(0, 256) + '...' : widget.article.description,
                                  style: TextStyle(
                                    color: Colors.black.withOpacity(0.32),
                                    fontSize: 12,
                                    height: 1.64,
                                    fontWeight: FontWeight.w300,
                                  ),
                                )
                            ),
                          ],
                        ),
                      ),
                    )
                  )
                ],
              )
            ),
            Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.only(top: 12),

                child: FutureBuilder<User>(
                  future: UserMiddleware.fromSave(),
                  builder: (context, user) {
                    if(user.hasData) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          ParticipentUsers(article: widget.article, user: user.data),
                          MediaCount(article: widget.article, user: user.data)
                        ],
                      );
                    }
                    return Container();
                  }
                )
            ),
            Container(
              margin: EdgeInsets.only(top: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),

                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(color: Colors.black12.withOpacity(0.08), offset: Offset(0.0, 2.0), blurRadius: 2.0,)
                      ]
                    ),

                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        height: 40,
                        width: 144,

                        child: Row(
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(left: 4),
                                width: 36,
                                height: 36,
                                child: BrIcon(
                                    src: 'lib/interface/assets/icons/heart.svg',
                                    background: Colors.white,
                                    color: resources.colors.primary,
                                    size: 36,
                                    click: (view) {}
                                )
                            ),
                            Container(
                                child: Text(
                                    'react',
                                    style: TextStyle(
                                      color: resources.colors.primary,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                    )
                                )
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 8),
                                child: Text(
                                    '12k',
                                    style: TextStyle(
                                      color: Colors.black54,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w400,
                                    )
                                )
                            ),
                            Container(
                              height: 24,
                              width: 1,
                              decoration: BoxDecoration(
                                color: Colors.black26,
                                borderRadius: BorderRadius.circular(1)
                              ),
                            ),
                            Container(
                                margin: EdgeInsets.only(left: 4),
                                width: 36,
                                height: 36,
                                child: BrIcon(
                                    src: 'lib/interface/assets/icons/comment.svg',
                                    background: Colors.amber,
                                    color: Colors.white,
                                    size: 32,
                                    click: (view) {}
                                )
                            ),
                          ],
                        )
                      )
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),

                        color: resources.colors.primary,
                        boxShadow: [
                          BoxShadow(color: Colors.black12.withOpacity(0.12), offset: Offset(0.0, 2.0), blurRadius: 2.0,)
                        ]
                    ),

                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Material(
                          color: resources.colors.primary,

                          child: InkWell(
                            onTap: () {},
                            child: Container(
                                height: 40,
                                width: 128,

                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                        child: Text(
                                            'read full article',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          textAlign: TextAlign.center,
                                        )
                                    ),
                                  ],
                                )
                            ),
                          ),
                        )
                    ),
                  )
                ],
              )
            )
          ],
        ),
      ),
    );
  }
}