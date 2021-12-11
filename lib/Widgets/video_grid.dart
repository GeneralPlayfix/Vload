import 'package:flutter/material.dart';
import 'package:vload/Widgets/video_player.dart';
import 'package:vload/models/video.dart';
import 'package:vload/utils/constant.dart';

class VideoGrid extends StatefulWidget {
  final List<Video> videos;
  const VideoGrid({required this.videos, Key? key}) : super(key: key);

  @override
  _VideoGridState createState() => _VideoGridState();
}

class _VideoGridState extends State<VideoGrid> {
  late  List<Video> _displayVideos;
  bool _isLoading = true;
  @override
  void initState() {
    setState(() {
      _isLoading = false;
      _displayVideos = widget.videos;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: _displayVideos.length + 1,
        itemExtent: 100,
        itemBuilder: (BuildContext context, int index) {
          if (!_isLoading) {
            return index == 0
                ? _searchBar()
                : _listItem(index - 1, context);
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }

  _searchBar() {
    return Padding(
        padding: EdgeInsets.all(8.0),
        child: TextField(
          cursorColor: Colors.white,
          style: TextStyle(color: Colors. white),
          decoration: InputDecoration(labelText: 'Recherche', labelStyle: TextStyle( color: Colors.white),enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0), borderSide: BorderSide(color: Colors.white, width: 2.0),
    ), prefixIcon: Icon(Icons.search, color: Colors.white,), focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: 2, color: Colors.white),
                  borderRadius: BorderRadius.circular(15),
                )),
          onChanged: (text) {
            text = text.toLowerCase();
            setState(() {
              _displayVideos = widget.videos.where((element){
                var epName = element.epName.toLowerCase();
                return epName.contains(text);
              }).toList();
            });
          },
        ));
  }

  _listItem(index, context) {
    return GestureDetector(
        onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => VideoPlayer(
                        allVideos: widget.videos,
                        videoIndex: int.parse(_displayVideos[index].id),
                      )),
            ),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                // border: Border.all(color: Colors.white),
                color: const Color.fromRGBO(68, 31, 201, 1),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black54,
                    blurRadius: 4,
                    offset: Offset(4, 8), // Shadow position
                  ),
                ],
              ),
              padding: EdgeInsets.all(5.0),
              child: _VideoTile(
                  _displayVideos[index].epName, _displayVideos[index].img)),
        ));
  }

  _VideoTile(String title, String thumbnail) {
    return Row(children: [
      Expanded(
          flex: 1,
          child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network("${apiUrl}/images/${thumbnail}",
                  height: 100, fit: BoxFit.cover))),
      Expanded(
          flex: 2,
          child: Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                Text(
                  "${title}",
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
                const Text(
                  "1920x1080",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                )
              ]))),
    ]);
  }
}
