// ignore_for_file: unnecessary_this, unnecessary_new, prefer_const_constructors

import 'package:cinema/villes-page.dart';
import 'package:cinema/setting-page.dart';
import 'package:cinema/contact-page.dart';

import 'package:cinema/MenuItem.dart';

import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(
      theme: ThemeData(
        appBarTheme: AppBarTheme(color: Color(0xFF212121)),
      ),
      home: MyApp(),
    ));

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  /* final menus = [
    {'title': 'Home', 'icon ': Icon(Icons.home), 'page': VillePage()},
    {'title': 'Setting', 'icon ': Icon(Icons.settings), 'page': SettingPage()},
  ];*/
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cinema Page"),
      ),
      body: Center(child: Image.asset("./images/home2.jpg")),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            // ignore: prefer_const_constructors
            DrawerHeader(
              child: Center(
                child: CircleAvatar(
                  backgroundImage: AssetImage("./images/profile2.png"),
                  radius: 30,
                ),
              ),
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [Color(0xFF303030), Color(0xFFB71C1C)])),
            ),

            Divider(
              color: Color(0xFF424242),
            ),
            MenuItem('Home', Icon(Icons.home), (context) {
              Navigator.pop(context);
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => new VillePage()));
            }),
            MenuItem('Settings', Icon(Icons.settings), (context) {
              Navigator.pop(context);
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => new SettingPage()));
            }),
            MenuItem('Contact', Icon(Icons.contact_mail), (context) {
              Navigator.pop(context);
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => new ContactPage()));
            }),
          ],
        ),
      ),
    );
  }
}
