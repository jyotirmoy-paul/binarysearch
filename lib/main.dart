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
          // FIXME: REMOVE THIS BEFORE PRODUCTION
          create: (_) => ValueNotifier<String>(
              '15 17 9 98 02 -3 -45 221 -3 43 -34 3 534 7 45 34 22 33 98 75 632 41 55 69 99 88 73 10'),
        ),
        ListenableProvider<ValueNotifier<bool>>(
          create: (_) => ValueNotifier<bool>(true),
        ),
        ListenableProvider<ValueNotifier<int>>(
          create: (_) => ValueNotifier<int>(null),
        ),
        ListenableProvider<ValueNotifier<List<ArrayElement>>>(
          create: (_) => ValueNotifier<List<ArrayElement>>([]),
        )
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
