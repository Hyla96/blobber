import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:dart_frog/dart_frog.dart';
import 'package:dart_frog_web_socket/dart_frog_web_socket.dart';
import 'package:rxdart/rxdart.dart';

final positions = BehaviorSubject<Map<int, Player>>();

var id = 0;

final pos = BehaviorSubject<Player>.seeded(const Player.zero());

Timer? timer;
var generatedId = 0;

Future<Response> onRequest(RequestContext context) async {
  timer ??= Timer.periodic(
    const Duration(milliseconds: 1500),
    (timer) {
      generatedId--;
      positions.add(
        positions.value..[generatedId] = Player.generated(),
      );
    },
  );

  final handler = webSocketHandler(
    (channel, protocol) {
      final _id = id++;

      print('Client $_id connected');

      positions.add((positions.valueOrNull ?? {})..[_id] = const Player.zero());

      var disconnected = false;

      channel.stream.listen(
        (message) {
          print('received: $message');
          final data = int.tryParse(message.toString());
          if (data != null) {
            final newPosition = positions.value[_id]! + data;

            if (positions.value.entries.any(
              (e) => (e.key != _id) && (e.value.intersects(newPosition)),
            )) {
              final intersecator = positions.value.entries.firstWhere(
                (e) => (e.key != _id) && (e.value.intersects(newPosition)),
              );

              if (intersecator.value.size == newPosition.size) {
                positions.add(
                  positions.value..[_id] = newPosition,
                );
              } else if (intersecator.value.size > newPosition.size) {
                positions.add(
                  positions.value
                    ..[intersecator.key] = intersecator.value * positions.value[_id]!
                    ..[_id] = Player.dead(),
                );
              } else {
                positions.add(
                  positions.value
                    ..[_id] = intersecator.value * positions.value[_id]!
                    ..[intersecator.key] = Player.dead(),
                );
              }
            } else {
              positions.add(
                positions.value..[_id] = newPosition,
              );
            }
          }
        },
        onDone: () {
          print('Client $_id disconnected');
          positions.add(
            positions.value..remove(_id),
          );
          disconnected = true;
        },
      );

      positions.stream.listen(
        (event) {
          if (!disconnected) {
            channel.sink.add(
              jsonEncode(
                event.map(
                  (key, value) => MapEntry(
                    key.toString(),
                    [
                      value.x,
                      value.y,
                      value.size,
                    ],
                  ),
                ),
              ),
            );
          }
        },
      );
    },
  );

  return handler(context);
}

const max = 500;

class Player {
  const Player({
    required this.x,
    required this.y,
    required this.size,
  });

  const Player.zero() : this(x: 0, y: 0, size: 10);
  const Player.dead() : this(x: -1, y: -1, size: 0);

  Player.generated()
      : this(
          x: Random().nextInt(max).toDouble(),
          y: Random().nextInt(max).toDouble(),
          size: 5,
        );

  /// Each player is a circle with a radius of [size] pixels and
  /// a center at [x], [y].
  /// This method checks if the other player intersects with this one,
  /// or vice versa.
  bool intersects(Player other) {
    final distance = sqrt(
      pow(other.x - x, 2) + pow(other.y - y, 2),
    );

    print('distance: $distance, size: $size, other.size: ${other.size}');
    return distance < ((size + other.size) / 2);
  }

  Player operator +(int other) {
    final velocity = 100 / size;
    switch (other) {
      case 0:
        if (y == max) {
          return Player(x: x, y: y, size: size);
        }
        return Player(x: x, y: y + velocity, size: size);
      case 1:
        if (y == 0) {
          return Player(x: x, y: y, size: size);
        }
        return Player(x: x, y: y - velocity, size: size);
      case 2:
        if (x == 0) {
          return Player(x: x, y: y, size: size);
        }
        return Player(x: x - velocity, y: y, size: size);
      case 3:
        if (x == max) {
          return Player(x: x, y: y, size: size);
        }
        return Player(x: x + velocity, y: y, size: size);
    }
    return Player(x: x, y: y, size: size);
  }

  Player operator *(Player other) {
    print('other: $other, this: $this');
    if (other.size > size) {
      return Player(
        x: other.x,
        y: other.y,
        size: other.size + (size * 0.5),
      );
    } else {
      return Player(
        x: x,
        y: y,
        size: size + (other.size * 0.5),
      );
    }
  }

  final double x;
  final double y;
  final double size;

  @override
  String toString() {
    return 'Player{x: $x, y: $y, size: $size}';
  }
}
