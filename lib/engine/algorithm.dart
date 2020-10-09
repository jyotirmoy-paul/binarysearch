import 'dart:math';

import 'package:binarysearch/models/array_element.dart';
import 'package:binarysearch/utils/constants.dart';
import 'package:binarysearch/widgets/array_element_widget.dart';

class Algorithm {
  static void _disableIndices(int start, int end, List<ArrayElement> arr) {
    assert(start <= end);

    for (int i = start; i <= end; i++)
      arr[i].setElementState = ArrayElementState.Disabled;
  }

  static void _enableIndices(int start, int end, List<ArrayElement> arr,
      {ArrayElementState withState = ArrayElementState.Default}) {
    assert(start <= end);

    for (int i = start; i <= end; i++) arr[i].setElementState = withState;
  }

  /* implementation of binary search to search for the toSearch value in the array arr */
  static Future<bool> runBinarySearch(
    List<ArrayElement> arr,
    int toSearch,
  ) async {
    int start = 0;
    int end = arr.length - 1;

    while (end >= start) {
      // show in UI
      arr[start].setElementState = ArrayElementState.BoundaryState;
      arr[end].setElementState = ArrayElementState.BoundaryState;

      await Future.delayed(kAnimationDuration);

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
        _disableIndices(mid, end, arr);

        // show in UI -- make start index a default state
        arr[start].setElementState = ArrayElementState.Default;

        end = mid - 1;
      } else {
        // proceed to check on the right sub array

        // show in UI -- disable all elements on the left side
        _disableIndices(start, mid, arr);

        // show in UI -- make start index a default state
        arr[end].setElementState = ArrayElementState.Default;

        start = mid + 1;
      }

      await Future.delayed(kAnimationDuration);
    }

    return false;
  }

  /* implementation of linear search */
  static Future<bool> runLinearSearch(
    List<ArrayElement> arr,
    int toSearch,
  ) async {
    for (int i = 0; i < arr.length; i++) {
      arr[i].setElementState = ArrayElementState.BoundaryState;
      await Future.delayed(kAnimationDuration);

      if (arr[i].value == toSearch) {
        arr[i].setElementState = ArrayElementState.MatchedState;
        return true;
      }

      arr[i].setElementState = ArrayElementState.Disabled;
      await Future.delayed(kAnimationDuration);
    }

    return false;
  }

  /* implementation of jump search */
  static Future<bool> runJumpSearch(
    List<ArrayElement> arr,
    int toSearch,
  ) async {
    int jumpStep = sqrt(arr.length).toInt();

    int start = 0;

    while (arr[start].value <= toSearch) {
      arr[start].setElementState = ArrayElementState.BoundaryState;
      await Future.delayed(kAnimationDuration);

      if (arr[start].value == toSearch) {
        arr[start].setElementState = ArrayElementState.MatchedState;
        return true;
      }

      // jump ahead
      int newStart = start + jumpStep;

      _disableIndices(start, newStart - 1, arr);
      start = newStart;

      if (start >= arr.length) {
        _enableIndices(arr.length - jumpStep - 1, arr.length - 1, arr,
            withState: ArrayElementState.MidState);
        return runLinearSearch(
            arr.sublist(arr.length - jumpStep - 1), toSearch);
      }
    }

    int s = start - jumpStep;
    int e = start;

    // e ---> TODO: REMOVE
    // doing a linear search between s and (e)
    _enableIndices(s, e, arr, withState: ArrayElementState.MidState);
    return runLinearSearch(arr.sublist(s, e), toSearch);
  }
}
