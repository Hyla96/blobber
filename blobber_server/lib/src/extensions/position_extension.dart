import 'package:blobber_server/gen/game.pb.dart';
import 'package:blobber_server/src/constants.dart';

extension PositionExtension on Position {
  Position update(Direction d, double speed) {
    const max = mapSize;
    const min = 0;
    switch (d) {
      case Direction.DIRECTION_UP:
        return Position(x: x, y: y == max ? y : y + speed);
      case Direction.DIRECTION_DOWN:
        return Position(x: x, y: y == min ? y : y - speed);
      case Direction.DIRECTION_LEFT:
        return Position(x: x == min ? x : x - speed, y: y);
      case Direction.DIRECTION_RIGHT:
        return Position(x: x == max ? x : x + speed, y: y);
      default:
        return this;
    }
  }
}
