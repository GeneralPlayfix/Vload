import 'package:flutter/material.dart';
import 'package:vload/Widgets/video_grid.dart';
import 'package:vload/services/video_api.dart';
import 'package:vload/models/video.dart';

class VideoPage extends StatefulWidget {
  const VideoPage({ Key? key }) : super(key: key);

  @override
  _VideoPageState createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  @override
  Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(title: Text("Video")),
        body: Container(
          color: Color.fromRGBO(18, 23, 62, 1),
          child: FutureBuilder(
            future: getVideosFromApi(),
            builder: (context, snapshot){
                print(snapshot);
              if(snapshot.connectionState == ConnectionState.waiting){
                print("en cours");
                return Center(child:CircularProgressIndicator());
              }else if(snapshot.hasError){
                print("erreur");
                print(snapshot.error);
                return Center(child:Text(snapshot.error.toString()));
              }else{
                print("c bon");
                return VideoGrid(videos:snapshot.data as List<Video>);
              }
            },
          ),
        ),
      ) ;
  }
}