
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sacco_app/api/api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sacco_app/util/userFetch.dart';

class AllTransactions extends StatefulWidget {
  @override
  _AllTransactionsState createState() => _AllTransactionsState();
}

class _AllTransactionsState extends State<AllTransactions> {

  static const Color _primaryColor = Colors.deepPurpleAccent;
  List transactionData = [];
  User userData;
  NumberFormat format = NumberFormat('#,###,###.00');
  

  @override
  void initState() {
    super.initState();
    this.fetchTransactions();
  }

  fetchTransactions() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var userToken = localStorage.getString('token');
    print('i am here:' + userToken);

    var userSession = localStorage.getString('user');

    var responseJson = jsonDecode(userSession);

    var response  = await CallApi().getData('transaction/myTransactions');


    //print('Transactions: ' + response.body);

    if (response.statusCode == 200) {

      var transactions = json.decode(response.body)['userTransactions'];
      print('Transactions: ' + transactions.length.toString());
      setState(() {
        userData = new User.fromJson(responseJson);
        transactionData = transactions;
      });
      
    }
  }
  /// **********************************************
  /// LIFE CYCLE METHODS
  /// **********************************************

  @override
  Widget build(BuildContext context) {    
    return Scaffold(
      appBar: AppBar(
          title: Text('Transaction Statements'),
          backgroundColor: Colors.purple,
        ),
      body: Column(
        children: <Widget>[
          _mainBody(),
        ],
      ),
    );
  }

  /// **********************************************
  /// WIDGETS
  /// **********************************************


  /// Main Body
  Expanded _mainBody() {
    return Expanded(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        physics: ClampingScrollPhysics(),
        child: Column(
          children: <Widget>[
            
            Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Transactions',
                        style: TextStyle(
                          color: _primaryColor,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(),
                ListView.separated(
                  primary: false,
                  shrinkWrap: true,
                  separatorBuilder: (context, index) => Divider(),
                  itemCount: transactionData.length,
                  itemBuilder: (context, index) => buildCategoryCard(
                            Icons.verified,
                            transactionData[index]['date'],
                            transactionData[index]['category'] != null
                                          ? transactionData[index]['category']:'Category',
                            format
                                .format(transactionData[index]['amount'])
                                .toString(),
                            transactionData[index]['acctFrom'] != null
                                          ? transactionData[index]['acctFrom']:'Username',
                            transactionData[index]['transactionType'] != null
                                          ? transactionData[index]['transactionType']:'Mode'
                  )
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }


  Container buildCategoryCard(
      IconData icon, String date, String title, String amount, String acctFrom, String mode) {
    return Container(
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(.10),
                      blurRadius: 8,
                      spreadRadius: 3,
                      offset: Offset(0, 10),
                    ),
                  ],
        color: Colors.white.withOpacity(0.5),
      ),
      height: 105,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    icon,
                    color: Color(0xFF00B686),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    date,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    "$amount",
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  /*Icon(
                    view,
                    color: Color(0xFF00B686),
                  )*/
                ],
              )
            ],
          ),
          SizedBox(
            height: 15,
          ),
          Stack(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: 32,
                      ),
                      Text(
                        acctFrom,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        mode,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          
        ],
      ),
    );
  }
  
}
