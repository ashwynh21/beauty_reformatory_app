import 'dart:convert';

import 'package:beautyreformatory/interface/components/br_avatar.dart';
import 'package:beautyreformatory/interface/components/br_icon.dart';
import 'package:beautyreformatory/interface/components/br_icon_button.dart';
import 'package:beautyreformatory/interface/components/br_tab_navigation.dart';
import 'package:beautyreformatory/interface/dialogs/br_edit_field_dialog.dart';
import 'package:beautyreformatory/interface/dialogs/br_select_image_source_dialog.dart';
import 'package:beautyreformatory/interface/screens/house/image/image_viewer.dart';
import 'package:beautyreformatory/services/controllers/user_controller.dart';
import 'package:beautyreformatory/services/middleware/friendship_middleware.dart';
import 'package:beautyreformatory/services/middleware/user_middleware.dart';
import 'package:beautyreformatory/services/models/friendship.dart';
import 'package:beautyreformatory/services/models/user.dart';
import 'package:beautyreformatory/utilities/dialogs.dart';
import 'package:beautyreformatory/utilities/resources.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfileTopNavigation extends StatefulWidget {


  ProfileTopNavigation({Key key}) : super(key: key);

  @override
  _ProfileTopNavigationState createState() => _ProfileTopNavigationState();
}

