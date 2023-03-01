import 'package:blobber_client/gen/game.pb.dart';
import 'package:blobber_client/utils.dart';
import 'package:flutter/material.dart';

class BlobboPainter extends CustomPainter {
  BlobboPainter(this.blobbo);

  final Blobbo blobbo;

  @override
  void paint(Canvas canvas, Size size) {
    final string = Utils.stringToColour('${blobbo.position.x}${blobbo.position.y}');
    final paint = Paint()
      ..color = Color(int.parse(string, radix: 16)).withAlpha(255)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset(blobbo.position.x, 500 - blobbo.position.y), blobbo.size / 2, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
