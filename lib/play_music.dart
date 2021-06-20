import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:mooddetection/widgets/player_widget.dart';

class MusicApp extends StatefulWidget {
  final String url;
  MusicApp({this.url});
  @override
  _MusicAppState createState() => _MusicAppState();
}

class _MusicAppState extends State<MusicApp> {
  //we will need some variables
  bool playing = false; // at the begining we are not playing any song
  bool loading = true; // to show loading while music is being fetched
  IconData playBtn = Icons.play_arrow; // the main state of the play button icon

  //Now let's start by creating our music player
  //first let's declare some object
  AudioPlayer _player;
  // AudioCache cache;
  AudioCache _audioCache = AudioCache();
  Duration position = new Duration();
  Duration musicLength = new Duration();
  int totalDuration = 0;

  //we will create a custom slider

  Widget slider() {
    return Container(
      width: 300.0,
      child: Slider.adaptive(
          activeColor: Colors.blue[800],
          inactiveColor: Colors.grey[350],
          value: position.inSeconds.toDouble(),
          max: musicLength.inSeconds.toDouble(),
          onChanged: (value) {
            seekToSec(value.toInt());
          }),
    );
  }

  // Future<int> _getDuration() async {
  //   final uri = await _audioCache.(widget.url);
  //   await _player.setUrl(uri.toString());
  //   return Future.delayed(
  //     const Duration(seconds: 2),
  //     () => _player.getDuration(),
  //   );
  // }

  //let's create the seek function that will allow us to go to a certain position of the music
  void seekToSec(int sec) {
    Duration newPos = Duration(seconds: sec);
    _player.seek(newPos);
  }

  // void play() async {
  //   print("this is url: ${widget.url}");
  //   int result = await _player.play(widget.url);
  //   if (result == 1) {
  //     // totalDuration = await _getDuration();
  //     setState(() {
  //       // print(totalDuration);
  //       // musicLength = Duration(seconds: dur);
  //       playBtn = Icons.pause;
  //       playing = true;
  //       loading = false;
  //       // musicLength = Duration(minutes: dur);
  //     });
  //   }
  //   var d = _player.onDurationChanged;
  //   d.listen((event) {
  //     print(event.inMilliseconds);
  //   });
  // }
  //
  // void pause() {
  //   _player.pause();
  //   setState(() {
  //     playBtn = Icons.play_arrow;
  //     playing = false;
  //   });
  // }

  void onInit() {
    // play();
  }

  //Now let's initialize our player
  @override
  void initState() {
    super.initState();
    _player = AudioPlayer(mode: PlayerMode.MEDIA_PLAYER);

    onInit();

    //now let's handle the audioplayer time

    // this function will allow you to get the music duration

    //
    // //this function will allow us to move the cursor of the slider while we are playing the song
    // _player.positionHandler = (p) {
    //   setState(() {
    //     position = p;
    //   });
    // };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //let's start by creating the main UI of the app
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.blue[800],
                Colors.blue[200],
              ]),
        ),
        child: Padding(
          padding: EdgeInsets.only(
            top: 48.0,
          ),
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //Let's add some text title
                Padding(
                  padding: const EdgeInsets.only(left: 12.0),
                  child: Text(
                    "Music Beats",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 38.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 12.0),
                  child: Text(
                    "Listen to your favorite Music",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24.0,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                SizedBox(
                  height: 24.0,
                ),
                //Let's add the music cover
                Center(
                  child: Container(
                    width: 280.0,
                    height: 280.0,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30.0),
                        image: DecorationImage(
                          image: AssetImage("assets/sadReachOut.png"),
                        )),
                  ),
                ),

                SizedBox(
                  height: 18.0,
                ),
                Center(
                  child: Text(
                    "Reaching Out Music",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(
                  height: 30.0,
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30.0),
                        topRight: Radius.circular(30.0),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        //Let's start by adding the controller
                        //let's add the time indicator text

                        PlayerWidget(
                          url: widget.url,
                          mode: PlayerMode.MEDIA_PLAYER,
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
