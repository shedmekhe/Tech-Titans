import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:lottie/lottie.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shrink_sidemenu/shrink_sidemenu.dart';
import 'package:team_tracker/screens/roomPage.dart';
import 'package:team_tracker/screens/room_gen_join.dart';

class HomeScreen extends StatefulWidget {
  static const String id = 'home_screen';
  String name = "";

  HomeScreen({Key key, this.name}) : super(key: key);


  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // int _counter = 0;
  bool isOpened = false;

  String roomName = "";
  @override
  void initState() {
    super.initState();
    print(widget.name);
    checkPermission();
  }

  Future<void> checkPermission() async {
    var status = await Permission.location.request();
    if (status.isDenied) {
      // We didn't ask for permission yet or the permission has been denied before but not permanently.
    }

      // You can can also directly ask the permission about its status.
    if (await Permission.location.isRestricted) {
      // The OS restricts access, for example because of parental controls.
    }
  }

  final GlobalKey<SideMenuState> _sideMenuKey = GlobalKey<SideMenuState>();
  final GlobalKey<SideMenuState> _endSideMenuKey = GlobalKey<SideMenuState>();

  // Future<Widget> showBottomSheets(BuildContext context) {
  //   return showModalBottomSheet<dynamic>(
  //       useRootNavigator: true,
  //       barrierColor: Colors.black.withOpacity(0.5),
  //       isScrollControlled: true,
  //       context: context,
  //       builder: (BuildContext bc) {
  //         return
  //       });
  // }

  Future<void> _newItem() async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const RoomGenerationJoin(
                                  type: true,
                                )));
                  },
                  child: const Text(
                    "Registration",
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const RoomGenerationJoin(
                                  type: false,
                                )));
                  },
                  child: const Text(
                    "Tracking",
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  var test = "No Change just cheking is everything ok";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        actions: [
          GestureDetector(
            child: const Padding(
              padding: EdgeInsets.fromLTRB(8.0, 8.0, 16.0, 8.0),
              child: Icon(Icons.info),
            ),
            onTap: () {
              showModalBottomSheet<dynamic>(
                  useRootNavigator: true,
                  barrierColor: Colors.black.withOpacity(0.5),
                  isScrollControlled: true,
                  context: context,
                  builder: (BuildContext bc) {
                    return ConstrainedBox(
                      constraints: BoxConstraints(
                          maxHeight: MediaQuery.of(context).size.height * 0.9),
                      child: Container(
                        decoration: new BoxDecoration(
                            color: Colors.blue,
                            borderRadius: new BorderRadius.only(
                                topLeft: const Radius.circular(25.0),
                                topRight: const Radius.circular(25.0))),
                        child: ListView(
                          shrinkWrap: true,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(30, 30, 30, 45),
                              child: Text(
                                'Choose Album',
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(30, 30, 30, 45),
                              child: Text(
                                'Choose Album',
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(30, 30, 30, 45),
                              child: Text(
                                'Choose Album',
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(30, 30, 30, 45),
                              child: Text(
                                'Choose Album',
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(30, 30, 30, 45),
                              child: Text(
                                'Choose Album',
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(30, 30, 30, 45),
                              child: Text(
                                'Choose Album',
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  });
            },
          )
        ],
        title: const Text('Team Tracker'),
      ),
      body: LottieBuilder.asset(
        'lottieAnimation/map.json',
        height: MediaQuery.of(context).size.height,
        repeat: true,
        fit: BoxFit.fill,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _newItem,
        child: const Icon(Icons.add),
      ),
    );
  }

}
