import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:team_tracker/screens/home_screen.dart';
import 'package:team_tracker/modal/animation.dart';

class UserInfo extends StatefulWidget {
  static const String id = 'UserInfo';

  const UserInfo({Key key}) : super(key: key);

  @override
  State<UserInfo> createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfo> {
  bool isLoading = true;

  String name;

  final box = GetStorage();

  @override
  void initState() {
    super.initState();

    setState(() {
      isLoading = false;
    });

    // userDetails();
  }

  userDetails() {
    final box = GetStorage();

    name = box.read('name');
    if (kDebugMode) {
      print(box.read('name'));
    }

    if (name != "") {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => HomeScreen(name: name)));
    }
  }

  storeData(String name) async {
    print(name);
    box.write('name', name);
    print(box.read('name'));
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading == true) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
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
                          "Details",
                          style: TextStyle(color: Colors.white, fontSize: 40),
                        )),
                    SizedBox(
                      height: 10,
                    ),
                    FadeAnimation(
                        1.3,
                        Text(
                          "Welcome to TeamTracker",
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
                          // ElevatedButton(
                          //     onPressed: () async{
                          //       await userDetails();
                          //       Navigator.push(context, MaterialPageRoute(builder: (context)=> HomeScreen(name: name, codeName: codeName)));
                          //
                          //     },
                          //     child: const Text("Fetch Details", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),)
                          //
                          // ),
                          // const SizedBox(height: 60,),
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
                                            hintText: "Name",
                                            hintStyle:
                                                TextStyle(color: Colors.grey),
                                            border: InputBorder.none),
                                        onChanged: (value) {
                                          name = value;
                                        },
                                      ),
                                    ),
                                    // Container(
                                    //   padding: const EdgeInsets.all(10),
                                    //   decoration: BoxDecoration(
                                    //       border: Border(bottom: BorderSide(color: Colors.grey.shade200))
                                    //   ),
                                    //   child: TextField(
                                    //     decoration: const InputDecoration(
                                    //         hintText: "Code Name",
                                    //         hintStyle: TextStyle(color: Colors.grey),
                                    //         border: InputBorder.none
                                    //     ),
                                    //     onChanged: (value){
                                    //       codeName=value;
                                    //     },
                                    //   ),
                                    // ),
                                  ],
                                ),
                              )),

                          const SizedBox(
                            height: 40,
                          ),
                          FadeAnimation(
                              1.6,
                              TextButton(
                                onPressed: ()  {
                                  if (name == null) {
                                    const snackBar = SnackBar(
                                      content: Text('Enter Name'),
                                    );
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackBar);
                                  } else {
                                    storeData(name);
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                HomeScreen(name: name)));
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
                                        "Save",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
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
}

/*
List<Marker> markeradd(dynamic snapshot) {
  List<dynamic> dataList;
  List<Marker> tmpsbaet =  [];
  print("called");
  bool done = false;
  // print(snapshot.data.docs);
  dataList = [...snapshot.data.docs.map((e) {
    Map<String, dynamic> datas = e.data() as Map<String, dynamic>;
    List<dynamic> data = [];
    List<Marker> _tmp = [];

    //
    print("-----------------------");
    print(datas['locations']);
    print("-----------------------");

    if (datas['locations'] != null) {
      print("ok ");
      data.addAll(datas['locations']);
      data.forEach((points) {
        if(points['name1']!='Deleted') {
          _tmp.add(Marker(
            // about target location array
              position: LatLng(
                points['latitude1'] ?? points['latitude'],
                points['longitude1'] ?? points['longitude'],
              ),
              markerId: MarkerId(points['name1'] ?? datas['name']),
              onTap: (){
                try {
                  // String name = box.read('name');
                  dynamic tmp = [];
                  var data = snapshot.data.docs
                      .singleWhere(
                          (element) => element.id == widget.user_id)
                      .data()
                      .toString()
                      .contains("locations")
                      ? snapshot.data.docs.singleWhere((element) =>
                  element.id == widget.user_id)["locations"]
                      : [];
                  print(data);
                  if (data != null) {
                    tmp.addAll(data);
                  }
                  for(var itr in tmp){
                    if(itr['name']==data['name']||itr['name1']==data['name1']){
                      itr['name']="Deleted";
                      itr['name1']="Deleted";
                    }
                  }

                  FirebaseFirestore.instance
                      .collection('location')
                      .doc(widget.roomId)
                      .collection("users")
                      .doc(widget.user_id)
                      .set({'locations': tmp}, SetOptions(merge: true));
                } catch (e) {
                  print(e);
                }

              },
              icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueRed)));

        }
      });
    } else {
      print("Fine");
      print(datas);

    }
    _tmp.add(Marker( // about user location
        position: LatLng(
          datas['latitude'],
          datas['longitude'],
        ),
        markerId: MarkerId(datas['name']),
        onTap: (){
          try {
            // String name = box.read('name');
            dynamic tmp = [];
            var data = snapshot.data.docs
                .singleWhere(
                    (element) => element.id == widget.user_id)
                .data()
                .toString()
                .contains("locations")
                ? snapshot.data.docs.singleWhere((element) =>
            element.id == widget.user_id)["locations"]
                : [];
            print(data);
            if (data != null) {
              tmp.addAll(data);
            }
            for(var itr in tmp){
              if(itr['name']==data['name']||itr['name1']==data['name1']){
                itr['name']="Deleted";
                itr['name1']="Deleted";
              }
            }
            print("Target Deleted");
            FirebaseFirestore.instance
                .collection('location')
                .doc(widget.roomId)
                .collection("users")
                .doc(widget.user_id)
                .set({'locations': tmp}, SetOptions(merge: true));
          } catch (e) {
            print(e+'from line 151');
          }

        },
        icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueMagenta)));
    print("........12345_____________");
    print(_tmp);
    return _tmp;
  }).toList()];
  print(".................");
  print(dataList);
  tmpsbaet = dataList[0];
  return tmpsbaet;
}


*/
