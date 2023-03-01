import 'package:blobber_client/gen/game.pb.dart';
import 'package:flutter/material.dart';

class PlayerWidget extends StatelessWidget {
  const PlayerWidget(
    this.player, {
    super.key,
  });

  final Player player;

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      key: ValueKey(player.id),
      left: player.position.x - (player.size / 2),
      bottom: player.position.y - (player.size / 2),
      duration: const Duration(milliseconds: 100),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        curve: Curves.elasticOut,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.red,
        ),
        width: player.size,
        height: player.size,
      ),
    );
  }
}
