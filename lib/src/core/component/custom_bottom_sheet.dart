import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../utils/app_theme.dart';

class CustomBottomSheet extends StatefulWidget {
  final List<Widget>? slivers;
  final Widget Function(BuildContext context, ScrollController controller)? scrollableBuilder;
  final double? initialChildSize;
  final double? minChildSize;
  final double? maxChildSize;
  final bool? expand;
  final Color? backgroundColor;
  const CustomBottomSheet({
    this.slivers,
    super.key,
    this.scrollableBuilder,
    this.initialChildSize,
    this.minChildSize,
    this.maxChildSize,
    this.expand,
    this.backgroundColor
  });

  @override
  State<CustomBottomSheet> createState() => _CustomBottomSheetState();
}

class _CustomBottomSheetState extends State<CustomBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: widget.initialChildSize  ?? .4,
      minChildSize: widget.minChildSize ?? 0.35,
      maxChildSize: widget.maxChildSize ?? 0.7,
      expand: widget.expand ?? false,
      builder: widget.scrollableBuilder ?? (context, controller){
        return Padding(
          padding: EdgeInsets.only(left: 15,right: 15,top: 3),
          child: CustomScrollView(
            controller: controller,
            physics: ClampingScrollPhysics(),
            slivers: [
              SliverPersistentHeader(
                pinned: true,
                delegate: _HandleSliverDelegate(backgroundColor: widget.backgroundColor),
              ),
              ...?widget.slivers,
              SliverToBoxAdapter(
                child: const SizedBox(height: 15,),
              )
            ],
          ),
        );
      },
    );
  }
}

class _HandleSliverDelegate extends SliverPersistentHeaderDelegate {

  final Color? backgroundColor;

  const _HandleSliverDelegate({this.backgroundColor});

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12.0,),
      width: double.maxFinite,
      color: backgroundColor ?? AppTheme().surfaceDark,
      height: 29,
      child: Center(
        child: Container(
          width: 40,
          height: 5,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(3),
            color: AppTheme().gray,
          ),
        ),
      ),
    );
  }

  @override
  double get maxExtent => 29; // height + padding
  @override
  double get minExtent => 29;
  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) => false;

}

Future<void> showCustomModalBottomSheet({
  required BuildContext context,
  Widget Function(BuildContext context)? builder,
  Widget Function(BuildContext context, ScrollController controller)? scrollableBuilder,
  List<Widget>? slivers,
  Color? backgroundColor,
  bool? isScrollControlled,
  double? initialChildSize,
  double? minChildSize,
  double? maxChildSize,
  bool? expand,
}) async {
  await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: backgroundColor ?? AppTheme().surfaceDark,
      builder: builder ?? (context) {
        return CustomBottomSheet(
          slivers: slivers,
          scrollableBuilder: scrollableBuilder,
          initialChildSize: initialChildSize,
          minChildSize: minChildSize,
          maxChildSize: maxChildSize,
          backgroundColor: backgroundColor,
          expand: expand,
        );
      }
  );
}