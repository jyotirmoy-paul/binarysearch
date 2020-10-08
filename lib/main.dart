import 'package:binarysearch/engine/algorithm_type.dart';
import 'package:binarysearch/models/array_element.dart';
import 'package:binarysearch/screens/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ListenableProvider<ValueNotifier<String>>(
          create: (_) => ValueNotifier<String>(''),
        ),
        ListenableProvider<ValueNotifier<bool>>(
          create: (_) => ValueNotifier<bool>(true),
        ),
        ListenableProvider<ValueNotifier<int>>(
          create: (_) => ValueNotifier<int>(null),
        ),
        ListenableProvider<ValueNotifier<List<ArrayElement>>>(
          create: (_) => ValueNotifier<List<ArrayElement>>([]),
        ),
        ListenableProvider<ValueNotifier<AlgorithmType>>(
          create: (_) =>
              ValueNotifier<AlgorithmType>(AlgorithmType.BinarySearch),
        ),
        ListenableProvider<ValueNotifier<double>>(
          create: (_) => ValueNotifier<double>(0.0),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Search Algorithms',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: MainScreen(),
      ),
    );
  }
}
