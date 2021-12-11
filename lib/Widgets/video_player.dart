import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:vload/main.dart';
import 'package:vload/models/video.dart';
import 'package:vload/utils/constant.dart';

class VideoPlay extends StatefulWidget { 
  final VideoPlayerController videoPlayerController;
  final bool loop;
  const VideoPlay(
      {required this.videoPlayerController, required this.loop, Key? key})
      : super(key: key);

  @override
  _VideoState createState() => _VideoState();
}

class _VideoState extends State<VideoPlay> {
  late ChewieController _chewieController;
  @override
  void initState() {
    _chewieController = ChewieController(
      videoPlayerController: widget.videoPlayerController,
      allowPlaybackSpeedChanging: true,
      looping: widget.loop,
      showControls: true,
      aspectRatio: 16/9,
      autoInitialize: true, 
    );
    print(widget.videoPlayerController.value.size);
    super.initState();
  }


  void add10sec(){
    widget.videoPlayerController.seekTo(const Duration(seconds: 12));
  }
  @override
  Widget build(BuildContext context) {
    return Chewie(
      controller: _chewieController,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _chewieController.dispose();
    widget.videoPlayerController.dispose();
  }
}

class VideoPlayer extends StatefulWidget {
  final List<Video> allVideos;
  final int videoIndex;
  const VideoPlayer(
      {required this.allVideos, required this.videoIndex, Key? key})
      : super(key: key);

  @override
  _VideoPlayerState createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<VideoPlayer> {
  @override
  Widget build(BuildContext context) {
  int videoIndex = widget.videoIndex - 1;
    int size = widget.allVideos.length;
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () =>Navigator.pushNamedAndRemoveUntil(context, "/home", (_) => false),
          ),
          title: Text("${widget.allVideos[videoIndex].epName}"),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Container(
              height: 220,
              child: VideoPlay(
                videoPlayerController: VideoPlayerController.network(
                    "${apiUrl}videos/${widget.allVideos[videoIndex].link}"),
                loop: true,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Précédent"),
                IconButton(
                    icon: Icon(Icons.navigate_before_sharp),
                    onPressed: () {
                      if (!(videoIndex == 0)) {
                        int previousVideo = videoIndex;
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => VideoPlayer(
                                      allVideos: widget.allVideos,
                                      videoIndex: previousVideo,
                                    )));
                      }
                    }),
                IconButton(
                    icon: Icon(Icons.navigate_next),
                    onPressed: () {
                      if (!(videoIndex ==
                          (widget.allVideos.length -1))) {
                        int nextVideo = videoIndex + 2;
                        Navigator.push(
                          
                            context,
                            MaterialPageRoute(
                                builder: (context) => VideoPlayer(
                                      allVideos: widget.allVideos,
                                      videoIndex: nextVideo,
                                    )));
                      }
                    }),
                Text("Suivant"),
              ],
            ),
            Expanded(
                child: ListView.builder(
                    itemCount: widget.allVideos.length,
                    itemExtent: 200,
                    itemBuilder: (BuildContext context, int index) {
                      if (!(index == videoIndex)) {
                        return GestureDetector(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => VideoPlayer(
                                allVideos: widget.allVideos,
                                videoIndex: int.parse(widget.allVideos[index].id),
                              ),
                            ),
                          ),
                          child: Stack(
                            children: [
                              Container(
                                width: double.infinity,
                                height: double.infinity,
                                padding: EdgeInsets.all(2.0),
                                child: Image.network(
                                    "${apiUrl}/images/${widget.allVideos[index].img}",
                                    fit: BoxFit.cover),
                              ),
                              Align(
                                alignment: Alignment.bottomCenter,
                                child: Container(
                                  height: 35,
                                  color: Colors.black.withOpacity(0.6),
                                  child: Center(
                                      child: Text(
                                    "${widget.allVideos[index].epName}",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.white),
                                  )),
                                ),
                              ),
                            ],
                          ),
                        );
                      } else {
                        return Stack(
                          children: [
                            Container(
                              width: double.infinity,
                              height: double.infinity,
                              padding: EdgeInsets.all(2.0),
                              child: Image.network(
                                  "${apiUrl}/images/${widget.allVideos[index].img}",
                                  fit: BoxFit.cover),
                            ),
                            Align(
                              alignment: Alignment.topRight,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.red),
                                  height: 35,
                                  width: 150,
                                  child: Center(
                                    child: Text(
                                      "En cours...",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                height: 35,
                                color: Colors.black.withOpacity(0.6),
                                child: Center(
                                    child: Text(
                                  "${widget.allVideos[index].epName}",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.white),
                                )),
                              ),
                            ),
                          ],
                        );
                      }
                    })) // ignore: unused_local_variable
          ],
        ));
  }
}
