import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:team_tracker/modal/animation.dart';
import 'package:team_tracker/screens/roomPage.dart';
import 'dart:math';
import 'package:location/location.dart' as loc;
import 'package:permission_handler/permission_handler.dart';

class RoomGenerationJoin extends StatefulWidget {
  static const String id = "Room_gen_join";

  final bool type;

  const RoomGenerationJoin({Key key, this.type}) : super(key: key);

  @override
  State<RoomGenerationJoin> createState() => _RoomGenerationJoinState();
}

class _RoomGenerationJoinState extends State<RoomGenerationJoin> {
  final loc.Location location = loc.Location();
  StreamSubscription<loc.LocationData> _locationSubscription;
  final box = GetStorage();
  String room_name;
  String roomCodeforjoin;
  _getLocation(String roomId, String userId) async {
    try {
      String name = box.read('name');
      final loc.LocationData _locationResult = await location.getLocation();
      await FirebaseFirestore.instance
          .collection('location')
          .doc(roomId)
          .collection("users")
          .doc(userId)
          .set({
        'latitude': _locationResult.latitude,
        'longitude': _locationResult.longitude,
        'altitude': _locationResult.altitude,
        'accuracy': _locationResult.accuracy,
        'verticalAccuracy': _locationResult.verticalAccuracy,
        'name': name
      }, SetOptions(merge: true));
    } catch (e) {
      print(e);
    }
  }

  _create_Room(String roomId, String roomName) async {
    await FirebaseFirestore.instance
        .collection('location')
        .doc(roomId)
        .set({"room_name": roomName}, SetOptions(merge: true));
  }

  Future<void> _listenLocation(String roomId, String userId) async {
    _locationSubscription = location.onLocationChanged.handleError((onError) {
      print(onError);
      _locationSubscription?.cancel();
      setState(() {
        _locationSubscription = null;
      });
    }).listen((loc.LocationData currentlocation) async {
      String name = box.read('name');
      await FirebaseFirestore.instance
          .collection('location')
          .doc(roomId)
          .collection("users")
          .doc(userId)
          .set({
        'latitude': currentlocation.latitude,
        'longitude': currentlocation.longitude,
        'accuracy': currentlocation.accuracy,
        'altitude': currentlocation.altitude,
        'verticalAccuracy': currentlocation.verticalAccuracy,
        'name': name
      }, SetOptions(merge: true));
    });
  }

  _stopListening() {
    _locationSubscription?.cancel();
    setState(() {
      _locationSubscription = null;
    });
  }

  _requestPermission() async {
    var status = await Permission.location.request();
    if (status.isGranted) {
      print('done');
    } else if (status.isDenied) {
      _requestPermission();
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
    }
  }

