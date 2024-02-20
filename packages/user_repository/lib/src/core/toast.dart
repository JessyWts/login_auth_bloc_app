import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void showToast({required bool isSuccess, required String message}){
  MaterialColor colorMessage = isSuccess ? Colors.green : Colors.red ;
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 3,
      backgroundColor: colorMessage,
      textColor: Colors.white,
      fontSize: 16.0
  );
}