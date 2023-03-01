import 'package:blobber_client/gen/game.pbgrpc.dart';
import 'package:blobber_client/util/vm.dart';
import 'package:grpc/grpc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:uuid/uuid.dart';

class GameService extends ViewModel {
  GameService() {
    final channel = ClientChannel(
      'localhost',
      port: 50051,
      options: ChannelOptions(
        credentials: const ChannelCredentials.insecure(),
        codecRegistry: CodecRegistry(codecs: const [GzipCodec(), IdentityCodec()]),
      ),
    );
    stub = GameServiceClient(channel);

    subscriptions.add(
      stub
          .joinGame(
            Player(
              id: id,
              size: 10,
              position: Position(x: 0, y: 0),
            ),
          )
          .listen(
            game.add,
          ),
    );
  }

  void updatePosition(Direction direction) {
    stub.updatePosition(
      Input(
        playerID: id,
        direction: direction,
      ),
    );
  }

  final id = const Uuid().v4();
  final game = BehaviorSubject<Game>();
  late GameServiceClient stub;
}

extension PlayerExtension on Player {
  bool hasDifferentPosition(Position? other) {
    return other?.x != position.x || other?.y != position.y;
  }
}
