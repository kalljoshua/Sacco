import 'dart:convert';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';

class MembershipCard extends StatefulWidget {
  @override
  _MembershipCardState createState() => _MembershipCardState();
}

class _MembershipCardState extends State<MembershipCard> {
  TextEditingController membershipController = TextEditingController();

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.blue.withOpacity(0.6)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 55,
                  height: 55,
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            color: Colors.white.withOpacity(0.2),
                            offset: Offset(-8, -1),
                            spreadRadius: 2,
                            blurRadius: 5),
                        BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            offset: Offset(2, 2),
                            spreadRadius: 4,
                            blurRadius: 5)
                      ],
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                          colors: [Color(0xffFE9B4D), Color(0xffFE8032)])),
                  child: Icon(
                    Icons.card_membership,
                    color: Colors.white,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Membership",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                      Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(15)),
                        child: Text(
                          "Approved",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Text(
                "Next payment on: 27-Oct-2021",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8),
              child: Container(
                height: 2,
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.5)),
              ),
            ),
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "UGX 50,000",
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                    /*Text(
                      "\$39,99",
                      style: TextStyle(
                          fontSize: 26,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.lineThrough),
                    )*/
                  ],
                ),
                Spacer(),
                RaisedButton(
                  textColor: Colors.white,
                  padding: EdgeInsets.all(10),
                  color: Color(0xffFE9B4D),
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Renew Membership'),
                            content: Stack(
                              overflow: Overflow.visible,
                              children: <Widget>[
                                Positioned(
                                  right: -40.0,
                                  top: -40.0,
                                  child: InkResponse(
                                    onTap: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: CircleAvatar(
                                      child: Icon(Icons.close),
                                      backgroundColor: Colors.red,
                                    ),
                                  ),
                                ),
                                Form(
                                  key: _formKey,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Text(
                                        "Amount to pay: 50,000 UGX",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      new TextField(
                                        style:
                                            TextStyle(color: Color(0xFF000000)),
                                        controller: membershipController,
                                        cursorColor: Color(0xFF9b9b9b),
                                        keyboardType: TextInputType.text,
                                        decoration: InputDecoration(
                                          prefixIcon: Icon(
                                            Icons.attach_money,
                                            color: Colors.grey,
                                          ),
                                          hintText: "Amount to save",
                                          hintStyle: TextStyle(
                                              color: Color(0xFF9b9b9b),
                                              fontSize: 15,
                                              fontWeight: FontWeight.normal),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: FlatButton(
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                  top: 8,
                                                  bottom: 8,
                                                  left: 10,
                                                  right: 10),
                                              child: Text(
                                                _isLoading
                                                    ? 'Creating...'
                                                    : 'Create account',
                                                textDirection:
                                                    TextDirection.ltr,
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 15.0,
                                                  decoration:
                                                      TextDecoration.none,
                                                  fontWeight: FontWeight.normal,
                                                ),
                                              ),
                                            ),
                                            color: Colors.red,
                                            disabledColor: Colors.grey,
                                            shape: new RoundedRectangleBorder(
                                                borderRadius:
                                                    new BorderRadius.circular(
                                                        20.0)),
                                            onPressed: _isLoading
                                                ? null
                                                : _handleMembership),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        });
                  },
                  child: Text("Renew"),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  void _handleMembership() async{
    setState(() {
      _isLoading = true;
    });
    var data = {
      'amount': membershipController.text,
    };

    String amount = membershipController.text;

    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var userToken = localStorage.getString('token');

    var uri = Uri.parse(
        'http://167.99.142.219:8081/transaction/membership/pay/$amount');

    var response = await http.put(
      uri,
      headers: {
        HttpHeaders.authorizationHeader: "Bearer $userToken",
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(data),
    );

    var membershipData = json.decode(response.body);

    if (response.statusCode == 200) {
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      localStorage.setString('membershipData', json.encode(membershipData));

      print("Sucessful: " + membershipData.toString());

      setState(() {
        _isLoading = false;
      });
    } else {
      print("failed: " + response.statusCode.toString());
      setState(() {
        _isLoading = false;
      });
    }

  }
}
