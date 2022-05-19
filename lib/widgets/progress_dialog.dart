import 'package:simpplex_app/utils/my_colors.dart';
import 'package:flutter/material.dart';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';

class ProgressDialogWidget extends StatelessWidget {
  final String message;
  const ProgressDialogWidget({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ProgressDialog(
      context: context,
    ).show(
      max: 100,
      msg: message,
      progressBgColor: MyColors.primaryColor,
      msgColor: MyColors.primaryColor,
      progressValueColor: Colors.grey[300] ?? Colors.grey,
    );
  }
}
