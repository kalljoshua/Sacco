import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sacco_app/api/api.dart';
import 'package:sacco_app/screens/Loans/components/payBackLoan.dart';
import 'package:sacco_app/screens/Loans/components/requestLoan.dart';
import 'package:sacco_app/screens/Statements/loanStatement.dart';

import 'package:sacco_app/util/userFetch.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LoansPage extends StatefulWidget {
  @override
  _LoansPageState createState() => _LoansPageState();
}

class _LoansPageState extends State<LoansPage> {
  
  List loansData = [];
  List transactionData = [];
  var loan;
  int length;
  User userData;
  String dateToday = DateFormat('yyyy-MM-dd').format(new DateTime.now()); 
  var sumLoan =0;

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

    var response = await CallApi().getData('loan/myLoans');   
    var res = await CallApi().getData('transaction/admin/loanTransactions');


    print('Loans: ' + response.body);
    print('transactions: ' + res.body);


    if (response.statusCode == 200) {

      var loans = json.decode(response.body);
      var transactions = json.decode(res.body)['loanTransactions'];
      
      
      setState(() {
        userData = new User.fromJson(responseJson);
        loansData = loans;
        transactionData = transactions;
      });
      
    }
    if(transactionData.length >5)
      length = 5;
      else
      length = transactionData.length;
  }
  


  @override
  Widget build(BuildContext context) {
    Color primaryColor = Color.fromRGBO(255, 82, 48, 1);
    NumberFormat format = NumberFormat('#,###,###.00');      
    
        return Scaffold(
          appBar: AppBar(
              title: Text('Loans'),
              backgroundColor: Colors.purple,
            ),
          backgroundColor: Color.fromRGBO(244, 244, 244, 1),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  
                ),
                Stack(
                  children: <Widget>[
                    ClipPath(
                      clipper: CustomShapeClipper(),
                      child: Container(
                        height: 330.0,
                        decoration: BoxDecoration(color: primaryColor),
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 25.0, vertical: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(                                
                                '2800,00',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 30.0,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 15.0),
                              Text(
                                'Avalilable Loans',
                                style:
                                    TextStyle(color: Colors.white, fontSize: 18.0),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 120.0, right: 25.0, left: 25.0),
                      child: Container(
                        width: double.infinity,
                        height: 200.0,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(20.0)),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  offset: Offset(0.0, 3.0),
                                  blurRadius: 15.0)
                            ]),
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 40.0, vertical: 20.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Column(
                                    children: <Widget>[
                                      Material(
                                        borderRadius: BorderRadius.circular(100.0),
                                        color: Colors.purple.withOpacity(0.1),
                                        child: IconButton(
                                          padding: EdgeInsets.all(15.0),
                                          icon: Icon(Icons.send),
                                          color: Colors.purple,
                                          iconSize: 30.0,
                                          onPressed: () {
                                            Navigator.of(context).push(MaterialPageRoute(
                                              builder: (BuildContext context) => RequestLoanPage()));
                                          },
                                        ),
                                      ),
                                      SizedBox(height: 8.0),
                                      Text('Request Loan',
                                          style: TextStyle(
                                              color: Colors.black54,
                                              fontWeight: FontWeight.bold))
                                    ],
                                  ),
                                  Column(
                                    children: <Widget>[
                                      Material(
                                        borderRadius: BorderRadius.circular(100.0),
                                        color: Colors.blue.withOpacity(0.1),
                                        child: IconButton(
                                          padding: EdgeInsets.all(15.0),
                                          icon: Icon(Icons.credit_card),
                                          color: Colors.blue,
                                          iconSize: 30.0,
                                          onPressed: () {
                                            Navigator.of(context).push(MaterialPageRoute(
                                              builder: (BuildContext context) => PayLoanPage()));
                                          },
                                        ),
                                      ),
                                      SizedBox(height: 8.0),
                                      Text('Pay Loan',
                                          style: TextStyle(
                                              color: Colors.black54,
                                              fontWeight: FontWeight.bold))
                                    ],
                                  ),
                                  Column(
                                    children: <Widget>[
                                      Material(
                                        borderRadius: BorderRadius.circular(100.0),
                                        color: Colors.orange.withOpacity(0.1),
                                        child: IconButton(
                                          padding: EdgeInsets.all(15.0),
                                          icon: Icon(Icons.receipt),
                                          color: Colors.orange,
                                          iconSize: 30.0,
                                          onPressed: () {
                                            Navigator.of(context).push(MaterialPageRoute(
                                              builder: (BuildContext context) => LoanStatement()));
                                          },
                                        ),
                                      ),
                                      SizedBox(height: 8.0),
                                      Text('Statement',
                                          style: TextStyle(
                                              color: Colors.black54,
                                              fontWeight: FontWeight.bold))
                                    ],
                                  )
                                ],
                              ),
                            ),                       
                           
                            SizedBox(height: 10.0),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 25.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Expanded(
                                    child: Text(
                                      'Your next payment is on 2020-Dec-21',
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 10.0),
                  child: Text(
                    'Current Loans',
                style: TextStyle(
                    color: Colors.black.withOpacity(0.7),
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0),
              ),
            ),
            if(loansData.length<=0) 
            Text('                No data available'),
            new GestureDetector(
              onTap: () {
                print("Gesture recieved");
              },
              child: Padding(
              padding: EdgeInsets.only(left: 20.0, bottom: 10.0),
              child: Container(
                height: 120.0,                
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: loansData.length,
                    itemBuilder: (context, index) {
                      return _reportCell(
                      isSavings: true,
                      title: 'Loans Account',
                      deposit: loansData != null
                                        ? format
                                            .format(loansData[index]['totalDue'])
                                            .toString()
                                        : '000.00',
                      rate: loansData != null
                                        ? format
                                            .format(loansData[index]['totalPaid'])
                                            .toString()
                                        : '000.00',
                      
                    );
                    },                 
                    
                ),
              ),
            ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 10.0),
              child: Text(
                'Recent Transactions',
                style: TextStyle(
                    color: Colors.black.withOpacity(0.7),
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0),
              ),
            ),
            if(transactionData.length<=0) 
            Text('                No data available')
            else
            ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              shrinkWrap: true,
              itemCount: length,
              itemBuilder: (context, index) {
                return buildContactRow(
                  Icons.verified,
                  transactionData != null ? transactionData[index]['acctFrom']: ' Account To',
                  transactionData != null ? format.format(transactionData[index]['amount']).toString(): '000.00',
                  transactionData != null ? transactionData[index]['date'].toString():' 0000-00-00',
                );
              },
              
            ),
            
          ],
        ),
      ),
    );
  }
  Container buildContactRow(IconData icon, String name, String amount, String phone,) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(width: 1, color: Colors.grey[200]),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: Colors.blueAccent,
                size: 30,
              ),
              SizedBox(
                width: 40,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.lock_clock,
                        color: Colors.grey,
                        size: 16,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        phone,
                        style: (TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        )),
                      )
                    ],
                  )
                ],
              )
            ],
          ),
          Row(
            children: [
                Text(
                  amount,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
            ],
          
          ),
         /*Material(
                borderRadius: BorderRadius.circular(100.0),
                color: Colors.blueAccent.withOpacity(0.1),
                child: IconButton(
                icon: Icon(Icons.arrow_forward_ios),
                color: Colors.blueAccent,
                onPressed: () {

                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Transaction Details'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text("Monthly Loan payment: \$5320"),
                          Text("Date: 16-October-2020"),
                          Text("Status: Success"),
                          Icon(
                            Icons.check,
                            size: 59,
                            color: Colors.green,
                          ),
                        ],
                      ),
                      actions: [
                        FlatButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text("Close")),
                      ],
                    );
                  });
                },
                  ),
            ),*/
        ]
      ),
    );
  }
}


class CustomShapeClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();

    path.lineTo(0.0, 390.0 - 200);
    path.quadraticBezierTo(size.width / 2, 280, size.width, 390.0 - 200);
    path.lineTo(size.width, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}

  Container _reportCell({
    bool isSavings,
    String title,
    String deposit,
    String rate,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 16),
      decoration: BoxDecoration(
        color: isSavings ? Colors.white : Colors.deepOrangeAccent,
        borderRadius: BorderRadius.circular(30),
        border: isSavings
            ? Border.all(color: Colors.deepPurpleAccent.withOpacity(0.1), width: 2)
            : null,
        boxShadow: isSavings
            ? []
            : [
                BoxShadow(
                  color: Colors.deepOrangeAccent.withOpacity(0.4),
                  offset: Offset(0, 8),
                  blurRadius: 10,
                ),
              ],
      ),
      child: Row(
        children: <Widget>[          
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                title,
                style: TextStyle(
                  color: isSavings ? Colors.deepPurpleAccent: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(
                height: 12,
              ),
              Row(
                children: <Widget>[
                  _reportInnerCell(
                    isSavings: isSavings,
                    title: 'Total Debit',
                    value: deposit,
                  ),
                  SizedBox(
                    width: 24,
                  ),
                  _reportInnerCell(
                    isSavings: isSavings,
                    title: 'Deposit',
                    value: rate,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Report Inner Cell
  Column _reportInnerCell({bool isSavings, String title, String value}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          title,
          style: TextStyle(
            color: isSavings ? Colors.deepPurpleAccent.withOpacity(0.5) : Colors.white,
            fontSize: 17,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(
          height: 4,
        ),
        Text(
          value,
          style: TextStyle(
            color: isSavings ? Colors.black87 : Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

