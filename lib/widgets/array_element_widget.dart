import 'package:binarysearch/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum ArrayElementState {
  Default,
  Disabled,
  MidState,
  BoundaryState,
  MatchedState,
}

class ArrayElementWidget extends StatefulWidget {
  final int value;

  ArrayElementWidget({
    Key key,
    @required this.value,
  }) : super(key: key);

  @override
  ArrayElementWidgetState createState() => ArrayElementWidgetState();
}

class ArrayElementWidgetState extends State<ArrayElementWidget> {
  /* this function is exposed for state changes within the element blocks */
  void updateState(ArrayElementState state) async {
    /* highlight the element */
    setState(() {
      _scaleFactor *= kScaleIncrementFactor;
    });

    /* change appropriate state */
    switch (state) {
      case ArrayElementState.Default:
        _backgroundColor = kLightGray;
        _borderColor = Colors.black;
        _textColor = Colors.black;
        break;
      case ArrayElementState.Disabled:
        _isDisabled = true;
        break;
      case ArrayElementState.MidState:
        _backgroundColor = Colors.redAccent;
        _textColor = Colors.white;
        _borderColor = Colors.redAccent;
        break;
      case ArrayElementState.BoundaryState:
        _backgroundColor = Colors.blue;
        _textColor = Colors.white;
        _borderColor = Colors.blue;
        break;
      case ArrayElementState.MatchedState:
        _backgroundColor = Colors.green;
        _textColor = Colors.white;
        _borderColor = Colors.green;
        break;
    }

    await Future.delayed(kStateChangeAnimationDuration);

    setState(() {
      _scaleFactor = 1.0;
    });
  }

  Color _backgroundColor = kLightGray;
  Color _borderColor = Colors.black;
  Color _textColor = Colors.black;

  bool _isDisabled = false;

  double _scaleFactor = 1.0;

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: _scaleFactor,
      child: Container(
        width: kArrayElementDimen * kWidthFactor,
        height: kArrayElementDimen,
        decoration: BoxDecoration(
          color: _backgroundColor,
          border: Border.all(
            color: _isDisabled ? kLightGray2 : _borderColor,
            width: 1.0,
          ),
        ),
        padding: const EdgeInsets.all(15.0),
        child: FittedBox(
          child: Text(
            widget.value.toString(),
            style: TextStyle(
              color: _isDisabled ? kLightGray2 : _textColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
