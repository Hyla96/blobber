import 'dart:math';

import 'package:blobber_server/gen/game.pb.dart';

extension PlayerExtension on Player {
  bool intersects(
    Position otherPosition,
    double otherSize,
  ) {
    final distance = sqrt(
      pow(otherPosition.x - position.x, 2) + pow(otherPosition.y - position.y, 2),
    );

    return distance < ((size + otherSize) / 2);
  }

  void sum(double size) {
    final factor = (log(this.size) * log(this.size)) / this.size;
    this.size += size * factor;
  }
}
