import 'package:http/http.dart' as http;
import 'package:vload/models/video.dart';
import 'package:vload/utils/constant.dart';

Future <List<Video>> getVideosFromApi() async{
    var url = Uri.parse(apiUrl);
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var json = response.body;
      return videoFromJson(json);
    } else {
      return [];
    }
}