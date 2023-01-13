import 'package:flutter/material.dart';

class NavDrawer extends StatelessWidget {
  const NavDrawer({Key key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            child: Text(
              'Side Menu',
              style: TextStyle(color: Colors.white, fontSize: 25),
            ),
            decoration: BoxDecoration(
              color:Colors.green,
              image: DecorationImage(
                  fit: BoxFit.fill,
                  image: AssetImage('sidebar.jpg')
              ),
            ),
          ),
          ListTile(
              leading: const Icon(Icons.input),
              title: const Text('Welcome'),
              onTap: () => {}
          ),
          ListTile(
              leading: const Icon(Icons.input),
              title: const Text('Welcome'),
              onTap: () => {}
          ),
          ListTile(
            leading: const Icon(Icons.input),
            title: const Text('Settings'),
            onTap: () => {
              Navigator.of(context).pop()
            },
          ),
          ListTile(
            leading: const Icon(Icons.input),
            title: const Text('Feedback'),
            onTap: () => {
              Navigator.of(context).pop()
            },
          ),
          ListTile(
            leading: const Icon(Icons.input),
            title: const Text('Logout'),
            onTap: () => {
              Navigator.of(context).pop()
            },
          ),
        ],
      ),
    );
  }
}
