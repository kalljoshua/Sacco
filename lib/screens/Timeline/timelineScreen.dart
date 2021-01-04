import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sacco_app/screens/Home/components/appDrawer.dart';
import 'package:sacco_app/util/userFetch.dart';
import 'package:shared_preferences/shared_preferences.dart';

class  TimeLine extends StatefulWidget {
  @override
  _TimeLineState createState() => _TimeLineState();
}

class _TimeLineState extends State<TimeLine> {

  final Firestore _firestore = Firestore.instance;
  ScrollController scrollController = ScrollController();

User userData;

@override
  void initState() {
    super.initState();
    this.fetchTransactions();
  }

  fetchTransactions() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    //var userToken = localStorage.getString('token');

    var userSession = localStorage.getString('user');
    var response = jsonDecode(userSession);
      setState(() {
        userData = new User.fromJson(response);
        
      });
    
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notifications"),
      ),

      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _firestore
                    .collection('notifications')
                    .document(
                      "uname")
                    .collection('notifications')
                    .orderBy('date')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData)
                    return Center(
                      child: CircularProgressIndicator(),
                    );

                  List<DocumentSnapshot> docs = snapshot.data.documents;

                  List<Widget> messages = docs
                      .map((doc) => Message(
                            from: doc.data['sent'],
                            text: doc.data['text'],
                            me: doc.data['subject'],
                          ))
                      .toList();

                  return ListView(
                    controller: scrollController,
                    children: <Widget>[
                      ...messages,
                    ],
                  );
                },
              ),
            ),
          ],
        ),
       
      ),


      drawer: MainDrawer(),
    );
  }
}

class Message extends StatelessWidget {
  final String from;
  final String text;
  final String me;

  const Message({Key key, this.from, this.text, this.me}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
         boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(.10),
                      blurRadius: 8,
                      spreadRadius: 3,
                      offset: Offset(0, 9),
                    ),
                  ],
                color: Colors.white.withOpacity(0.5),
              ),
              height: 80,
              child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Container(
                      width: 60,
                      height: 60,
                      clipBehavior: Clip.hardEdge,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border:
                            Border.all(color: Colors.black.withOpacity(0.5)),
                      ),
                      child: Icon(
                            Icons.notifications,
                            color: Colors.green,
                            size: 30,
                          ),
                    ),
                    title: Text(
                      me,
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Text(
                     text,
                      style: TextStyle(
                        color: Colors.deepPurpleAccent.withOpacity(0.6),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    trailing: Text(
                      "2020-12-31",
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
    );
  }
}