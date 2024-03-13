import 'dart:math';

import 'package:flutter/material.dart';

class TweenM extends StatelessWidget {
  const TweenM({
    super.key,
    this.begin,
    this.end,
    this.durationinmilli = 100,
    this.child,
    required this.type,
    this.alignment,
  });
  final double? begin, end;
  final int durationinmilli;
  final Widget? child;
  final String type;
  final AlignmentGeometry? alignment;
  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
        tween: Tween(
          begin: begin,
          end: end,
        ),
        duration: Duration(milliseconds: durationinmilli),
        builder: (_, end, child) {
          switch (type) {
            case 'rotate':
              return rotate(end: end * pi / 180, child: child);
            case 'scale':
              return scaley(end: end, child: child);
            case 'scaley':
              return scaley(end: end, child: child, alignment: alignment);
            case 'scalex':
              return scalex(end: end, child: child);
            case 'opacity':
              return opacity(end: end, child: child);
            case 'translatex':
              return translatex(end: end, child: child);
            case 'translatey':
              return translatey(end: end, child: child);
            case 'rotationX':
              return rotationX(end: end, child: child);
            default:
              return const SizedBox();
          }
        },
        child: child);
  }

  rotate({end, child}) {
    return Transform.rotate(
      angle: end,
      child: child,
    );
  }

  scale({end, child}) {
    return Transform.scale(
      scale: end,
      child: child,
    );
  }

  scalex({end, child}) {
    return Transform.scale(
      scaleX: end,
      child: child,
    );
  }

  scaley({end, child, alignment}) {
    return Transform.scale(
      alignment: alignment,
      scaleY: end,
      child: child,
    );
  }

  opacity({end, child}) {
    return Opacity(
      opacity: end,
      child: child,
    );
  }

  translatex({end, child}) {
    return Transform.translate(
      offset: Offset(end, 0.0),
      child: child,
    );
  }

  translatey({end, child}) {
    return Transform.translate(
      offset: Offset(0.0, end),
      child: child,
    );
  }

  rotationX({end, child}) {
    return Transform(
      transform: Matrix4.rotationX(end),
      child: child,
    );
  }
}
