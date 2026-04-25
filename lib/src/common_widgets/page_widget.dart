import 'dart:ui';

import 'package:soilreport/src/core/utils/size_extension.dart';
import 'package:flutter/material.dart';

class PageWidget extends StatefulWidget {
  final Widget body;
  final bool isLoading;
  const PageWidget({required this.body, required this.isLoading, super.key});

  @override
  State<PageWidget> createState() => _PageWidgetState();
}

class _PageWidgetState extends State<PageWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: IgnorePointer(
        ignoring: widget.isLoading,
        child: Scaffold(
          backgroundColor: Theme.of(context).colorScheme.surface,
          body: Stack(
            children: [
              SizedBox(width: 100.sw(context), height: 100.sh(context)),
              SizedBox(
                width: 100.sw(context),
                height: 100.sh(context),
                child: widget.body,
              ),
              if (widget.isLoading) ...[
                AnimatedContainer(
                  duration: const Duration(milliseconds: 350),
                  width: 100.sw(context),
                  height: 100.sh(context),
                  alignment: Alignment.center,
                  child: BackdropFilter(
                    filter: ImageFilter.blur(
                      sigmaY: widget.isLoading ? 5 : 0,
                      sigmaX: widget.isLoading ? 5 : 0,
                    ),
                    child: Image.asset(
                      height: 70,
                      "assets/images/static/soil-plant.gif",
                    ), //gif,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
