import 'package:beautyreformatory/interface/components/br_snack.dart';
import 'package:beautyreformatory/interface/components/br_spinner.dart';
import 'package:beautyreformatory/interface/dialogs/br_confirm_operation.dart';
import 'package:beautyreformatory/interface/dialogs/br_edit_field_dialog.dart';
import 'package:beautyreformatory/interface/dialogs/br_select_image_source_dialog.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

final BrSnack snack = BrSnack();
final BrSpinner loader = BrSpinner();

class dialogs {
  static void confirmoperation(BuildContext context, {
    @required String message,
    @required Future Function(BrConfirmOperation, bool) callback
  }) {
    showDialog(context: context,
      builder: (BuildContext context) => BrConfirmOperation(
        message: message,
        callback: callback,
      ),
      barrierDismissible: true,
    );
  }
  static void selectsource(BuildContext context,
      {
        @required Future Function(BrSelectImageSourceDialog, String, bool) callback,
        @required String title,
      }) {
    showGeneralDialog(context: context,
      pageBuilder: (BuildContext context, outro, intro) => BrSelectImageSourceDialog(
        title: title,
        callback: callback,
      ),
      transitionDuration: Duration(milliseconds: 128),
      barrierDismissible: false,
    );
  }
  static void editfield(BuildContext context,
      {
        @required Future Function(BrEditFieldDialog, String) callback,
        @required String placeholder,
        @required String value,
        String icon,
        String instruction,
        TextInputType type = TextInputType.text,
        bool obscure = false
      }) {
    showGeneralDialog(context: context,
      pageBuilder: (BuildContext context, outro, intro) => BrEditFieldDialog(
        placeholder: placeholder,
        instruction: instruction,
        callback: callback,
        value: value,
        icon: icon,
        type: type,
        obscure: obscure,
      ),
      transitionDuration: Duration(milliseconds: 128),
      barrierDismissible: false,
    );
  }
}