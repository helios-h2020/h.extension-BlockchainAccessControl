import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:helios_access_control_ui/di/DI.dart';

class DialogUtils {
  static Future<T> showConfirmDialog<T>({
    @required String confirmText,
    String title,
    String message,
    String cancelText,
    Function cancelAction,
    Function confirmAction,
  }) {
    return showCustomContentConfirmDialog(
        title: title,
        content: (message != null && message.isNotEmpty)
            ? Text(
                message,
                style: TextStyle(
                  color: DI.dialogMiddleTextColor,
                  fontWeight: DI.robotoRegular,
                  fontSize: 16,
                ),
              )
            : null,
        cancelText: cancelText,
        confirmText: confirmText,
        cancelAction: cancelAction,
        confirmAction: confirmAction);
  }

  static Future<T> showCustomContentConfirmDialog<T>({
    String title,
    Widget content,
    String cancelText,
    String confirmText,
    Function cancelAction,
    Function confirmAction,
  }) {
    return Get.dialog(
      buildCustomContentConfirmDialog(
          title: title,
          content: content,
          cancelText: cancelText,
          confirmText: confirmText,
          onCancelPressed: () {
            if (cancelAction != null) cancelAction();
          },
          onConfirmPressed: () {
            if (confirmAction != null) confirmAction();
          }),
    ).then((value) => value ?? false);
  }

  static AlertDialog buildCustomContentConfirmDialog({
    String title,
    Widget content,
    String cancelText,
    String confirmText,
    Function onCancelPressed,
    Function onConfirmPressed,
  }) {
    return AlertDialog(
      titlePadding: const EdgeInsets.only(left: 22, right: 22, top: 18),
      contentPadding: const EdgeInsets.only(left: 22, right: 22, top: 25),
      actionsPadding: (title != null && title.isNotEmpty)
          ? const EdgeInsets.only(right: 6, top: 28, bottom: 6)
          : EdgeInsets.zero,
      title: (title != null && title.isNotEmpty)
          ? Text(title,
              style: TextStyle(
                color: DI.dialogTitleColor,
                fontWeight: DI.robotoRegular,
                fontSize: 20,
              ))
          : null,
      content: content,
      actions: [
        if (cancelText != null && cancelText.isNotEmpty)
          FlatButton(
            child: Text(cancelText.toUpperCase(),
                style: TextStyle(
                  fontWeight: DI.robotoRegular,
                  color: DI.dialogConfirmColor,
                  fontSize: 14,
                )),
            onPressed: onCancelPressed,
          ),
        if (confirmText != null && confirmText.isNotEmpty)
          FlatButton(
            child: Text(confirmText.toUpperCase(),
                style: TextStyle(
                  fontWeight: DI.robotoRegular,
                  color: DI.dialogConfirmColor,
                  fontSize: 14,
                )),
            onPressed: onConfirmPressed,
          )
      ],
    );
  }
}
