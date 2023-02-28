import 'package:blobber_server/gen/game.pb.dart';
import 'package:blobber_server/src/extensions/player_extension.dart';

extension GameExtension on Game {
  void addPlayer(Player player) {
    if (players.any((p) => p.id == player.id)) return;
    players.add(player);
  }

  void _removePlayer(Player player) {
    players.removeWhere((e) => e.id == player.id);
  }

  void updatePlayer(Player player) {
    _removePlayer(player);
    addPlayer(player);
  }

  void clash(Player p1, Player p2) {
    _removePlayer(p2);
    _removePlayer(p1);

    if (p1.size > p2.size) {
      addPlayer(p1..sum(p2.size));
    } else {
      addPlayer(p2..sum(p1.size));
    }
  }

  void removeBlobbo(Blobbo blobbo) {
    blobs.remove(blobbo);
  }
}
