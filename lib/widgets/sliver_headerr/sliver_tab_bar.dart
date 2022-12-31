import 'package:flutter/material.dart';

class SliverHeader extends SliverPersistentHeaderDelegate {
  final PreferredSizeWidget child;

  SliverHeader({required this.child});

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  double get maxExtent => child.preferredSize.height;

  @override
  double get minExtent => child.preferredSize.height;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) => oldDelegate != this;
}