class _ProfileTopNavigationState extends State<ProfileTopNavigation> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      elevation: 8,
      shadowColor: Colors.black12,

      child: Container(
        height: 320,
        alignment: Alignment.center,
        child: Stack(
          alignment: Alignment.center,

          children: <Widget>[
            Image.asset('lib/interface/assets/images/background.png',),
            StreamBuilder(
              stream: UserController.stream.stream,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if(snapshot.hasData)
                  return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,

                  children: <Widget>[
                    /*
                    User's avatar is here
                     */
                    Container(
                      margin: EdgeInsets.only(top: 24, bottom: 12),

                      child: Stack(
                        alignment: Alignment.bottomRight,
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder: (BuildContext context, __, ___) => ImageViewer(
                                      title: 'Profile picture',
                                      src: snapshot.data.image,
                                      hero: 'avatar',
                                      callback: (view, source, remove) async {
                                        setState(() {
                                          loader.show(true);
                                        });

                                        snapshot.data.image = (remove) ? base64Encode((await DefaultAssetBundle.of(context).load('lib/interface/assets/images/default_avatar.png')).buffer.asUint8List()) : source;

                                        UserController().update(
                                            email: snapshot.data.email,
                                            token: snapshot.data.token,
                                            image: (remove) ? '' : snapshot.data.image,
                                        ).then((User user) async {
                                          if(user != null){

                                            UserMiddleware.toSave(snapshot.data).then((_){
                                              snack.show('Hey, your profile has been updated!');
                                              setState(() {
                                                loader.show(false);
                                              });
                                            });
                                          }
                                        }).catchError((error) {
                                          snack.show(error.message);
                                          setState(() {
                                            loader.show(false);
                                          });
                                        });
                                      },
                                    ),
                                    transitionDuration: Duration(milliseconds: 512),
                                  ),
                              );
                            },
                            child: BrAvatar(
                              src: snapshot.data.image,
                              elevation: 4,
                              size: 128,
                              radius: 64,
                              frame: 8,
                              hero: 'avatar',
                              stroke: resources.colors.light.withOpacity(0.64),
                            ),
                          ),
                          Container(
                            width: 40,
                            height: 40,
                            child: BrIconButton(
                              src: 'lib/interface/assets/icons/camera.svg',
                              color: Colors.white,
                              background: resources.colors.secondary,
                              padding: 10,
                              click: (view) {

                                dialogs.selectsource(context,
                                    title: 'Profile picture',
                                    callback: (BrSelectImageSourceDialog dialog, String source, bool remove) async {
                                      setState(() {
                                        loader.show(true);
                                      });

                                      snapshot.data.image = (remove) ? base64Encode((await DefaultAssetBundle.of(context).load('lib/interface/assets/images/default_avatar.png')).buffer.asUint8List()) :  source;

                                      UserController().update(
                                        email: snapshot.data.email,
                                        token: snapshot.data.token,
                                        image: (remove) ? '' : snapshot.data.image,
                                      ).then((User user) async {
                                        if(user != null){

                                          UserMiddleware.toSave(snapshot.data).then((_){
                                            snack.show('Hey, your profile has been updated!');
                                            setState(() {
                                              loader.show(false);
                                            });
                                          });
                                        }
                                      }).catchError((error) {
                                        snack.show(error.message);
                                        setState(() {
                                          loader.show(false);
                                        });
                                      });
                                    }
                                );

                              },
                            ),
                          )
                        ],
                      ),
                    ),

                    /*
                    User's full name is here
                     */
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 12),
                      child: Flex(
                        direction: Axis.horizontal,
                        children: <Widget>[
                          Expanded(
                            flex: 9,

                            child: Container(
                              margin: EdgeInsets.only(left: 46),
                              alignment: Alignment.center,
                              child: Text(snapshot.data.fullname,
                                  style: TextStyle(
                                    color: Colors.black87.withOpacity(0.64),
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,

                            child: Container(
                              child: BrIcon(
                                src: 'lib/interface/assets/icons/pencil.svg',
                                color: Colors.black26,
                                size: 36,
                                click: (view) {

                                  dialogs.editfield(context,
                                      placeholder: 'Fullname',
                                      value: snapshot.data.fullname,
                                      icon: 'lib/interface/assets/flares/avatar_icon.flr',
                                      instruction: 'Enter your fullname',
                                      callback: (BrEditFieldDialog dialog, String value) {
                                        setState(() {
                                          loader.show(true);
                                        });

                                        return UserController().update(
                                          email: snapshot.data.email,
                                          token: snapshot.data.token,
                                          fullname: value,
                                        ).then((User user) {
                                          if(user != null){
                                            UserMiddleware.toSave(snapshot.data).then((_){
                                              snack.show('Hey, your profile has been updated!');
                                              setState(() {
                                                loader.show(false);
                                              });
                                            });
                                          }
                                        }).catchError((error) {
                                          snack.show(error.message);
                                          setState(() {
                                            loader.show(false);
                                          });
                                        });
                                      }
                                  );
                                },
                              ),
                            ),
                          )
                        ],
                      ),
                    ),

                    /*
                    User's handle is here
                     */
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 12),
                      child: Flex(
                        direction: Axis.horizontal,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Expanded(
                            flex: 9,

                            child: Container(
                              margin: EdgeInsets.only(left: 46),
                              alignment: Alignment.center,
                              child: Text(snapshot.data.handle,
                                  style: TextStyle(
                                    color: Colors.black26,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w300,
                                  )
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,

                            child: BrIcon(
                              src: 'lib/interface/assets/icons/pencil.svg',
                              color: Colors.black26,
                              size: 36,
                              click: (view) {
                                dialogs.editfield(context,
                                    placeholder: 'Handle',
                                    value: (snapshot.data.handle.toString().contains('@')) ? snapshot.data.handle.toString().split('@')[1] : snapshot.data.handle.toString(),
                                    icon: 'lib/interface/assets/icons/at.svg',
                                    instruction: 'Enter your handle',
                                    callback: (BrEditFieldDialog dialog, String value) {
                                      setState(() {
                                        loader.show(true);
                                      });

                                      return UserController().update(
                                        email: snapshot.data.email,
                                        token: snapshot.data.token,
                                        handle: '@' + value,
                                      ).then((User user) {
                                        if(user != null){
                                          UserMiddleware.toSave(snapshot.data).then((_){
                                            snack.show('Hey, your profile has been updated!');
                                            setState(() {
                                              loader.show(false);
                                            });
                                          });
                                        }
                                      }).catchError((error) {
                                        snack.show(error.message);
                                        setState(() {
                                          loader.show(false);
                                        });
                                      });
                                    }
                                  );
                              },
                            ),
                          )
                        ],
                      ),
                    ),

                    /*
                    User's friends is gotten and displayed here
                     */
                    FutureBuilder(
                      future: (FriendshipMiddleware.listFromSave()),
                      builder: (BuildContext context, AsyncSnapshot<List<Friendship>> friendships) {
                        if(friendships.connectionState == ConnectionState.done) {
                          return Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,

                              children: <Widget>[
                                Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,

                                  children: friendships.data.map((f) {
                                    if(f.initiator.id != snapshot.data.id) {
                                      return Transform.translate(
                                        offset: Offset(-12.0 * (friendships.data.length - friendships.data.indexOf(f)), 0),

                                        child: BrAvatar(
                                          src: f.initiator.image,
                                          elevation: 2,
                                          frame: 4,
                                          stroke: Colors.white,
                                          size: 32,
                                          radius: 16,
                                        ),
                                      );
                                    } else {
                                      return Transform.translate(
                                        offset: Offset(-12.0 * (friendships.data.length - friendships.data.indexOf(f)), 0),

                                        child: BrAvatar(
                                          src: f.subject.image,
                                          elevation: 4,
                                          size: 32,
                                          frame: 4,
                                          stroke: Colors.white,
                                          radius: 16,
                                        ),
                                      );
                                    }
                                  }).toList().sublist(0, friendships.data.length > 4 ? 4 : friendships.data.length)
                                ),
                                Container(
                                  width: 80,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      (friendships.data.length > 1) ?
                                      Text(friendships.data.length.toString(),
                                          style: TextStyle(
                                            color: Colors.black54,
                                            fontSize: 10,
                                            fontWeight: FontWeight.w400,
                                          )
                                      )
                                          : Container(),
                                      Text((friendships.data.length > 1) ? 'in circles' : 'none in circles',
                                          style: TextStyle(
                                            color: Colors.black54,
                                            fontSize: 11,
                                            fontWeight: FontWeight.w400,
                                          )
                                      ),
                                    ],
                                  )
                                )
                              ],
                            ),
                          );
                        }
                        return Container();
                      }
                    ),

                    /*
                    The profile navigation tabs will go here
                     */
                    Container(
                      margin: EdgeInsets.only(top: 8),

                      child: BrTabNavigation(
                        tabs: ['profile info.', 'posts & content', 'goals & affirmations'],
                      )
                    )
                  ],
                );

                return Container();
              },
            )
          ],
        ),
      ),
    );
  }
}