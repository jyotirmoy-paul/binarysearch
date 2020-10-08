import 'package:binarysearch/models/array_element.dart';
import 'package:binarysearch/utils/constants.dart';
import 'package:flutter/material.dart';

class Playground extends StatelessWidget {
  final List<ArrayElement> elements;

  Playground({
    this.elements,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: kContentPadding),
      child: Center(
        child: elements.isEmpty
            ? Text(
                'Tips:\n\nYou can either enter your own values or generate random values\n\nSlide over the title text to change the algorithm\n\nBinary Search, Linear Search & Jump Search',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18.0,
                  color: kGray,
                ),
              )
            : SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Wrap(
                  spacing: 10.0,
                  runSpacing: 10.0,
                  children: elements.map((e) => e.widget).toList(),
                ),
              ),
      ),
    );
  }
}
