import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sacco_app/api/api.dart';
import 'package:sacco_app/screens/Loans/loansPage.dart';


class RequestLoanPage extends StatefulWidget {
  @override
  _RequestLoanPageState createState() => _RequestLoanPageState();
}

class _RequestLoanPageState extends State<RequestLoanPage> {
  TextEditingController principalController = TextEditingController();
  TextEditingController durationController = TextEditingController();
  TextEditingController payDayController = TextEditingController();
  TextEditingController guarantorController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  bool _isLoading = false; 

  ScaffoldState scaffoldState;
      
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Request Loan'),
        backgroundColor: Colors.purple,        
      ),
      body: Container(
        padding: EdgeInsets.only(left: 16, top: 15, right: 16),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: ListView(
            children: [
              
              Center(
                child: Text(
                "Request Loan Form",
                style: TextStyle(
                  fontSize: 22, 
                  fontWeight: 
                  FontWeight.w500),
              ),
              ),
              SizedBox(
                height: 35,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 25),
                alignment: Alignment.center,
                child: Text(
                   'Your Loan request will be reviewed...',
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                height: 35,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 25),
                child: Column( 
                  children: <Widget>[
                    TextField(
                      style: TextStyle(color: Color(0xFF000000)),
                      cursorColor: Color(0xFF9b9b9b),
                      controller: principalController,
                      keyboardType: TextInputType.text,
                      obscureText: false,
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.attach_money,
                          color: Colors.grey,
                        ),
                        hintText: "Loan Amount",
                        hintStyle: TextStyle(
                            color: Color(0xFF9b9b9b),
                            fontSize: 15,
                            fontWeight: FontWeight.normal),
                      ),
                    ),
                    SizedBox(height: 15),
                    TextField(
                      style: TextStyle(color: Color(0xFF000000)),
                      cursorColor: Color(0xFF9b9b9b),
                      controller: durationController,
                      keyboardType: TextInputType.text,
                      obscureText: false,
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.schedule,
                          color: Colors.grey,
                        ),
                        hintText: "Duration of Payment(months)",
                        hintStyle: TextStyle(
                            color: Color(0xFF9b9b9b),
                            fontSize: 15,
                            fontWeight: FontWeight.normal),
                      ),
                    ),
                    SizedBox(
                        height: 15,
                      ),
                    TextField(
                      style: TextStyle(color: Color(0xFF000000)),
                      cursorColor: Color(0xFF9b9b9b),
                      controller: payDayController,
                      keyboardType: TextInputType.text,
                      obscureText: false,
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.calendar_today,
                          color: Colors.grey,
                        ),
                        hintText: "First Repayment Date",
                        hintStyle: TextStyle(
                            color: Color(0xFF9b9b9b),
                            fontSize: 15,
                            fontWeight: FontWeight.normal),
                      ),
                    ),
                    SizedBox(
                        height: 15,
                      ),
                    TextField(
                      style: TextStyle(color: Color(0xFF000000)),
                      cursorColor: Color(0xFF9b9b9b),
                      controller: guarantorController,
                      keyboardType: TextInputType.text,
                      obscureText: false,
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.supervised_user_circle,
                          color: Colors.grey,
                        ),
                        hintText: "Guarantor",
                        hintStyle: TextStyle(
                            color: Color(0xFF9b9b9b),
                            fontSize: 15,
                            fontWeight: FontWeight.normal),
                      ),
                    ),
                    SizedBox(
                        height: 15,
                      ),
                    TextField(
                      style: TextStyle(color: Color(0xFF000000)),
                      cursorColor: Color(0xFF9b9b9b),
                      controller: descriptionController,
                      keyboardType: TextInputType.text,
                      obscureText: false,
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.book_online,
                          color: Colors.grey,
                        ),
                        hintText: "Description",
                        hintStyle: TextStyle(
                            color: Color(0xFF9b9b9b),
                            fontSize: 15,
                            fontWeight: FontWeight.normal),
                      ),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        OutlineButton(
                          padding: EdgeInsets.symmetric(horizontal: 50),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          onPressed: () {},
                          child: Text("",
                              style: TextStyle(
                                  fontSize: 14,
                                  letterSpacing: 2.2,
                                  color: Colors.black)),
                        ),
                        RaisedButton(
                          onPressed: _isLoading ? null : _handleLoanRequest,
                          color: Colors.orange,
                          padding: EdgeInsets.symmetric(horizontal: 50),
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          child: Text(
                            _isLoading ? 'Requesting...' : 'REQUEST',
                            style: TextStyle(
                                fontSize: 14,
                                letterSpacing: 2.2,
                                color: Colors.white),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 15,
              ),
              SizedBox(
                height: 35,
              ),
            ],
          ),
        ),
      ),
    );
  }

  
  void _handleLoanRequest() async {
    setState(() {
      _isLoading = true;
    });

    var data = {
      'disbursedBy': "CASH",
      'duration': durationController.text,
      'firstRepaymentDate': payDayController.text,
      'principal': principalController.text,
      "securityDto": {
        'description': descriptionController.text,
        "file": "file",
        'guarantor': guarantorController.text,
        "id": 1
      },
      'repaymentCycle': "DAILY",
      'repaymentMode': "SALARY",
      'topUpMode': "NORMAL",
      'handlingMode': "NORMAL",
      'productId': 36
    };

    var response = await CallApi().postDataHeader(data,'loan/request');


    print("posted: " + jsonEncode(data));
    print("Reached Here: "+ response.body);

    if (response.statusCode != 200)
       throw Exception(response.body);

            
      setState(() {        
        _isLoading = false;
      });
            
    }
}
