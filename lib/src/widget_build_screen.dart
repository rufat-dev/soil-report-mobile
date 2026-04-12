import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WidgetBuildScreen extends StatefulWidget {
  const WidgetBuildScreen({super.key});

  @override
  State<WidgetBuildScreen> createState() => _WidgetBuildScreenState();
}

class _WidgetBuildScreenState extends State<WidgetBuildScreen> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: Colors.black,
          )
        ),
      ),
    );
  }
}