  @override
  void initState() {
    super.initState();
    _requestPermission();
    location.changeSettings(interval: 300, accuracy: loc.LocationAccuracy.high);
    location.enableBackgroundMode(enable: true);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.type == true) {
      return Scaffold(
        body: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              colors: [
                Colors.lightGreen.shade900,
                Colors.lightGreen.shade800,
                Colors.lightGreen.shade400,
              ],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(
                height: 80,
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const <Widget>[
                    FadeAnimation(
                        1,
                        Text(
                          "Room Creation",
                          style: TextStyle(color: Colors.white, fontSize: 40),
                        )),
                    SizedBox(
                      height: 10,
                    ),
                    FadeAnimation(
                        1.3,
                        Text(
                          "Enter Room Name ",
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        )),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(60),
                          topRight: Radius.circular(60))),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(30),
                      child: Column(
                        children: <Widget>[
                          const SizedBox(
                            height: 60,
                          ),
                          FadeAnimation(
                              1.4,
                              Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.lightGreen.shade400,
                                          blurRadius: 20,
                                          offset: const Offset(0, 10))
                                    ]),
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                          border: Border(
                                              bottom: BorderSide(
                                                  color:
                                                      Colors.grey.shade200))),
                                      child: TextField(
                                        decoration: const InputDecoration(
                                            hintText: "Room Name",
                                            hintStyle:
                                                TextStyle(color: Colors.grey),
                                            border: InputBorder.none),
                                        onChanged: (value) {
                                          room_name = value;
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                          const SizedBox(
                            height: 40,
                          ),
                          FadeAnimation(
                              1.6,
                              TextButton(
                                onPressed: () async {
                                  if (room_name == null) {
                                    const snackBar = SnackBar(
                                      content: Text('Enter Room Name'),
                                    );
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackBar);
                                  } else {
                                    String roomCode = generateRandomString(6);
                                    print("room code " + roomCode.toString());
                                    _create_Room(roomCode, room_name);

                                    var snapshot = await FirebaseFirestore
                                        .instance
                                        .collection('location')
                                        .doc(roomCodeforjoin)
                                        .collection("users")
                                        .get();

                                    var username =
                                        "user" + (snapshot.size + 1).toString();
                                    print(
                                        "Number of users : count " + username);
                                    _getLocation(roomCode, username);
                                    _listenLocation(roomCode, username);

                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => RoomPage(
                                                title: room_name,
                                                roomId: roomCode,
                                                user_id: username, locationSubscription : _locationSubscription)));
                                  }
                                },
                                child: Container(
                                  height: 50,
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 50),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                      color: Colors.lightGreen[600]),
                                  child: Center(
                                    child: ElevatedButton(
                                        style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  Colors.lightGreen[600]),
                                        ),
                                        child: const Text(
                                          "Generate Code",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        )),
                                  ),
                                ),
                              )),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      );
    } else {
      return Scaffold(
        body: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              colors: [
                Colors.lightGreen.shade900,
                Colors.lightGreen.shade800,
                Colors.lightGreen.shade400,
              ],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(
                height: 80,
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const <Widget>[
                    FadeAnimation(
                        1,
                        Text(
                          "Room Joining",
                          style: TextStyle(color: Colors.white, fontSize: 40),
                        )),
                    SizedBox(
                      height: 10,
                    ),
                    FadeAnimation(
                        1.3,
                        Text(
                          "Enter Room Code ",
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        )),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(60),
                          topRight: Radius.circular(60))),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(30),
                      child: Column(
                        children: <Widget>[
                          const SizedBox(
                            height: 60,
                          ),
                          FadeAnimation(
                              1.4,
                              Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.lightGreen.shade400,
                                          blurRadius: 20,
                                          offset: const Offset(0, 10))
                                    ]),
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                          border: Border(
                                              bottom: BorderSide(
                                                  color:
                                                      Colors.grey.shade200))),
                                      child: TextField(
                                        decoration: const InputDecoration(
                                            hintText: "Enter Code",
                                            hintStyle:
                                                TextStyle(color: Colors.grey),
                                            border: InputBorder.none),
                                        onChanged: (value) {
                                          roomCodeforjoin = value;
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                          const SizedBox(
                            height: 40,
                          ),
                          FadeAnimation(
                              1.6,
                              TextButton(
                                onPressed: () async {
                                  roomCodeforjoin = roomCodeforjoin.trim();

                                  if (roomCodeforjoin == null ||
                                      roomCodeforjoin.length != 6) {
                                    const snackBar = SnackBar(
                                      content: Text('Room Name is Invalid'),
                                    );
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackBar);
                                  } else {
                                    var snapshot1 = await FirebaseFirestore
                                        .instance
                                        .collection('location')
                                        .get();
                                    String check;
                                    print(snapshot1.docs.length);
                                    snapshot1.docs.forEach((element) {
                                      if (element.id == roomCodeforjoin) {
                                        check = element.id;
                                      }
                                    });
                                    if (check == roomCodeforjoin) {
                                      var snapshot = await FirebaseFirestore
                                          .instance
                                          .collection('location')
                                          .doc(roomCodeforjoin)
                                          .collection("users")
                                          .get();
                                      var username = "user" +
                                          (snapshot.size + 1).toString();
                                      print("Number of users : count " +
                                          username);
                                      _getLocation(roomCodeforjoin, username);
                                      _listenLocation(
                                          roomCodeforjoin, username);
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => RoomPage(
                                                  title: room_name,
                                                  roomId: roomCodeforjoin,
                                                  user_id: username)));
                                    } else {
                                      const snackBar = SnackBar(
                                        content: Text('Room Name is Invalid'),
                                      );
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(snackBar);
                                    }
                                  }
                                },
                                child: Container(
                                  height: 50,
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 50),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                      color: Colors.lightGreen[600]),
                                  child: Center(
                                    child: TextButton(
                                        style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  Colors.lightGreen[600]),
                                        ),
                                        child: const Text(
                                          "Join",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        )),
                                  ),
                                ),
                              )),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      );
    }
  }

  String generateRandomString(int len) {
    var r = Random();
    const _chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    return List.generate(len, (index) => _chars[r.nextInt(_chars.length)])
        .join();
  }
}
