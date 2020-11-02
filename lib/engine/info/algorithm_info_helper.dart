import 'package:binarysearch/engine/info/algorithm_info.dart';
import 'package:binarysearch/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class AlgorithmInfoHelper {
  static Future<void> setInfo(BuildContext context, String info,
      {String note}) async {
    Provider.of<AlgorithmInfo>(
      context,
      listen: false,
    ).info = info;

    if (note != null && note.isNotEmpty) {
      Provider.of<AlgorithmInfo>(
        context,
        listen: false,
      ).extra = note;
    }

    await Future.delayed(kAnimationDuration);
  }
}
