import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ToastService {

  static Future<bool?> show({
    required String message,
    Toast toastLength = Toast.LENGTH_SHORT,
    ToastGravity gravity = ToastGravity.TOP,
    Color backgroundColor = Colors.black87,
    Color textColor = Colors.white,
    double fontSize = 14.0,
  }) {
    return Fluttertoast.showToast(
      msg: message,
      toastLength: toastLength,
      gravity: gravity,
      backgroundColor: backgroundColor,
      textColor: textColor,
      fontSize: fontSize,
    );
  }

  static Future<bool?> showError(
    String message, {
    Toast toastLength = Toast.LENGTH_LONG,
    ToastGravity gravity = ToastGravity.TOP,
  }) {
    return show(
      message: message,
      toastLength: toastLength,
      gravity: gravity,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 14.0,
    );
  }

  static Future<bool?> showSuccess(
    String message, {
    Toast toastLength = Toast.LENGTH_SHORT,
    ToastGravity gravity = ToastGravity.TOP,
  }) {
    return show(
      message: message,
      toastLength: toastLength,
      gravity: gravity,
      backgroundColor: Colors.green,
      textColor: Colors.white,
      fontSize: 14.0,
    );
  }

  static Future<bool?> showInfo(
    String message, {
    Toast toastLength = Toast.LENGTH_SHORT,
    ToastGravity gravity = ToastGravity.TOP,
  }) {
    return show(
      message: message,
      toastLength: toastLength,
      gravity: gravity,
      backgroundColor: Colors.blue,
      textColor: Colors.white,
      fontSize: 14.0,
    );
  }

  static Future<bool?> showWarning(
    String message, {
    Toast toastLength = Toast.LENGTH_SHORT,
    ToastGravity gravity = ToastGravity.TOP,
  }) {
    return show(
      message: message,
      toastLength: toastLength,
      gravity: gravity,
      backgroundColor: Colors.orange,
      textColor: Colors.white,
      fontSize: 14.0,
    );
  }

  static Future<bool?> cancel() {
    return Fluttertoast.cancel();
  }
}
