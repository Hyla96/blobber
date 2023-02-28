import 'package:blobber_server/src/game_service.dart';
import 'package:grpc/grpc.dart';

Future<void> main(List<String> args) async {
  final server = Server(
    [GameService()],
    [],
    CodecRegistry(
      codecs: const [GzipCodec(), IdentityCodec()],
    ),
  );
  await server.serve(port: 50051);
  print('Server listening on port ${server.port}...');
}
