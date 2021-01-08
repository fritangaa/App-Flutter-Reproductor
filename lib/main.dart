import 'package:flutter/material.dart';
import 'package:musicapp/src/models/audio_model.dart';
import 'package:musicapp/src/pages/music_player_page.dart';
import 'package:musicapp/src/theme/theme.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => new AudioModel())],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: miTema,
        home: MusicPlayerPage(),
      ),
    );
  }
}
