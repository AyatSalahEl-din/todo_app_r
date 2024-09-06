import 'package:flutter/material.dart';

class DialogUtils {
  static void showLoading(
      {required BuildContext context, required String loadingLabel}) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Row(children: [
              CircularProgressIndicator(),
              SizedBox(
                width: 10,
              ),
              Text(loadingLabel)
            ]),
          );
        });
  }

  static void hideLoading(BuildContext context) {
    Navigator.pop(context);
  }

  static void showMessage({
    required BuildContext context,
    required String content,
    String title = '',
    String? posActionName,
    Function? posAction,
    String? negActionName,
    Function? negAction,
  }) {
    List<Widget> actions = [];
    if (posActionName != null) {
      actions.add(ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
            posAction?.call();
          },
          child: Text(posActionName)));
    }
    if (negActionName != null) {
      actions.add(ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
            negAction?.call();
          },
          child: Text(negActionName)));
    }
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text(content),
            title: Text(title),
            actions: actions,
          );
        });
  }
}
