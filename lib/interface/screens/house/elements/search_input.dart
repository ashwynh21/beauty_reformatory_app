import 'package:beautyreformatory/interface/components/br_icon.dart';
import 'package:flutter/material.dart';
import 'package:beautyreformatory/utilities/resources.dart';

class SearchInput extends StatelessWidget {
  void Function(SearchInput, String) change;
  void Function(SearchInput, String) submit;

  String value;

  SearchInput({Key key,
    @required this.change,
    @required this.submit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      height: 52,
      margin: EdgeInsets.only(top: 80),

      child: Material(
        color: Colors.transparent,
        child: Stack(
          alignment: Alignment.centerRight,
          children: <Widget>[
            Hero(
              tag: 'search',
              child: Container(
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
            Flex(
              direction: Axis.horizontal,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  flex: 4,
                  child: Container(
                    height: 36,
                    width: 36,

                    child: BrIcon(
                        src: 'lib/interface/assets/icons/back.svg',
                        color: Colors.white,
                        click: (view) {
                          Navigator.of(context).pop();
                        }
                    ),
                  ),
                ),
                Expanded(
                  flex: 20,
                  child: Container(
                    child: TextField(
                      autofocus: true,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.only(bottom: 20),
                        labelText: 'search',
                        labelStyle: TextStyle(
                          color: Colors.white.withOpacity(0.64),
                          letterSpacing: 0,
                        ),
                        hasFloatingPlaceholder: false,
                        alignLabelWithHint: true,
                      ),
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16
                      ),
                      cursorColor: Colors.white,
                      textInputAction: TextInputAction.search,
                      onChanged: (String value) {
                        /*
                        Here we will be running the dynamic search functionality that will perform
                        searching as the user types. Here we need to keep the results light weight
                        and functional.

                        We will have to get some resources on how to model search results on both
                        the client application as well as on the API layer.
                         */

                        /*
                        Here we will run a search on all the categories of search results that we have placed.
                         */
                        this.value = value;
                        change(this, value);
                      },
                      onSubmitted: (value) {
                        this.value = value;
                        submit(this, value);
                      },
                    ),
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: Container(
                    alignment: Alignment.centerRight,
                    child: Container(
                      margin: EdgeInsets.only(right: 8),
                      width: 40,
                      child: BrIcon(
                          src: 'lib/interface/assets/icons/search.svg',
                          color: Colors.white,
                          click: (view) {
                            submit(this, value);
                          }
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}