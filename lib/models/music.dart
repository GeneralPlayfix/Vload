import 'dart:convert';


List<Music> musicFromJson(String str) => List<Music>.from(json.decode(str).map((x) => Music.fromJson(x)));

String musicToJson(List<Music> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Music {
    Music({
        required this.id,
        required this.musicName,
        required this.musicLink,
        required this.img
    });

    int id;
    String musicName;
    String musicLink;
    String img;

    factory Music.fromJson(Map<String, dynamic> json){
      return Music(
        id: json["id"],
        musicName: json["musicName"],
        musicLink: json["musicLink"],
        img: json["img"],
      );
    }

    Map<String, dynamic> toJson() => {
        "id": id,
        "musicName": musicName,
        "musicLink":musicLink,
        "img":img
    };
}
