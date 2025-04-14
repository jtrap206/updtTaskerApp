import 'package:flutter/material.dart';
import 'package:tasker/utils/extensions.dart';

class CommonContainers extends StatelessWidget {
  const CommonContainers({
    super.key,
    this.child,
    this.height,
  });

  final Widget? child;
  final double? height;

  @override
  Widget build(BuildContext context) {
    final deviceSize = context.deviceSize;
    return Container(
      width: deviceSize.width,
      height: height,
      decoration: BoxDecoration(
        color: context.colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(20),
      ),
      child: child,
    );
  }
}
