import 'package:beautyreformatory/interface/components/br_snack.dart';
import 'package:beautyreformatory/interface/components/br_spinner.dart';
import 'package:beautyreformatory/interface/dialogs/br_confirm_operation.dart';
import 'package:beautyreformatory/interface/dialogs/br_edit_field_dialog.dart';
import 'package:beautyreformatory/interface/dialogs/br_select_image_source_dialog.dart';
import 'package:beautyreformatory/interface/dialogs/br_select_task_goal.dart';
import 'package:beautyreformatory/interface/dialogs/br_user_profile.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class dialogs {
  static final BrSnack snack = BrSnack();
  static final BrSpinner loader = BrSpinner();

  static void taskselect(BuildContext context,
        bool Function(BrSelectTaskGoal, bool) callback
      ) {
    showDialog(context: context,
      builder: (BuildContext context) => BrSelectTaskGoal(
        callback: callback,
      ),
      barrierDismissible: true,
    );
  }
  static void userprofile(BuildContext context, {
    String image,
    String id,
    String fullname,
    String email,
    int state,
    Future Function(BrUserProfile) left,
    void Function(BrUserProfile, String) report,
    void Function(BrUserProfile) right,
  }) {
    Navigator.push(context, new PageRouteBuilder(
      pageBuilder: (BuildContext context, __, ___) {
        return new BrUserProfile(
          image: image,
          id: id,
          fullname: fullname,
          email: email,
          state: state,
          left: left,
          report: report,
          right: right,
        );
      },
      transitionDuration: Duration(milliseconds: 256),
      barrierColor: Colors.black.withOpacity(0.64),
      opaque: false
    ));
  }
  static Future confirmoperation(BuildContext context, {
    @required String message,
    @required Future Function(BrConfirmOperation, bool) callback
  }) {
    return showDialog(context: context,
      builder: (BuildContext context) => BrConfirmOperation(
        message: message,
        callback: callback,
      ),
      barrierDismissible: true,
    );
  }
  static void selectsource(BuildContext context, {
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
  static void editfield(BuildContext context, {
    @required Future Function(BrEditFieldDialog, String) callback,
    @required String placeholder,
    @required String value,
    String icon,
    String instruction,
    TextInputType type = TextInputType.text,
    bool obscure = false,
    String submit = 'SAVE',
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
        submit: submit,
      ),
      transitionDuration: Duration(milliseconds: 128),
      barrierDismissible: false,
    );
  }
}