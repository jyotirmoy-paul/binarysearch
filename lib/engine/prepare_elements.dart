import 'package:binarysearch/models/array_element.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class PrepareElements {
  // this method converts the integers from the arrayString to ArrayElement objects and
  // add to the globally maintained Provider ArrayElement array
  static void prepare(BuildContext context) {
    List<ArrayElement> elements;

    String arrayString = Provider.of<ValueNotifier<String>>(
      context,
      listen: false,
    ).value;

    bool autoSort = Provider.of<ValueNotifier<bool>>(
      context,
      listen: false,
    ).value;

    if (arrayString.isEmpty) {
      elements = [];
    } else {
      List<int> intArray =
          arrayString.split(' ').map<int>((String e) => int.parse(e)).toList();

      if (autoSort) intArray.sort();

      elements = intArray
          .map<ArrayElement>((int value) => ArrayElement(value))
          .toList();
    }

    Provider.of<ValueNotifier<List<ArrayElement>>>(context, listen: false)
        .value = elements;
  }
}
