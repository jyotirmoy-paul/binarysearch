import 'package:flutter/cupertino.dart';

class AlgorithmInfo extends ChangeNotifier {
  String _extra;
  String _description;

  AlgorithmInfo();

  get description => _description;

  get extra => _extra;

  set info(String info) {
    if (this._description == info) return;

    this._description = info;
    notifyListeners();
  }

  set extra(String note) {
    if (this._extra == note) return;

    this._extra = note;
    notifyListeners();
  }
}

class LinearSearchAlgorithmInfo {
  static String algorithm() =>
      '1. Start from the leftmost element of array, and one by one compare X with each element of array\n'
      '2. If X matches with an element, we found the element present at index\n'
      '3. If X doesn\'t match with any of elements, the element does not exist in the array';

  static String comparingWith(int index, int value, int toSearch) =>
      "Comparing X ($toSearch) with the element $value present at index $index of the array";

  static String match(int index, int value, int toSearch) =>
      "The element X ($toSearch) matches with the array element $value, present at index $index. This completes the search";

  static String notMatch(int index, int value, int toSearch) =>
      "The element present at index $index ($value) does not matches with X ($toSearch), thus is disabled";
}
