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
      size: maxSize,
      players: [],
    ),
  );

  @override
  Stream<Game> joinGame(ServiceCall call, Player request) {
    final c = Timer.periodic(
      const Duration(milliseconds: 100),
      (timer) {
        _game.add(
          _game.value
            ..addPlayer(
              Player(
                position: Position(
                  x: Random().nextInt(maxSize).toDouble(),
                  y: Random().nextInt(maxSize).toDouble(),
                ),
                size: 5,
              ),
            ),
        );
      },
    );

    _game.add(_game.value..addPlayer(request));
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

    final intersecator = _game.value.players.firstWhereOrNull(
      (e) => (e.id != p.id) && (p.intersects(e)),
    );

    if (intersecator != null && intersecator.size != p.size) {
      _game.add(
        _game.value..clash(intersecator, p),
      );

      return Future.value(Empty());
    }

    _game.add(
      _game.value..updatePlayer(p),
    );

    return Future.value(Empty());
  }
}
