import 'package:http/http.dart' as http;
import 'package:vload/models/music.dart';
import 'package:vload/utils/constant.dart';

Future <List<Music>> getMusicsFromApi() async{
    var url = Uri.parse(musicApiUrl);
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var json = response.body;
      return musicFromJson(json);
    } else {
      return [];
    }
}