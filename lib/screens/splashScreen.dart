import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:team_tracker/screens/userInfo.dart';

import 'home_screen.dart';

class SplashScreen extends StatefulWidget {

  static const String id = 'splash_screen';

  const SplashScreen({Key key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final box = GetStorage();
  @override
  void initState(){
    Timer(
      const Duration(seconds: 3),
          ()=>Navigator.pushReplacement(context,
        MaterialPageRoute(builder:
            (context) => box.read('name')==null?const UserInfo():HomeScreen()
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const DecoratedBox(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
            'Images/track.jpeg',
          ),
          fit: BoxFit.fill,
        ),
      ),
      child: Center(
        child: Text(
          'TeamTracker',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
    // return Scaffold(
    //   body: Container(
    //       height: double.infinity,
    //       width: double.infinity,
    //       decoration: const BoxDecoration(
    //         image: DecorationImage(
    //             image: AssetImage("Images/track.jpeg"),
    //             fit: BoxFit.cover),
    //       ),
    //       child: Text('Team Tracker'),// Foreground widget here
    //   )
    // );
  }
}
