import 'dart:math';

import 'package:blobber_server/gen/game.pb.dart';

extension PlayerExtension on Player {
  bool intersects(Player other) {
    final distance = sqrt(
      pow(other.position.x - position.x, 2) + pow(other.position.y - position.y, 2),
    );

    print('distance: $distance, size: $size, other.size: ${other.size}');
    return distance < ((size + other.size) / 2);
  }
}
