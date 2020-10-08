import 'package:binarysearch/widgets/array_element_widget.dart';
import 'package:flutter/cupertino.dart';

class ArrayElement {
  GlobalKey<ArrayElementWidgetState> _key;
  ArrayElementWidget _widget;
  int _value;

  ArrayElement(int value) {
    this._key = GlobalKey<ArrayElementWidgetState>();
    this._widget = ArrayElementWidget(
      key: this._key,
      value: value,
    );

    this._value = value;
  }

  Widget get widget => _widget;
  int get value => _value;

  set setElementState(ArrayElementState state) =>
      _key.currentState.updateState(state);
}
