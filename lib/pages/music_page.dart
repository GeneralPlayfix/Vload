import 'package:audioplayers/notifications.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:vload/components/custom_list_tile.dart';
import 'package:vload/models/music.dart';
import 'package:vload/services/music_api.dart';
import 'package:vload/utils/constant.dart';

class MusicPage extends StatefulWidget {
  const MusicPage({Key? key}) : super(key: key);

  @override
  _MusicPageState createState() => _MusicPageState();
}

class _MusicPageState extends State<MusicPage> {
  List<Music> musics = [];
  bool isLoad = false;
  int currentId = -1;
  IconData ouiIcon = Icons.pause;

  AudioPlayer audioPlayer = new AudioPlayer(mode: PlayerMode.MEDIA_PLAYER);
  bool isPlaying = false;
  String currentSong = "";

  Duration duration = new Duration();
  Duration position = new Duration();
  @override
  void initState() {
    super.initState();
    init();
  }

  Future init() async {
    final musics = await getMusicsFromApi();
    setState(() {
      this.musics = musics;
    });
  }

  void playMusic(String url) async {
    if (isPlaying && currentSong != url) {
      audioPlayer.pause();
      int result = await audioPlayer.play(url);
      if (result == 1) {
        setState(() {
          currentSong = url;
          ouiIcon = Icons.pause;
        });
      }
    } else if (!isPlaying) {
      int result = await audioPlayer.play(url);
      if (result == 1) {
        setState(() {
          isPlaying = true;
          ouiIcon = Icons.pause;
        });
      }
    }
    audioPlayer.onDurationChanged.listen((event) {
      setState(() {
        duration = event;
      });
    });
    audioPlayer.onAudioPositionChanged.listen((event) {
      setState(() {
        //  print(event);
        position = event;
      });
    });
    audioPlayer.onPlayerCompletion.listen((event) {
      setState(() {
        ouiIcon = Icons.play_arrow;
      }); 
    });
  }

  void seekToSec(int sec) {
    Duration newPos = Duration(seconds: sec);
    audioPlayer.seek(newPos);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            "Mes musiques",
          ),
          elevation: 0,
        ),
        body: _musicGrid(musics));
  }

  _musicGrid(List<Music> musics) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
              itemCount: musics.length,
              itemBuilder: (context, index) => customListTitle(
                    onTap: () {
                      playMusic(
                          "${apiUrl}musics/${musics[index].musicName}/${musics[index].musicLink}");
                      setState(() {
                        currentId = musics[index].id;
                      });
                    },
                    id: musics[index].id,
                    musics: musics,
                  )),
        ),
        currentId != -1
            ? Container(
                decoration: BoxDecoration(color: Colors.white, boxShadow: [
                  BoxShadow(
                    color: Color(0x55212121),
                    blurRadius: 8.0,
                  ),
                ]),
                child: Column(
                  children: [
                    Slider.adaptive(
                      value: position.inSeconds.toDouble(),
                      min: 0.0,
                      max: duration.inSeconds.toDouble(),
                      onChanged: (value) {
                        setState(() {
                          seekToSec(value.toInt());
                        });
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          bottom: 8.0, left: 12.0, right: 12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            height: 60.0,
                            width: 60.0,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                image: DecorationImage(
                                    image: NetworkImage(
                                        "${apiUrl}musics/${musics[currentId].musicName}/${musics[currentId].img}"))),
                          ),
                          SizedBox(
                            width: 10.0,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  musics[currentId].musicName,
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              if (currentId == 0) {
                                var index = musics.length - 1;
                                playMusic(
                                    "${apiUrl}musics/${musics[index].musicName}/${musics[index].musicLink}");
                                setState(() {
                                  currentId = musics[index].id;
                                });
                              } else if (currentId > 0) {
                                var index = currentId - 1;
                                playMusic(
                                    "${apiUrl}musics/${musics[index].musicName}/${musics[index].musicLink}");
                                setState(() {
                                  currentId = musics[index].id;
                                });
                              }
                            },
                            iconSize: 24.0,
                            icon: Icon(Icons.skip_previous),
                          ),
                          IconButton(
                            onPressed: () {
                              if (isPlaying) {
                                audioPlayer.pause();
                                setState(() {
                                  ouiIcon = Icons.play_arrow;
                                  isPlaying = false;
                                });
                              } else {
                                audioPlayer.resume();
                                setState(() {
                                  ouiIcon = Icons.pause;
                                  isPlaying = true;
                                });
                              }
                            },
                            iconSize: 24.0,
                            icon: Icon(ouiIcon),
                          ),
                          IconButton(
                            onPressed: () {
                              if (currentId < musics.length - 1) {
                                var index = currentId + 1;
                                playMusic(
                                    "${apiUrl}musics/${musics[index].musicName}/${musics[index].musicLink}");
                                setState(() {
                                  currentId = musics[index].id;
                                });
                              } else if (currentId == musics.length - 1) {
                                var index = 0;
                                playMusic(
                                    "${apiUrl}musics/${musics[index].musicName}/${musics[index].musicLink}");
                                setState(() {
                                  currentId = musics[index].id;
                                });
                              }
                            },
                            iconSize: 24.0,
                            icon: Icon(Icons.skip_next),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              )
            : Text("")
      ],
    );
  }
}
