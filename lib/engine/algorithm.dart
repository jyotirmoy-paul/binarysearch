import 'package:binarysearch/models/array_element.dart';
import 'package:binarysearch/utils/constants.dart';
import 'package:binarysearch/widgets/array_element_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Algorithm {
  static void disableIndices(int start, int end, List<ArrayElement> arr) {
    assert(start <= end);

    for (int i = start; i <= end; i++)
      arr[i].setElementState = ArrayElementState.Disabled;
  }

  /* implementation of binary search to search for the toSearch value in the array arr */
  static Future<bool> runBinarySearch(
    List<ArrayElement> arr,
    int toSearch, {
    BuildContext context,
  }) async {
    int start = 0;
    int end = arr.length - 1;

    while (end > start) {
      // show in UI
      arr[start].setElementState = ArrayElementState.BoundaryState;
      arr[end].setElementState = ArrayElementState.BoundaryState;

      // find the min element
      int mid = (start + end) ~/ 2;

      // show in UI
      arr[mid].setElementState = ArrayElementState.MidState;

      await Future.delayed(kAnimationDuration);

      if (arr[mid].value == toSearch) {
        // show in UI
        arr[mid].setElementState = ArrayElementState.MatchedState;
        return true;
      }

      /* or check in the left or right sub array */
      if (arr[mid].value > toSearch) {
        // proceed to check on the left sub array

        // show in UI -- disable all elements on the right side
        disableIndices(mid, end, arr);

        // show in UI -- make start index a default state
        arr[start].setElementState = ArrayElementState.Default;

        end = mid - 1;
      } else {
        // proceed to check on the right sub array

        // show in UI -- disable all elements on the left side
        disableIndices(start, mid, arr);

        // show in UI -- make start index a default state
        arr[end].setElementState = ArrayElementState.Default;

        start = mid + 1;
      }

      await Future.delayed(kAnimationDuration);
    }

    return false;
  }
}
