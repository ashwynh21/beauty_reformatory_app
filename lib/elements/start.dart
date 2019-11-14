import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Start extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
          alignment: Alignment.center,
          width: 44,
          height: 44,

          child: SvgPicture.asset('lib/assets/icons/logo.svg',)
      );
  }
}
