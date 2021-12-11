import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';

import 'package:vload/pages/music_page.dart';
import 'package:vload/pages/video_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Viload',
      routes: {
      '/home':(context)=> MyHomePage(),
      '/video': (context) => VideoPage(),
    },
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: AnimatedSplashScreen(
      splash: 'assets/images/vload.jpg',
      splashIconSize: 150,
      nextScreen: MyHomePage(),
      splashTransition: SplashTransition.fadeTransition,
      duration: 1500,
      backgroundColor:Color.fromRGBO(18, 23, 62, 1)
    ),
    );
  }
}
class MyHomePage extends StatefulWidget {
  const MyHomePage({ Key? key }) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int currentIndex = 0;
  final screens = [
    VideoPage(),
    MusicPage()
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:IndexedStack(index: currentIndex, children: screens),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: (index) => setState(()=>currentIndex = index),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "Video",
            ),
             BottomNavigationBarItem(
              icon: Icon(Icons.music_note),
              label: "Musique",
            )
          ],
        ),
    );
  }
}