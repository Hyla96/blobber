import 'package:blobber_client/gen/game.pb.dart';
import 'package:flutter/material.dart';

class BlobboWidget extends StatelessWidget {
  const BlobboWidget(
    this.blobbo, {
    super.key,
  });

  final Blobbo blobbo;

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      key: ValueKey('${blobbo.position.x}|${blobbo.position.y}'),
      left: blobbo.position.x - (blobbo.size / 2),
      bottom: blobbo.position.y - (blobbo.size / 2),
      duration: const Duration(milliseconds: 50),
      child: Container(
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.blue,
        ),
        width: blobbo.size,
        height: blobbo.size,
      ),
    );
  }
}
