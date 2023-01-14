import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:get_storage/get_storage.dart';
// import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as loc;
import 'package:shrink_sidemenu/shrink_sidemenu.dart';
import 'package:custom_info_window/custom_info_window.dart';

class RoomPage extends StatefulWidget {
  final String user_id;
  final String roomId;
  // MyMap(this.user_id);
  static const String id = 'RoomPage';
  final StreamSubscription<loc.LocationData> locationSubscription;
  final String title;

  const RoomPage({
    Key key,
    this.title,
    this.user_id,
    this.roomId,
    this.locationSubscription,
  }) : super(key: key);

  @override
  State<RoomPage> createState() => _RoomPageState();
}

class _RoomPageState extends State<RoomPage> {
  loc.Location location = loc.Location();
  GoogleMapController _controller;
  bool _added = false;
  bool isOpened = false;
  Future<void> share() async {
    await FlutterShare.share(
      title: 'Share Room Code',
      text: widget.roomId,
      // linkUrl: 'https://flutter.dev/',
      // chooserTitle: 'Example Chooser Title'
    );
  }

  Future<void> deleteUser() async {
    widget.locationSubscription?.cancel();
    // setState(() {
    //   widget.locationSubscription = null;
    // });

    final box = GetStorage();

    var name = box.read('name');
    await FirebaseFirestore.instance
        .collection("location")
        .doc(widget.roomId)
        .collection("users")
        .doc(widget.user_id)
        .delete();
  }

