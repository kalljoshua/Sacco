import 'package:flutter/material.dart';
import 'package:sacco_app/screens/UserProfile/userProfile.dart';

class UserSettings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("User Settings"),
      ),
      body:  EditProfilePage(),
      //drawer: MainDrawer(),
    );
  }
}