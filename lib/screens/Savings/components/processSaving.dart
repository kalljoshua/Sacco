import 'dart:convert';
import 'package:sacco_app/api/api.dart';
import 'package:sacco_app/screens/Home/homeScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

class ProcessSaving extends StatefulWidget {
  @override
  _ProcessSavingState createState() => _ProcessSavingState();
}

class _ProcessSavingState extends State<ProcessSaving> {
  TextEditingController savingController = TextEditingController();

  bool _isLoading = false;

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Process Savings'),
        backgroundColor: Colors.purple,
      ),
      body: Container(
        child: Stack(
          children: <Widget>[
            ///////////  background///////////
            new Container(
              decoration: new BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  stops: [0.0, 0.4, 0.9],
                  colors: [
                    Colors.white
                  ],
                ),
              ),
            ),

            Positioned(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Card(
                      elevation: 4.0,
                      color: Colors.white,
                      margin: EdgeInsets.only(left: 20, right: 20),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            /////////////  Email//////////////
                            TextField(
                              style: TextStyle(color: Color(0xFF000000)),
                              controller: savingController,
                              cursorColor: Color(0xFF9b9b9b),
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.mobile_friendly,
                                  color: Colors.grey,
                                ),
                                hintText: "Amount to Save ",
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
                                      top: 8, bottom: 8, left: 10, right: 10),
                                  child: Text(
                                    _isLoading ? 'Sending...' : 'Save',
                                    textDirection: TextDirection.ltr,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15.0,
                                      decoration: TextDecoration.none,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ),
                                color: Color(0xFFFF835F),
                                disabledColor: Colors.grey,
                                shape: new RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(20.0)),
                                onPressed: _isLoading ? null : _processSavings,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _processSavings() async {
    setState(() {
      _isLoading = true;
    });
    var data = {
      'amount': savingController.text,
    };

    String amount = savingController.text;
    
    var response = await CallApi().putData(data,'transaction/saving/mobile/$amount');

    var responseUser = await CallApi().getData('profile/user/get');
    
    print('i am here: '+ data.toString());
    print('Saving Data: '+ response.body);
    var savingsData = json.decode(response.body);
    
    if (response.statusCode == 200) {
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      var responseJson = jsonDecode(responseUser.body);

      localStorage.setString('user', json.encode(responseJson));

      print("Sucessful: " + savingsData.toString());
      Toast.show("Successfully paid $amount", context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM, backgroundColor:Colors.green);

      setState(() {
        _isLoading = false;
      });
      Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) => HomePage()));
    } else {
      Toast.show("Failed to process savings", context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM, backgroundColor:Colors.green);
      print("failed: " + response.statusCode.toString());
      setState(() {
        _isLoading = false;
      });
    }
  }
}