  Future<void> _newItem() async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                Text(
                  "RoomID :  " + widget.roomId,
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 25,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                  onPressed: () {
                    print(
                        "share called +++++++++++++++++++++++++++++++++++++++++++++++++++++++++");
                    share();
                  },
                  child: const Text(
                    "Share Code",
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String markerDisc = "";

  Future<void> _markerDisc() async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                TextFormField(
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: 'Enter Description'),
                  onChanged: (value) {
                    markerDisc = value;
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    return markerDisc;
                  },
                  child: const Text("ADD"),
                  style: ButtonStyle(
                      foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.white),
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.blueAccent)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  final GlobalKey<SideMenuState> _sideMenuKey = GlobalKey<SideMenuState>();
  final GlobalKey<SideMenuState> _endSideMenuKey = GlobalKey<SideMenuState>();

  final CustomInfoWindowController _customInfoWindowController =
      CustomInfoWindowController();

  bool flg = false;

  @override
  void displose() {
    _customInfoWindowController.dispose();
    super.dispose();
  }

  MapType _currentMapType = MapType.normal;

  String Txt;
  LatLng targetForMarking;

  List<Marker> markeradd(dynamic snapshot) {
    List<dynamic> sanket;
    List<Marker> tmpsbaet = [];
    print("called");
    // bool done = false;
    // print(snapshot.data.docs);
    sanket = [
      ...snapshot.data.docs.map((e) {
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
            _tmp.add(Marker(
              // about target location array
              position: LatLng(
                points['latitude1'] ?? points['latitude'],
                points['longitude1'] ?? points['longitude'],
              ),
              markerId: MarkerId(points['name1'] ?? datas['name']),
              icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueRed),
              onTap: () {
                if (flg) {
                  _customInfoWindowController.hideInfoWindow();
                  setState(() {
                    flg = false;
                  });
                } else {
                  _customInfoWindowController.addInfoWindow(
                    Column(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  points['description'],
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                  ),
                                ),
                                Text(
                                  "Lat: " + points['latitude1'].toString(),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                                // const SizedBox(
                                //   width: 4.0,
                                // ),
                                Text(
                                  "Long: " + points['longitude1'].toString(),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                                // SizedBox(
                                //   width: 8.0,
                                // ),
                              ],
                            ),
                            width: double.infinity,
                            height: double.infinity,
                          ),
                        ),
                      ],
                    ),
                    LatLng(
                      points['latitude1'],
                      points['longitude1'],
                    ),
                  );
                  setState(() {
                    flg = true;
                  });
                }
              },
            ));
          });
        } else {
          print("Fine");
          print(datas);
        }
        _tmp.add(Marker(
          // about user location
          position: LatLng(
            datas['latitude'],
            datas['longitude'],
          ),
          markerId: MarkerId(datas['name']),
          icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueMagenta),
          onTap: () {
            if (flg) {
              _customInfoWindowController.hideInfoWindow();
              setState(() {
                flg = false;
              });
            } else {
              _customInfoWindowController.addInfoWindow(
                Column(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              datas['name'],
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                              ),
                            ),
                            Text(
                              "Lat: " + datas['latitude'].toString(),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                            // const SizedBox(
                            //   width: 4.0,
                            // ),
                            Text(
                              "Long: " + datas['longitude'].toString(),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              "Alt: " + datas['altitude'].toString(),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                            // SizedBox(
                            //   width: 8.0,
                            // ),
                          ],
                        ),
                        width: double.infinity,
                        height: double.infinity,
                      ),
                    ),
                  ],
                ),
                LatLng(
                  datas['latitude'],
                  datas['longitude'],
                ),
              );
              setState(() {
                flg = true;
              });
            }
          },
        ));
        print("........12345_____________");
        print(_tmp);
        return _tmp;
      }).toList()
    ];
    print(".................");
    print(sanket.length);
    for (var i = 0; i < sanket.length; i++) {
      tmpsbaet.addAll(sanket[i]);
    }
    // tmpsbaet = sanket[0];
    return tmpsbaet;
  }

  // GoogleMapPolyline googleMapPolyline = new GoogleMapPolyline(apiKey: "here your key");
  // final List<Polyline> polyline = [];
  // List<LatLng> routeCoords = [];

  toggleMenu([bool end = false]) {
    if (end) {
      final _state = _endSideMenuKey.currentState;
      if (_state.isOpened) {
        _state.closeSideMenu();
      } else {
        _state.openSideMenu();
      }
    } else {
      final _state = _sideMenuKey.currentState;
      if (_state.isOpened) {
        _state.closeSideMenu();
      } else {
        _state.openSideMenu();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SideMenu(
      key: _sideMenuKey,
      background: Colors.green[700],
      menu: buildMenu(),
      type: SideMenuType.slide,
      onChange: (_isOpened) {
        setState(() => isOpened = _isOpened);
      },
      child: IgnorePointer(
        ignoring: isOpened,
        child: WillPopScope(
          onWillPop: () {
            return showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Are you sure?'),
                    content: const Text('Do you want to leave this room ?'),
                    actions: <Widget>[
                      ElevatedButton(
                        style: const ButtonStyle(
                            backgroundColor:
                                MaterialStatePropertyAll(Colors.green)),
                        onPressed: () => Navigator.of(context).pop(false),
                        child: const Text(
                          "NO",
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        style: const ButtonStyle(
                            backgroundColor:
                                MaterialStatePropertyAll(Colors.red)),
                        onPressed: () => {
                          deleteUser(),
                          Navigator.of(context).pop(true),
                        },
                        child: const Text("YES"),
                      ),
                    ],
                  ),
                ) ??
                false;
          },
          child: Scaffold(
            bottomNavigationBar: SizedBox(
              height: 60,
              child: BottomAppBar(
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.add_location,
                      ),
                      onPressed: () async {
                        // targetForMarking=await _controller.getLatLng(screenCoordinate) ;
                      },
                    )
                  ],
                ),
              ),
            ),

            //   centerTitle: true,
            //   leading: IconButton(
            //     icon: const Icon(Icons.menu),
            //     onPressed: () => toggleMenu(),
            //   ),
            //   title: Text(widget.title + " " + widget.roomId),
            // ),
            appBar: AppBar(
              centerTitle: true,
              actions: [
                GestureDetector(
                    child: const Padding(
                      padding: EdgeInsets.fromLTRB(8.0, 8.0, 16.0, 8.0),
                      child: Icon(Icons.share),
                    ),
                    onTap: () {
                      _newItem();
                    })
              ],
              title: const Text('Team Tracker'),
            ),

            body: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('location')
                  .doc(widget.roomId)
                  .collection("users")
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (_added) {
                  mymap(snapshot);
                }
                if (snapshot.connectionState == ConnectionState.waiting &&
                    _added == false) {
                  return const Center(child: CircularProgressIndicator());
                }
                // List<Marker>markerList;
                //     markerList=snapshot.data.docs.map((e){
                //
                //     Map<String, dynamic> data = e.data() as Map<String, dynamic>;
                //   // print("-----------------------");
                //   // print(data);
                //
                //     final box = GetStorage();
                //
                //     String name = box.read('name') ?? 'temp';
                //     if(data['broad']==false && data['name']!=name){
                //       return Marker(markerId: MarkerId("No"));
                //     }
                //     print(data.values);
                //     return Marker(
                //     position: LatLng(
                //       data['latitude1']??data['latitude'],
                //       data['longitude1']??data['longitude'],
                //     ),
                //     markerId: MarkerId(data['name1']??data['name']),
                //     icon: BitmapDescriptor.defaultMarkerWithHue(
                //     BitmapDescriptor.hueMagenta));
                //   }).toList();
                // markerList.removeWhere((element) => element.markerId.value=="No");

                return Stack(
                  children: [
                    GoogleMap(
                      myLocationButtonEnabled: true,
                      zoomGesturesEnabled: true,
                      onCameraMove: (position) {
                        _customInfoWindowController.onCameraMove();
                      },
                      mapType: _currentMapType,
                      markers: {
                        ...(markeradd(snapshot) ??
                            snapshot.data.docs.map((e) {
                              Map<String, dynamic> data =
                                  e.data() as Map<String, dynamic>;
                              print("-----------------------");
                              print(data);
                              return Marker(
                                  position: LatLng(
                                    data['latitude'],
                                    data['longitude'],
                                  ),
                                  onTap: () {},
                                  markerId: MarkerId(data['name']),
                                  icon: BitmapDescriptor.defaultMarkerWithHue(
                                      BitmapDescriptor.hueMagenta));
                            }).toList())
                      },
                      initialCameraPosition: CameraPosition(
                        target: LatLng(
                          snapshot.data.docs.singleWhere((element) =>
                              element.id == widget.user_id)['latitude'],
                          snapshot.data.docs.singleWhere((element) =>
                              element.id == widget.user_id)['longitude'],
                        ),
                      ),
                      onMapCreated: (GoogleMapController controller) async {
                        _customInfoWindowController.googleMapController =
                            controller;
                        setState(() {
                          _controller = controller;
                          _added = true;
                        });
                      },
                      onTap: (LatLng latLng) async {
                        if (flg) {
                          _customInfoWindowController.hideInfoWindow();
                          setState(() {
                            flg = false;
                          });
                          return;
                        }
                        await _markerDisc();
                        if (markerDisc == "") return;
                        try {
                          // String name = box.read('name');
                          print(latLng);
                          dynamic tmp = [];
                          print(
                              "------------++++++++++++++++++++++++++---------------+++++++++++++++++++");
                          print(markerDisc);
                          print(
                              "------------++++++++++++++++++++++++++---------------+++++++++++++++++++");
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
                          tmp.add({
                            'latitude1': latLng.latitude,
                            'longitude1': latLng.longitude,
                            'description': markerDisc,
                            'name1': "Target set by " +
                                widget.user_id +
                                generateRandomString(6),
                            'broad': false
                          });

                          FirebaseFirestore.instance
                              .collection('location')
                              .doc(widget.roomId)
                              .collection("users")
                              .doc(widget.user_id)
                              .set({'locations': tmp}, SetOptions(merge: true));
                        } catch (e) {
                          print(e);
                        }
                        setState(() {
                          markerDisc = "";
                        });
                        // setState(() {
                        //   // Reload();
                        // });
                        print("____\n");
                        print("Slected Latlng are $latLng");
                        // print(target.markerId.toString());
                      },
                    ),
                    CustomInfoWindow(
                      controller: _customInfoWindowController,
                      height: 80,
                      width: 150,
                      offset: 50,
                    ),
                  ],
                );
              },
            ),
            floatingActionButton: FloatingActionButton(
              child: const Icon(Icons.satellite_alt),
              onPressed: () => {
                setState(() {
                  _currentMapType = (_currentMapType == MapType.normal)
                      ? MapType.satellite
                      : MapType.normal;
                })
              },
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.miniStartFloat,
          ),
        ),
      ),
    );
  }

  Widget buildMenu() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 50.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 22.0,
                ),
                const SizedBox(height: 16.0),
                Text(
                  widget.title.toString(),
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 20.0),
              ],
            ),
          ),
          ListTile(
            onTap: () {},
            leading: const Icon(Icons.home, size: 20.0, color: Colors.white),
            title: const Text("Home"),
            textColor: Colors.white,
            dense: true,
          ),
          ListTile(
            onTap: () {},
            leading: const Icon(Icons.verified_user,
                size: 20.0, color: Colors.white),
            title: const Text("Distance Measurement"),
            textColor: Colors.white,
            dense: true,

            // padding: EdgeInsets.zero,
          ),
          ListTile(
            onTap: () {},
            leading: const Icon(Icons.monetization_on,
                size: 20.0, color: Colors.white),
            title: const Text("Marking Location"),
            textColor: Colors.white,
            dense: true,

            // padding: EdgeInsets.zero,
          ),
          ListTile(
            onTap: () {},
            leading: const Icon(Icons.shopping_cart,
                size: 20.0, color: Colors.white),
            title: const Text("Satellite View"),
            textColor: Colors.white,
            dense: true,

            // padding: EdgeInsets.zero,
          ),
          ListTile(
            onTap: () {},
            leading:
                const Icon(Icons.star_border, size: 20.0, color: Colors.white),
            title: const Text("Trace Path"),
            textColor: Colors.white,
            dense: true,

            // padding: EdgeInsets.zero,
          ),
          ListTile(
            onTap: () {
              toggleMenu();
              Navigator.pop(context);
            },
            leading:
                const Icon(Icons.settings, size: 20.0, color: Colors.white),
            title: const Text("Leave Room"),
            textColor: Colors.white,
            dense: true,

            // padding: EdgeInsets.zero,
          ),
        ],
      ),
    );
  }

  Future<void> mymap(AsyncSnapshot<QuerySnapshot> snapshot) async {
    await _controller
        .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
            target: LatLng(
              snapshot.data.docs.singleWhere(
                  (element) => element.id == widget.user_id)['latitude'],
              snapshot.data.docs.singleWhere(
                  (element) => element.id == widget.user_id)['longitude'],
            ),
            zoom: 18)));
  }
}

String generateRandomString(int len) {
  var r = Random();
  const _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  return List.generate(len, (index) => _chars[r.nextInt(_chars.length)]).join();
}
