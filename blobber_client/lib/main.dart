import 'package:blobber_client/gen/game.pb.dart';
import 'package:blobber_client/service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final service = Service();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: KeyboardListener(
        focusNode: FocusNode(),
        autofocus: false,
        onKeyEvent: (KeyEvent event) {
          if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
            service.updatePosition(Direction.DIRECTION_UP);
          } else if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
            service.updatePosition(Direction.DIRECTION_DOWN);
          } else if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
            service.updatePosition(Direction.DIRECTION_LEFT);
          } else if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
            service.updatePosition(Direction.DIRECTION_RIGHT);
          }
        },
        child: Center(
          child: StreamBuilder<Game>(
            stream: service.game.stream,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const CircularProgressIndicator.adaptive();
              }

              final game = snapshot.data!;
              return Stack(
                children: [
                  Container(
                    width: game.size.toDouble(),
                    height: game.size.toDouble(),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: Colors.grey,
                        width: 1,
                      ),
                    ),
                  ),
                  ...game.players.map(
                    (e) {
                      final color = Colors.red;

                      return AnimatedPositioned(
                        key: ValueKey(e.id),
                        left: e.position.x - (e.size! / 2),
                        bottom: e.position.y - (e.size! / 2),
                        duration: const Duration(milliseconds: 50),
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: color,
                          ),
                          width: e.size,
                          height: e.size,
                        ),
                      );
                    },
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
