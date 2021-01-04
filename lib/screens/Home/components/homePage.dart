import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:sacco_app/screens/Home/components/allTransactions.dart';
import 'package:sacco_app/screens/Home/components/appDrawer.dart';
import 'package:sacco_app/screens/Loans/loansPage.dart';
import 'package:sacco_app/api/api.dart';
import 'package:sacco_app/screens/Membership/membershipPage.dart';
import 'package:sacco_app/screens/Savings/savingsPage.dart';
import 'package:sacco_app/screens/Shares/sharesPage.dart';
import 'package:sacco_app/util/userFetch.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'appDrawer.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  User userData;
  List transactionData = [];
  bool isLoading;
  int length;
  NumberFormat format = NumberFormat('#,###,###.00');

  @override
  void initState() {
    super.initState();
    isLoading = true;
    this.fetchTransactions();
  }

  fetchTransactions() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var userToken = localStorage.getString('token');
    print('i am here:' + userToken);

    var userSession = localStorage.getString('user');

    var responseJson = jsonDecode(userSession);

    var response = await CallApi().getData('transaction/myTransactions');

    print('i am now here: ' + response.body);
    if (response.statusCode == 200) {
      var transactions = json.decode(response.body)['userTransactions'];
      setState(() {
        userData = new User.fromJson(responseJson);
        transactionData = transactions;
        isLoading = true;
      });
      print('trans: ' + transactionData.length.toString());
    }

     if(transactionData.length >5)
      length = 6;
      else
      length = transactionData.length;
  }

  @override
  Widget build(BuildContext context) {
    Color primaryColor = Color.fromRGBO(255, 82, 48, 1);
    
    return Scaffold(
      //appBar: AppBar(title: Text("QC Sacco")),
      appBar: AppBar(
        title: Text("QC Sacco"),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                height: 250,
                decoration: BoxDecoration(color: primaryColor),
                child: Padding(
                  padding:
                      const EdgeInsets.only(left: 20, right: 20.0, top: 30),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 80.0,
                            height: 80.0,
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
                              borderRadius: BorderRadius.circular(40.0),
                            ),
                            padding: EdgeInsets.all(5),
                            child: CircleAvatar(
                              backgroundImage: NetworkImage(
                                  "https://images.pexels.com/photos/2167673/pexels-photo-2167673.jpeg?auto=compress&cs=tinysrgb&dpr=3&h=750&w=1260"),
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                userData != null
                                    ? userData.personDto.firstName +
                                        " " +
                                        userData.personDto.lastName
                                    : 'User',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  Icon(
                                    Icons.business_center_sharp,
                                    color: Colors.white,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  RichText(
                                    text: TextSpan(
                                      text: userData != null
                                          ? format
                                              .format(userData
                                                  .accountDto.totalSavings)
                                              .toString()
                                          : '000.00',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  )
                                ],
                              )
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),             

            Expanded(                
            child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 5, vertical: 30),
            physics: ClampingScrollPhysics(),
            child: Column(
              
              children: <Widget>[
                SizedBox(
                  height: 32,
                ),
                Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            "DashBoard",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                SizedBox(
                  height: 15,
                ),
                Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          buildActivityButton(
                              Icons.business_center_sharp,
                              "Savings",
                              Colors.blue.withOpacity(0.4),
                              Color(0XFF01579B)),
                          buildActivityButton(
                              Icons.card_membership,
                              "Membership",
                              Colors.greenAccent.withOpacity(0.4),
                              Color(0XFF01579B)),
                          buildActivityButton(
                              Icons.account_balance,
                              "Loans",
                              Colors.deepOrange.withOpacity(0.4),
                              Color(0XFF01579B)),
                          buildActivityButton(
                            Icons.pie_chart, 
                            "Shares",
                              Colors.green.withOpacity(0.4), 
                              Color(0XFF01579B)),
                        ],
                      ),
                SizedBox(
                  height: 15,
                ),
                Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            "Recent Transactions",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                    Divider(),
                    if(transactionData.length<=0) 
                      Text('                No data available')
                      else
                    ListView.separated(
                      primary: false,
                      shrinkWrap: true,
                      separatorBuilder: (context, index) => Divider(),
                      itemCount: length,
                      itemBuilder: (context, index) => buildCategoryCard(
                            Icons.verified,
                            transactionData[index]['date'],
                            transactionData[index]['acctFrom'] != null
                                          ? transactionData[index]['acctFrom']:'Username',
                            format
                                .format(transactionData[index]['amount'])
                                .toString(),
                          )
                    ),
                  ],
                ),
              ],
            ),
          ),
    )



            ],
          ),
          Positioned(
            top: 125,
            right: 0,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 25),
              width: MediaQuery.of(context).size.width * 0.85,
              height: 160,
              decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(.05),
                      blurRadius: 8,
                      spreadRadius: 3,
                      offset: Offset(0, 10),
                    ),
                  ],
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    bottomLeft: Radius.circular(50),
                  )),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                "Shares",
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18.0),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Icon(
                                Icons.pie_chart,
                                color: Color(0XFF00838F),
                              )
                            ],
                          ),
                          Text(
                            userData != null
                                ? userData.accountDto.totalShares
                                    .toString()
                                : '000.00',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18.0,
                                color: Colors.black87),
                          )
                        ],
                      ),
                      Container(width: 1, height: 50, color: Colors.grey),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                "Membership",
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18.0),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Icon(
                                Icons.card_membership,
                                color: Color(0XFF00838F),
                              )
                            ],
                          ),
                          Text(
                            userData != null
                                ? format
                                    .format(userData.accountDto.pendingFee)
                                    .toString()
                                : '000.00',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18.0,
                                color: Colors.black87),
                          )
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    userData != null
                        ? "You saved " +
                            format
                                .format(userData.accountDto.totalSavings)
                                .toString() +
                            " this month"
                        : "You saved 000.00 this month",
                    style: TextStyle(
                      fontSize: 13,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  SizedBox(
                    height: 3,
                  ),
                  Text(
                    "Let's see the cost statistics for this period",
                    style: TextStyle(
                      fontSize: 13,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 1,
                    width: double.maxFinite,
                    color: Colors.grey.withOpacity(0.5),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) => AllTransactions()));
                    },
                    child: Text(
                      "Tell me more",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0XFF00B686)),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),

      drawer: MainDrawer(),
    );
  }

  GestureDetector buildActivityButton(
      IconData icon, String title, Color backgroundColor, Color iconColor) {
    return GestureDetector(
      onTap: () {
        if (title == 'Savings') {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => SavingsPage()));
        } else if (title == 'Loans') {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => LoansPage()));
        } else if (title == 'Membership') {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => MembershipPage()));
        } else if (title == 'Shares') {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => SharesPage()));
        }
      },
      child: Container(
        margin: EdgeInsets.all(5),
        height: 80,
        width: 80,
        decoration: BoxDecoration(
            color: backgroundColor, borderRadius: BorderRadius.circular(10.0)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: iconColor,
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              title,
              style: TextStyle(
                  color: Colors.black54,
                  fontWeight: FontWeight.bold,
                  fontSize: 12),
            )
          ],
        ),
      ),
    );
  }

  Container buildCategoryCard(
      IconData icon, String date, String acctFrom, String amount) {
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
                            icon,
                            color: Colors.green,
                            size: 30,
                          ),
                    ),
                    title: Text(
                      acctFrom,
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Text(
                     date,
                      style: TextStyle(
                        color: Colors.deepPurpleAccent.withOpacity(0.6),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    trailing: Text(
                      amount,
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
