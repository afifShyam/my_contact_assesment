import 'package:flutter/material.dart';

class TabHeader extends SliverPersistentHeaderDelegate {
  TabHeader({
    required this.minSize,
    required this.maxSize,
    required this.child,
  });
  final double minSize;
  final double maxSize;
  final Widget child;

  @override
  double get minExtent => minSize;

  @override
  double get maxExtent => maxSize > minSize ? maxSize : minSize;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    // Wrap child in a Key to trigger rebuilds when the key changes
    return SizedBox.expand(child: KeyedSubtree(child: child));
  }

  @override
  bool shouldRebuild(covariant TabHeader oldDelegate) {
    // Check for all properties that might affect the rebuild
    return maxSize != oldDelegate.maxSize ||
        minSize != oldDelegate.minSize ||
        child != oldDelegate.child;
  }
}
