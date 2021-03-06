import 'dart:async';
import 'dart:math';

import 'package:binarysearch/engine/algorithm.dart';
import 'package:binarysearch/engine/algorithm_type.dart';
import 'package:binarysearch/engine/info/algorithm_info.dart';
import 'package:binarysearch/engine/prepare_elements.dart';
import 'package:binarysearch/models/array_element.dart';
import 'package:binarysearch/screens/main_screen_components/playground.dart';
import 'package:binarysearch/utils/alert.dart';
import 'package:binarysearch/utils/constants.dart';
import 'package:binarysearch/widgets/array_element_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final TextEditingController _inputController = TextEditingController();
  final TextEditingController _searchInputController = TextEditingController();

  Timer _timer;

  bool _isRunning = false;
  bool _isNew = true; // keeps track if elements are dirty or not

  Algorithm _algorithm;

  void _startAlgo(
      List<ArrayElement> arr, int toSearch, BuildContext context) async {
    if (_algorithm == null) _algorithm = Algorithm(context: context);

    if (_isRunning) return;

    if (!_isNew)
      /* if inside this -> means elements are dirty, need to put them to default */
      /* it may happen that user is running different algorithm on same set of data points */
      /* thus before running the algorithm gain, reset all the data states */
      for (var e in arr) e.setElementState = ArrayElementState.Default;

    _isNew = false;

    setState(() {
      _isRunning = true;
    });

    AlgorithmType algorithmType = Provider.of<ValueNotifier<AlgorithmType>>(
      context,
      listen: false,
    ).value;

    bool found = false;

    Provider.of<ValueNotifier<double>>(context, listen: false).value = 0.0;

    _timer = Timer.periodic(const Duration(milliseconds: 100), (_) {
      Provider.of<ValueNotifier<double>>(context, listen: false).value += 0.10;
    });

    switch (algorithmType) {
      case AlgorithmType.BinarySearch:
        found = await _algorithm.runBinarySearch(arr, toSearch);
        break;
      case AlgorithmType.LinearSearch:
        found = await _algorithm.runLinearSearch(arr, toSearch);
        break;
      case AlgorithmType.JumpSearch:
        found = await _algorithm.runJumpSearch(arr, toSearch);
        break;
    }

    _timer.cancel();

    if (found)
      Alert.snackBar(
        context,
        '$toSearch Found',
      );
    else
      Alert.snackBar(
        context,
        '$toSearch NOT Found',
      );

//    setState(() {
//      _isRunning = false;
//    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          _buildTopRow(context),
          Expanded(
            flex: 6,
            child: Consumer<ValueNotifier<List<ArrayElement>>>(
              builder: (_, valueNotifier, __) => Playground(
                elements: valueNotifier.value,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    final titleTextStyle = const TextStyle(color: Colors.black);

    return AppBar(
      title: SizedBox(
        width: 300.0,
        child: AbsorbPointer(
          absorbing: _isRunning,
          child: CupertinoPicker(
            onSelectedItemChanged: (int index) {
              Provider.of<ValueNotifier<AlgorithmType>>(context, listen: false)
                  .value = AlgorithmType.values[index];
            },
            itemExtent: 50.0,
            children: kAlgorithmNames
                .map(
                  (algoName) => Center(
                    child: Text(
                      algoName,
                      style: titleTextStyle,
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      ),
      elevation: 5.0,
      centerTitle: true,
      backgroundColor: Colors.white,
      leading: IconButton(
        icon: const Icon(Icons.add_box),
        color: Colors.black,
        iconSize: 30.0,
        onPressed: _isRunning
            ? null
            : () {
                _isNew = true;

                // add random data
                int n = 20 + Random().nextInt(80);
                String inputString = '';

                for (int i = 0; i < n; i++)
                  inputString += '${Random().nextInt(1000)} ';

                Provider.of<ValueNotifier<String>>(context, listen: false)
                    .value = inputString.trim();

                PrepareElements.prepare(context);
              },
      ),
      actions: [
        /* show the element of interest (one searching for) */
        _isRunning
            ? Center(
                child: Text(
                  'Searching for ${Provider.of<ValueNotifier<int>>(context, listen: false).value}',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 18.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              )
            : SizedBox.shrink(),

        /* separator */
        SizedBox(
          width: kContentPadding,
        ),
        /* timer for algo */
        Center(
          child: Consumer<ValueNotifier<double>>(
            builder: (_, valueNotifier, __) => Text(
              '${valueNotifier.value.toStringAsFixed(1)}s',
              style: TextStyle(
                color: Colors.green,
                fontSize: 18.0,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),

        /* reset the stage */
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: kContentPadding),
          child: IconButton(
            icon: const Icon(Icons.history),
            color: Colors.black,
            iconSize: 30.0,
            onPressed: () {
              /* reset everything */
              _inputController.text = '';
              _searchInputController.text = '';

              Provider.of<ValueNotifier<String>>(context, listen: false).value =
                  '';
              Provider.of<ValueNotifier<bool>>(context, listen: false).value =
                  true;
              Provider.of<ValueNotifier<int>>(context, listen: false).value =
                  null;

              Provider.of<ValueNotifier<double>>(context, listen: false).value =
                  0.0;

              PrepareElements.prepare(context);

              _isNew = true;
              _timer?.cancel();

              setState(() {
                _isRunning = false;
              });
            },
          ),
        ),

        /* start the algorithm */
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: kContentPadding),
          child: Consumer3<ValueNotifier<String>, ValueNotifier<int>,
              ValueNotifier<List<ArrayElement>>>(
            builder: (context, vnArr, vnToSearch, vnArrayElementsList, __) =>
                IconButton(
              icon: const Icon(Icons.play_arrow),
              color: Colors.green,
              iconSize: 30.0,
              onPressed: (vnArr.value.isEmpty ||
                      vnToSearch.value == null ||
                      _isRunning)
                  ? null
                  : () => _startAlgo(
                        vnArrayElementsList.value,
                        vnToSearch.value,
                        context,
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
      flex: 2,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: kContentPadding),
        child: _isRunning
            ? Center(
                child: Consumer<AlgorithmInfo>(
                  builder: (_, AlgorithmInfo info, __) =>
                      info.description == null
                          ? SizedBox.shrink()
                          : Text(
                              info.description,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18.0,
                                fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.center,
                            ),
                ),
              )
            : Row(
                children: [
                  /* user input - array of numbers */
                  Expanded(
                    flex: 15,
                    child: TextField(
                      controller: _inputController,
                      onChanged: (String value) {
                        Provider.of<ValueNotifier<String>>(context,
                                listen: false)
                            .value = value.trim();

                        PrepareElements.prepare(context);
                      },
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
                  Container(
                    height: 50.0,
                    width: 1.0,
                    color: Colors.black,
                  ),
                  separator,

                  /* user input - integer to search */
                  Expanded(
                    child: TextField(
                      controller: _searchInputController,
                      onChanged: (String value) => Provider.of<
                                  ValueNotifier<int>>(context, listen: false)
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
                          activeColor: Colors.redAccent,
                          onChanged: (newValue) {
                            Provider.of<ValueNotifier<bool>>(
                              context,
                              listen: false,
                            ).value = newValue;

                            PrepareElements.prepare(context);
                          },
                          value: valueNotifier.value,
                        ),
                      ),
                      const SizedBox(height: 2.0),
                      Text('Auto-Sort'),
                    ],
                  ),
                ],
              ),
      ),
    );
  }
}
