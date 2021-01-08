import 'package:animate_do/animate_do.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:musicapp/src/helpers/helpers.dart';
import 'package:musicapp/src/models/audio_model.dart';
import 'package:musicapp/src/widgets/custom_appbar.dart';
import 'package:provider/provider.dart';

class MusicPlayerPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Background(),
          Column(
            children: [
              CustomAppBar(),
              ImagenDiscoDuracion(),
              TituloPlay(),
              Expanded(
                child: Lyrics(),
              )
            ],
          ),
        ],
      ),
    );
  }
}

class Background extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Container(
      width: double.infinity,
      height: screenSize.height * 0.8,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(60)),
          gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.center,
              colors: [Color(0xff33333E), Color(0xff201E28)])),
    );
  }
}

class Lyrics extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final lyrics = getLyrics();
    return Container(
      child: ListWheelScrollView(
        physics: BouncingScrollPhysics(),
        itemExtent: 42,
        diameterRatio: 2.5,
        children: lyrics
            .map((linea) => Text(
                  linea,
                  style: TextStyle(
                      fontSize: 20, color: Colors.white.withOpacity(0.6)),
                ))
            .toList(),
      ),
    );
  }
}

class TituloPlay extends StatefulWidget {
  @override
  _TituloPlayState createState() => _TituloPlayState();
}

class _TituloPlayState extends State<TituloPlay>
    with SingleTickerProviderStateMixin {
  bool isPlaying = false;
  bool firstTime = true;
  AnimationController playAnimation;

  final assetAudioPlayer = new AssetsAudioPlayer();

  @override
  void initState() {
    // TODO: implement initState
    playAnimation =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    this.playAnimation.dispose();
    super.dispose();
  }

  void open() {
    final audioModel = Provider.of<AudioModel>(context, listen: false);

    assetAudioPlayer.open(
      Audio("assets/Breaking-Benjamin-Far-Away.mp3"),
    );

    assetAudioPlayer.currentPosition.listen((duracion) {
      audioModel.current = duracion;
    });

    assetAudioPlayer.current.listen((playAudio) {
      audioModel.songDuration = playAudio.audio.duration;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 40),
      margin: EdgeInsets.symmetric(vertical: 20),
      child: Row(
        children: [
          Column(
            children: [
              Text(
                "Far Away",
                style: TextStyle(
                    fontSize: 30, color: Colors.white.withOpacity(0.8)),
              ),
              Text(
                "-Beaking Benjamin-",
                style: TextStyle(
                    fontSize: 15, color: Colors.white.withOpacity(0.5)),
              )
            ],
          ),
          Spacer(),
          FloatingActionButton(
            elevation: 0,
            highlightElevation: 0,
            backgroundColor: Color(0xffF8CB51),
            child: AnimatedIcon(
              icon: AnimatedIcons.play_pause,
              progress: playAnimation,
            ),
            onPressed: () {
              final audioModel =
                  Provider.of<AudioModel>(context, listen: false);

              if (this.isPlaying) {
                playAnimation.reverse();
                this.isPlaying = false;
                audioModel.controller.stop();
              } else {
                playAnimation.forward();
                this.isPlaying = true;
                audioModel.controller.repeat();
              }

              if (firstTime) {
                this.open();
                firstTime = false;
              } else {
                assetAudioPlayer.playOrPause();
              }
            },
          )
        ],
      ),
    );
  }
}

class ImagenDiscoDuracion extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30),
      margin: EdgeInsets.only(top: 50),
      child: Row(
        children: [
          //disco
          ImagenDisco(),
          Spacer(),
          //barra de progreso
          BarraProgreso(),
        ],
      ),
    );
  }
}

class BarraProgreso extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final audioModel = Provider.of<AudioModel>(context);
    final porcentaje = audioModel.porcentaje;

    final estiloTiempo = TextStyle(color: Colors.white.withOpacity(0.4));
    return Container(
      child: Column(
        children: [
          Text(
            "${audioModel.songTotalDuration}",
            style: estiloTiempo,
          ),
          SizedBox(
            height: 10,
          ),
          Stack(
            children: [
              Container(
                width: 3,
                height: 200,
                color: Colors.white.withOpacity(0.1),
              ),
              Positioned(
                bottom: 0,
                child: Container(
                  width: 4,
                  height: 200 * porcentaje,
                  color: Colors.white.withOpacity(0.8),
                ),
              )
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            "${audioModel.currentSecond}",
            style: estiloTiempo,
          ),
        ],
      ),
    );
  }
}

class ImagenDisco extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final audioModel = Provider.of<AudioModel>(context);
    return Container(
      padding: EdgeInsets.all(20),
      width: 200,
      height: 200,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(200),
        child: Stack(
          alignment: Alignment.center,
          children: [
            SpinPerfect(
              duration: Duration(seconds: 10),
              infinite: true,
              manualTrigger: true,
              controller: (animationController) =>
                  audioModel.controller = animationController,
              child: Image(
                image: AssetImage("assets/aurora.jpg"),
              ),
            ),
            Container(
              width: 25,
              height: 25,
              decoration: BoxDecoration(
                  color: Colors.black38,
                  borderRadius: BorderRadius.circular(100)),
            ),
            Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                  color: Color(0xff1C1C25),
                  borderRadius: BorderRadius.circular(100)),
            )
          ],
        ),
      ),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(200),
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              colors: [Color(0xff484750), Color(0xff1E1C24)])),
    );
  }
}
