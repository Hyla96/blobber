import 'package:blobber_server/gen/game.pb.dart';

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
      p1.size = (p1.size + (p2.size * 0.5)).toDouble();
      addPlayer(p1);
    } else {
      p2.size = (p2.size + (p1.size * 0.5)).toDouble();
      addPlayer(p2);
    }
  }
}
