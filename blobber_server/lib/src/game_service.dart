import 'dart:async';
import 'dart:math';

import 'package:blobber_server/gen/game.pbgrpc.dart';
import 'package:blobber_server/src/constants.dart';
import 'package:blobber_server/src/extensions/game_extension.dart';
import 'package:blobber_server/src/extensions/player_extension.dart';
import 'package:blobber_server/src/extensions/position_extension.dart';
import 'package:collection/collection.dart';
import 'package:grpc/grpc.dart';
import 'package:rxdart/rxdart.dart';

class GameService extends GameServiceBase {
  final _game = BehaviorSubject<Game>.seeded(
    Game(
      size: mapSize,
      players: [],
    ),
  );

  @override
  Stream<Game> joinGame(ServiceCall call, Player request) {
    final c = Timer.periodic(
      const Duration(milliseconds: 1000),
      (timer) {
        _game.add(
          _game.value
            ..blobs.add(
              Blobbo(
                position: Position(
                  x: Random().nextDouble() * mapSize,
                  y: Random().nextDouble() * mapSize,
                ),
                size: Random().nextDouble() * initialPlayerSize,
              ),
            ),
        );
      },
    );

    _game.add(
      _game.value
        ..addPlayer(
          Player(
            id: request.id,
            name: request.name,
            size: initialPlayerSize,
            position: Position(
              x: Random().nextDouble() * mapSize,
              y: Random().nextDouble() * mapSize,
            ),
          ),
        ),
    );
    return _game.stream;
  }

  @override
  Future<Empty> updatePosition(ServiceCall call, Input request) async {
    print(request);

    final p = _game.value.players.firstWhere(
      (element) => element.id == request.playerID,
    );

    final newPosition = p.position.update(
      request.direction,
      100 / p.size,
    );

    p.position = newPosition;

    final eatableBlobs = _game.value.blobs.where(
      (e) => p.intersects(e.position, e.size),
    );

    for (final b in eatableBlobs) {
      p.sum(b.size);
      _game.add(
        _game.value..removeBlobbo(b),
      );
    }

    final playerIntersecator = _game.value.players.firstWhereOrNull(
      (e) => (e.id != p.id) && (p.intersects(e.position, e.size)),
    );

    if (playerIntersecator != null && playerIntersecator.size != p.size) {
      _game.add(
        _game.value..clash(playerIntersecator, p),
      );

      return Future.value(Empty());
    }

    _game.add(
      _game.value..updatePlayer(p),
    );

    return Future.value(Empty());
  }
}
