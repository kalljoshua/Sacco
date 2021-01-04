import 'dart:convert';
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:sacco_app/screens/Loans/loansPage.dart';
import 'package:sacco_app/screens/Membership/membershipPage.dart';
import 'package:sacco_app/screens/Savings/savingsPage.dart';
import 'package:sacco_app/screens/Shares/sharesPage.dart';
import 'package:sacco_app/screens/Signup/components/social_icon.dart';
import 'package:sacco_app/screens/Login/login_screen.dart';
import 'package:sacco_app/screens/UserProfile/components/userSettings.dart';
import 'package:sacco_app/util/userFetch.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainDrawer extends StatefulWidget {
  @override
  _MainDrawerState createState() => _MainDrawerState();
}


class _MainDrawerState extends State<MainDrawer>{
  User userData;
  NumberFormat format = NumberFormat('#,###,###.00');
  @override
  void initState() {
    fetchUser();
    super.initState();
  }

  void fetchUser() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var userSession = localStorage.getString('user');
    
    var responseJson = jsonDecode(userSession);    
    setState(() {
      userData = new User.fromJson(responseJson);
      
    });
  }

  @override
  Widget build(BuildContext context) {

    return Drawer(
      child: Column(
        children: <Widget>[
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(10),
            color: Colors.purple,
            child: Column(
              children: <Widget>[
                Container(
                  width: 60.0,
                  height: 60.0,
                  margin: EdgeInsets.only(top: 10, bottom: 10),
                  decoration: BoxDecoration(
                    color: Colors.blueAccent,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(.1),
                          blurRadius: 8,
                          spreadRadius: 3)
                    ],
                    border: Border.all(
                      width: 1.5,
                      color: Colors.white,
                    ),
                    borderRadius: BorderRadius.circular(35.0),
                  ),
                  padding: EdgeInsets.all(5),
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(
                        "https://images.pexels.com/photos/2167673/pexels-photo-2167673.jpeg?auto=compress&cs=tinysrgb&dpr=3&h=750&w=1260"),
                  ),
                ),
                Text(
                    userData != null
                      ? userData.personDto.firstName+' '+userData.personDto.lastName
                          : 'Full Name',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
                Text(
                  userData != null
                    ? userData.personDto.email
                      : 'Email',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                Text(
                  userData != null
                    ? format.format(userData.accountDto.totalSavings).toString()
                          : '000.00',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.person,color: Colors.blue,),
            title: Text('Profile',
              style: TextStyle(
                fontSize: 15,
              ),
            ),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => UserSettings()));
            },
          ),
          ListTile(
            leading: Icon(Icons.account_balance,color: Colors.blue,),
            title: Text('Loans',
              style: TextStyle(
                fontSize: 15,
              ),
            ),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => LoansPage()));
            },
          ),
          ListTile(
            leading: Icon(Icons.business_center_sharp,color: Colors.blue,),
            title: Text('Savings',
              style: TextStyle(
                fontSize: 15,
              ),
            ),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => SavingsPage()));
            },
          ),
          ListTile(
            leading: Icon(Icons.card_membership,color: Colors.blue,),
            title: Text('Membership',
              style: TextStyle(
                fontSize: 15,
              ),
            ),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => MembershipPage()));
            },
          ),
          ListTile(
            leading: Icon(Icons.pie_chart,color: Colors.blue,),
            title: Text('Shares',
              style: TextStyle(
                fontSize: 15,
              ),
            ),
            onTap: (){
            Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => SharesPage()));
          },
          ),          
          ListTile(
              leading: Icon(Icons.share,color: Colors.blue,),
              title: Text('Share',
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
              onTap: null
          ),
          
          ListTile(
              leading: Icon(Icons.logout,color: Colors.blue,),
              title: Text('Logout',
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
              onTap: () async {
               
                SharedPreferences localStorage = await SharedPreferences.getInstance();
                  localStorage.remove('user');
                  localStorage.remove('token');
                  Navigator.push(
                          context, new MaterialPageRoute(builder: (context) => LoginScreen()));
              }
              
          ),
          SizedBox(
            height: 5,
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SocalIcon(
                iconSrc: "assets/icons/facebook.svg",
                press: () {},
              ),
              SocalIcon(
                iconSrc: "assets/icons/twitter.svg",
                press: () {},
              ),

            ],
          )
        ],

      ),

    );
    
  }
  
}