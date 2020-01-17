import 'package:beautyreformatory/interface/components/br_article.dart';
import 'package:beautyreformatory/services/middleware/article_middleware.dart';
import 'package:beautyreformatory/services/middleware/user_middleware.dart';
import 'package:beautyreformatory/services/models/article.dart';
import 'package:beautyreformatory/services/models/user.dart';
import 'package:flutter/material.dart';

class MentalHealth extends StatefulWidget {
  MentalHealth({Key key}) : super(key: key);

  @override
  _MentalHealthState createState() => _MentalHealthState();
}

class _MentalHealthState extends State<MentalHealth> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,

      child: Container(

        child: FutureBuilder<List<Article>>(
          future: ArticleMiddleware.listFromSave(),
          builder: (context, articles) {
            return FutureBuilder<User>(
              future: UserMiddleware.fromSave(),
              builder: (context, user) {
                if(user.hasData && articles.hasData && articles.data.length > 0) {
                  return ListView.builder(
                    itemCount: articles.data.length,
                    itemBuilder: (BuildContext context, index) {
                      return Container(
                        margin: EdgeInsets.only(bottom: (index == articles.data.length - 1) ? 80 : 0),
                        child: BrArticle(
                          article: articles.data[index]
                        ),
                      );
                    },
                  );
                }
                return Container();
              }
            );
          }
        )
      )
    );
  }
}