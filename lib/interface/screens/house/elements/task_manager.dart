import 'package:beautyreformatory/interface/components/br_icon.dart';
import 'package:beautyreformatory/interface/components/br_icon_button.dart';
import 'package:beautyreformatory/services/models/goal.dart';
import 'package:beautyreformatory/services/models/task.dart';
import 'package:beautyreformatory/utilities/dialogs.dart';
import 'package:beautyreformatory/utilities/resources.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

import 'dart:math' as Math;

class TaskManager extends StatefulWidget {
  List<Task> tasks = [
  ];
  List<Goal> goals = [
  ];

  TaskManager({Key key}) : super(key: key);

  @override
  _TaskManagerState createState() => _TaskManagerState();
}

class _TaskManagerState extends State<TaskManager> {
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(top: 320),
        /*
        This section of the application will support the goals and tasks forms that the user
        will use to access the data input on tasks.
         */
        child: ListView.builder(
            itemCount: widget.tasks.length + 2,
            itemBuilder: (context, t) {

              if(t == 0)
                return Container(
                    margin: EdgeInsets.symmetric(vertical: 12, horizontal: 24),

                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,

                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                                width: 256,
                                height: 40,
                                padding: EdgeInsets.only(left: 12),
                                alignment: Alignment.centerLeft,

                                child: Text(
                                    'Task & goal manager',
                                    style: TextStyle(
                                      color: Colors.black.withOpacity(0.64),
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    )
                                )
                            ),
                            Container(
                                margin: EdgeInsets.only(left: 12),
                                child: Text(
                                  DateTime.now().day.toString() + '/' + DateTime.now().month.toString() + ' - ' + DateFormat('EEEE').format(DateTime.now()),
                                  style: TextStyle(
                                    color: resources.colors.light,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                )
                            )
                          ],
                        ),
                        Container(
                            child: BrIconButton(
                                size: 36,
                                padding: 10,
                                radius: 16,
                                src: 'lib/interface/assets/icons/add.svg',
                                color: Colors.white,
                                background: resources.colors.primary,
                                click: (view) {
                                  dialogs.taskselect(context, (view, side) {
                                    if(side) {

                                    }

                                    return side;
                                  });
                                }
                            )
                        )
                      ],
                    )
                );
              if(t == 1)
                return Container(
                    margin: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          child: Text(
                            ((widget.goals..removeWhere((t) => (t.due['date'] as DateTime).day != DateTime.now().day && t.completed)).length + (widget.tasks..removeWhere((t) => (t.due['date'] as DateTime).day != DateTime.now().day && t.completed)).length).toString()
                                + ' tasks & goals due today',
                            style: TextStyle(
                              color: Colors.black.withOpacity(0.32),
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        Container(
                            child: BrIcon(
                              src: 'lib/interface/assets/icons/calendar.svg',
                              color: resources.colors.light,
                              click: (_) {},
                            )
                        )
                      ],
                    )
                );

              return Dismissible(
                key: new GlobalKey(),
                direction: DismissDirection.endToStart,
                dismissThresholds: {
                  DismissDirection.endToStart: 0.32,
                },

                background: Container(

                  decoration: BoxDecoration(
                    color: Colors.transparent,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Container(
                          height: 28,
                          width: 28,
                        padding: EdgeInsets.all(8.0),

                        margin: EdgeInsets.only(right: 24),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: resources.colors.light)
                        ),

                        child: SvgPicture.asset(
                          'lib/interface/assets/icons/done.svg',
                          color: resources.colors.light,
                          fit: BoxFit.contain,
                          height: 12,
                          width: 12
                        )
                      )
                    ],
                  )
                ),

                child:
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Container(
                        height: 64,

                        margin: EdgeInsets.symmetric(horizontal: 32,),

                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(color: resources.colors.primary.withOpacity(0.16), offset: Offset(2.0, 2.0), blurRadius: 2.0),
                            BoxShadow(color: resources.colors.light.withOpacity(0.08), offset: Offset(-2.0, -2.0), blurRadius: 2.0),
                          ],
                          image: DecorationImage(
                            image: Image.asset('lib/interface/assets/images/background.png').image,
                            fit: BoxFit.cover,
                          ),

                        ),
                        child: Container(
                            child: Row(
                              children: <Widget>[
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                        margin: EdgeInsets.only(left: 12),
                                        child: Text(
                                          widget.tasks[t - 2].title,
                                          style: TextStyle(
                                            color: resources.colors.primary,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        )
                                    ),
                                    Container(
                                        margin: EdgeInsets.only(left: 12, top: 4),
                                        child: Text(
                                          widget.tasks[t - 2].description,
                                          style: TextStyle(
                                            color: resources.colors.primary,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w300,
                                          ),
                                        )
                                    )
                                  ],
                                )
                              ],
                            )
                        )
                    ),
                  ],
                ),
              );
            }
        )
    );
  }
}