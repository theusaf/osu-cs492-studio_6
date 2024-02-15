import 'package:flutter/material.dart';

class CustomTriangleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(size.width / 2, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

class Triangle extends StatelessWidget {
  const Triangle({
    super.key,
    required this.size,
    this.child,
  });

  final Size size;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: CustomTriangleClipper(),
      child: SizedBox(
        width: size.width,
        height: size.height,
        child: child,
      ),
    );
  }
}
