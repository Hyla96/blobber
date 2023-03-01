import 'package:blobber_client/gen/game.pb.dart';
import 'package:blobber_client/util/utils.dart';
import 'package:flutter/material.dart';

class PlayerPainter extends CustomPainter {
  PlayerPainter(this.player);

  final Player player;

  @override
  void paint(Canvas canvas, Size size) {
    final string = Utils.stringToColour(player.id);
    final paint = Paint()
      ..color = Color(int.parse(string, radix: 16)).withAlpha(255)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset(player.position.x, 500 - player.position.y), player.size / 2, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
