import 'package:flutter/material.dart';

class TestWidget extends StatefulWidget {
  final String value;
  const TestWidget({
    Key? key,
    required this.value,
  }) : super(key: key);

  @override
  State<TestWidget> createState() => _TestWidgetState();
}

class _TestWidgetState extends State<TestWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(color: Colors.blue, child: Text(widget.value));
  }
}
