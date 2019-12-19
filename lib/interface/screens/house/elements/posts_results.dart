import 'package:flutter/material.dart';
import 'package:beautyreformatory/utilities/resources.dart';

class PostsResults extends StatelessWidget {
  Stream<List<Map>> stream;

  PostsResults({Key key,
    @required this.stream,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Object>(
      stream: stream,
      builder: (context, snapshot) {
        if(snapshot.hasData){
          return Container(
            width: double.infinity,

            child: Column(
              children: <Widget>[
                Container(
                    height: 36,
                    color: resources.colors.primary.withOpacity(0.64),
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.only(left: 20),
                    child: Text('posts',
                      style: TextStyle(
                          color: Colors.white
                      ),
                    )
                ),
                Container(height: 1, width: double.infinity, color: Colors.white)
              ],
            ),
          );
        }

        return Container();
      }
    );
  }
}
