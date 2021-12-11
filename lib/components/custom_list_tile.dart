import 'package:flutter/material.dart';
import 'package:vload/models/music.dart';
import 'package:vload/utils/constant.dart';

Widget customListTitle({required int id, required List<Music> musics, onTap}) {
  return InkWell(
    onTap: onTap,
    child: Padding(
      padding: const EdgeInsets.all(4.0),
      child: Container(
        height: 100,
        child: Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.0),
                    image: DecorationImage( 
                     fit: BoxFit.cover,
                        image: NetworkImage(
                            "${apiUrl}/musics/${musics[id].musicName}/${musics[id].img}"))),
              ),
              flex: 1,
            ),
            Expanded(child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text("${musics[id].musicName}"),
            ), flex: 3)
          ],
        ),
      ),
    ),
  );
}
