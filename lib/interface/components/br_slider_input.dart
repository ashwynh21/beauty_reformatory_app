import 'package:beautyreformatory/utilities/resources.dart';
import 'package:flutter/material.dart';
import 'package:flutter_xlider/flutter_xlider.dart';

class BrSliderInput extends StatefulWidget {
  String value;
  int length;
  List<Map<String, dynamic>> emojis;
  void Function(BrSliderInput, String value) complete;

  BrSliderInput({Key key,
    @required this.value,
    @required this.length,
    @required this.emojis,
    @required this.complete,
  }) : super(key: key);

  @override
  _BrSliderInputState createState() => _BrSliderInputState();
}

class _BrSliderInputState extends State<BrSliderInput> {
  /*
  Here we will get the emoji data to preview for the user
   */

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      width: MediaQuery.of(context).size.width - 48,

      child: Flex(
        direction: Axis.horizontal,
        crossAxisAlignment: CrossAxisAlignment.center,

        children: <Widget>[
          Expanded(
            flex: 12,

            child: Container(
              margin: EdgeInsets.only(bottom: 20),
              child: FlutterSlider(
                values: [widget.emojis.indexWhere((m) => (m['char'] == widget.value)).toDouble()],
                min: 0.0,
                max: widget.length.toDouble(),
                handlerWidth: 24,
                handlerHeight: 24,
                handler: FlutterSliderHandler(
                  child: ClipOval(child: Container(color: resources.colors.primary))
                ),
                trackBar: FlutterSliderTrackBar(
                  activeTrackBar: BoxDecoration(color: resources.colors.primary, borderRadius: BorderRadius.circular(2)),
                  inactiveTrackBar: BoxDecoration(color: resources.colors.light, borderRadius: BorderRadius.circular(2)),
                ),
                touchSize: 50,
                tooltip: FlutterSliderTooltip(disabled: true),
                hatchMark: FlutterSliderHatchMark(
                  density: 1,
                  smallLine: FlutterSliderSizedBox(decoration: BoxDecoration(color: Colors.transparent), width: 0.1, height: 0.1),
                  bigLine: FlutterSliderSizedBox(decoration: BoxDecoration(color: Colors.transparent), width: 0.1, height: 0.1,),
                  distanceFromTrackBar: 2,
                  labels: List.generate(5, (index) {
                    return FlutterSliderHatchMarkLabel(
                        percent: (index) * 20.toDouble(), label: Text(widget.emojis[(((index * 20) / 100) * widget.emojis.length).round()]['char'])
                    );
                  }).toList()..add(
                      FlutterSliderHatchMarkLabel(
                          percent: 100, label: Text(widget.emojis[widget.emojis.length - 1]['char'])

                      )
                  ),
                ),
                onDragging: (handler, lower, upper) {
                  setState(() {
                    widget.value = widget.emojis[lower.round()]['char'];
                  });
                },
                onDragCompleted: (handler, lower, upper) {
                  setState(() {
                    widget.value = widget.emojis[lower.round()]['char'];
                  });

                  widget.complete(widget, widget.emojis[lower.round()]['char']);
                },
              ),
            ),
          ),
          Expanded(
            flex: 2,

            child: Container(
              child: Text(
                widget.value,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24
                ),
              )
            ),
          )
        ]
      ),
    );
  }
}