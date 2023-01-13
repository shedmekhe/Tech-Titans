

import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:team_tracker/screens/home_screen.dart';
import 'package:team_tracker/screens/userInfo.dart';

class UserDetails extends StatelessWidget {

  static const String id = 'user_details';

  UserDetails({Key key}) : super(key: key);

  String name = "";

  String codeName ="";

  @override
  Widget build(BuildContext context) {

  }
}


// userInfo()
// {
//   final box = GetStorage();
//
//   String name = box.read('name');
//   String codeName = box.read('codeName');
//
//
//   if(name != null && codeName != null ) {
//     Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen(name: name, codeName: codeName,)));
//   }
//   else
//   {
//     Navigator.push(context, MaterialPageRoute(builder: (context) => const UserInfo()));
//   }
// }
