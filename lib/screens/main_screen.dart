import 'package:binarysearch/engine/algorithm.dart';
import 'package:binarysearch/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatelessWidget {
  void _startAlgo(String inputString, int toSearch, bool autoSortFlag) {
    Algorithm.prepare(
      inputString,
      toSearch,
      autoSortFlag,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ListenableProvider<ValueNotifier<String>>(
          create: (_) => ValueNotifier<String>(''),
          lazy: false,
        ),
        ListenableProvider<ValueNotifier<bool>>(
          create: (_) => ValueNotifier<bool>(true),
          lazy: false,
        ),
        ListenableProvider<ValueNotifier<int>>(
          create: (_) => ValueNotifier<int>(null),
          lazy: false,
        ),
      ],
      builder: (BuildContext context, _) => Scaffold(
        appBar: _buildAppBar(),
        backgroundColor: Colors.white,
        body: Column(
          children: [
            _buildTopRow(context),
            Expanded(
              flex: 6,
              child: Container(
                color: kLightGray,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return AppBar(
      title: const SelectableText(
        'Binary Search Algorithm',
        style: const TextStyle(color: Colors.black),
      ),
      elevation: 5.0,
      centerTitle: true,
      backgroundColor: Colors.white,
      actions: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: kContentPadding),
          child: Consumer3<ValueNotifier<String>, ValueNotifier<int>,
              ValueNotifier<bool>>(
            builder: (_, vnArr, vnToSearch, vnAutoSortFlag, __) => IconButton(
              icon: const Icon(Icons.play_arrow),
              color: Colors.green,
              iconSize: 30.0,
              onPressed: (vnArr.value.isEmpty || vnToSearch.value == null)
                  ? null
                  : () => _startAlgo(
                        vnArr.value,
                        vnToSearch.value,
                        vnAutoSortFlag.value,
                      ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTopRow(BuildContext context) {
    final separator = const SizedBox(width: kContentPadding);

    return Expanded(
      flex: 1,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: kContentPadding),
        child: Row(
          children: [
            /* user input - array of numbers */
            Expanded(
              flex: 15,
              child: TextField(
                onChanged: (String value) =>
                    Provider.of<ValueNotifier<String>>(context, listen: false)
                        .value = value.trim(),
                style: const TextStyle(
                  fontSize: 20.0,
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9 ]+')),
                ],
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText:
                      'Enter space separated elements here (e.g 7 6 11 13)',
                  hintStyle: const TextStyle(
                    color: kGray,
                  ),
                ),
              ),
            ),
            separator,
            Expanded(
              child: TextField(
                onChanged: (String value) =>
                    Provider.of<ValueNotifier<int>>(context, listen: false)
                            .value =
                        value.trim().isEmpty ? null : int.parse(value.trim()),
                style: const TextStyle(
                  fontSize: 20.0,
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9]+')),
                ],
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Search',
                  hintStyle: const TextStyle(
                    color: kGray,
                  ),
                ),
              ),
            ),

            /* Checkbox for auto sorting the array */
            separator,
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Consumer<ValueNotifier<bool>>(
                  builder: (_, valueNotifier, __) => CupertinoSwitch(
                    onChanged: (newValue) => Provider.of<ValueNotifier<bool>>(
                      context,
                      listen: false,
                    ).value = newValue,
                    value: valueNotifier.value,
                  ),
                ),
                const SizedBox(height: 2.0),
                Text('Auto Sort'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}