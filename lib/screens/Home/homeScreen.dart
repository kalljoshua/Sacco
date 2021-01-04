import 'package:flutter/material.dart';
import 'package:sacco_app/screens/Chat/chatRoom.dart';
import 'package:sacco_app/screens/Home/components/homePage.dart';
import 'package:sacco_app/screens/Timeline/timelineScreen.dart';
import 'package:sacco_app/screens/settingsPage.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  final tab = [    
    HomeScreen(),
    TimeLine(),
    ChatRoom(),   
    SettingsPage(),

  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(     

      body:  tab[_currentIndex],

      bottomNavigationBar: BottomNavigationBar(
        unselectedItemColor: Colors.blueAccent,
        selectedItemColor: Theme.of(context).primaryColor,
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.access_time),
            label: "Notifications",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: "Chat",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: "Settings",
          ),
        ],
        onTap: (index){
            setState(() {
              _currentIndex = index;
            });
        },

      ),
      

    
    );
  }
}