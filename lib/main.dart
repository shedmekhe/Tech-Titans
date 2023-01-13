import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:team_tracker/screens/home_screen.dart';
import 'package:team_tracker/screens/roomPage.dart';
import 'package:team_tracker/screens/room_gen_join.dart';
import 'package:team_tracker/screens/splashScreen.dart';
import 'package:team_tracker/userDetails.dart';
import 'package:team_tracker/screens/userInfo.dart';


void main() async {
  await GetStorage.init();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const TeamTracker());
}

class TeamTracker extends StatelessWidget {
  const TeamTracker({Key key}) : super(key: key);



  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: SplashScreen.id,
      routes: {
        SplashScreen.id: (context) => const SplashScreen(),
        HomeScreen.id: (context) => HomeScreen(),
        UserInfo.id: (context) => const UserInfo(),
        UserDetails.id: (context) => UserDetails(),
        RoomPage.id: (context) => const RoomPage(),
        RoomGenerationJoin.id: (context) => const RoomGenerationJoin(),
      },
    );
  }
}
