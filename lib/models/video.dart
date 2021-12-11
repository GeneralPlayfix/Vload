import 'dart:convert';


List<Video> videoFromJson(String str) => List<Video>.from(json.decode(str).map((x) => Video.fromJson(x)));

String videoToJson(List<Video> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Video {
    Video({
        required this.id,
        required this.animeName,
        required this.epName,
        required this.link,
        required this.img
    });

    String id;
    String animeName;
    String epName;
    String link;
    String img;

    factory Video.fromJson(Map<String, dynamic> json){
      return Video(
        id: json["id"],
        animeName: json["animeName"],
        epName: json["epName"],
        link: json["link"],
        img: json["img"],
      );
    }

    Map<String, dynamic> toJson() => {
        "id": id,
        "animeName": animeName,
        "epName":epName,
        "video_link": link,
        "thumbnail":img
    };
}
