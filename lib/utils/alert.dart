import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Alert {
  static snackBar(
    BuildContext context,
    String text, {
    int milliseconds = 2000,
  }) {
    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
        duration: Duration(
          milliseconds: milliseconds,
        ),
      ),
    );
  }
}
