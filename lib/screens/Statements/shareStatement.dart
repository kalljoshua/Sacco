
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sacco_app/api/api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sacco_app/util/userFetch.dart';

class ShareStatement extends StatefulWidget {
  @override
  _ShareStatementState createState() => _ShareStatementState();
}

class _ShareStatementState extends State<ShareStatement> {

  static const Color _primaryColor = Colors.deepPurpleAccent;
  static const Color _secondaryColor = Colors.deepOrangeAccent;

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

    var response  = await CallApi().getData('transaction/admin/shareTransactions');


    //print('Transactions: ' + response.body);

    if (response.statusCode == 200) {

      var transactions = json.decode(response.body)['sharesTransactions'];
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
          title: Text('Shares Statement'),
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
            _reportCell(
              isSavings: true,
              title: 'Shares Account',
              deposit: userData != null
                                ? format
                                    .format(userData.accountDto.totalShares*20000)
                                    .toString()
                                : '000.00',
              rate: '20,000',
              progress: userData != null
                                ? userData.accountDto.totalShares.round()
                                : 000,
            ),
            SizedBox(
              height: 32,
            ),
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
                  itemBuilder: (context, index) => ListTile(
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
                            Icons.verified,
                            color: Colors.green,
                            size: 30,
                          ),
                    ),
                    title: Text(
                      transactionData != null ? transactionData[index]['acctFrom']:'',
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Text(
                      transactionData != null ? transactionData[index]['date'].toString():' 0000-00-00',
                      style: TextStyle(
                        color: _primaryColor.withOpacity(0.6),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    trailing: Text(
                      transactionData != null ? format.format(transactionData[index]['amount']).toString(): '000.00',
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Report Cell
  Container _reportCell({
    bool isSavings,
    String title,
    String deposit,
    String rate,
    int progress,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 16),
      decoration: BoxDecoration(
        color: isSavings ? Colors.white : _secondaryColor,
        borderRadius: BorderRadius.circular(30),
        border: isSavings
            ? Border.all(color: _primaryColor.withOpacity(0.1), width: 2)
            : null,
        boxShadow: isSavings
            ? []
            : [
                BoxShadow(
                  color: _secondaryColor.withOpacity(0.4),
                  offset: Offset(0, 8),
                  blurRadius: 10,
                ),
              ],
      ),
      child: Row(
        children: <Widget>[
          Stack(
            children: <Widget>[
              SizedBox(
                width: 60,
                height: 60,
                child: CircularProgressIndicator(
                  value: progress / 100,
                  strokeWidth: 6,
                  backgroundColor: isSavings
                      ? _primaryColor.withOpacity(0.2)
                      : _primaryColor.withOpacity(0.1),
                  valueColor: AlwaysStoppedAnimation<Color>(
                      isSavings ? _secondaryColor : Colors.white),
                ),
              ),
              Container(
                width: 60,
                height: 60,
                alignment: Alignment.center,
                child: Text(
                  progress.toString() + '',
                  style: TextStyle(
                    color: isSavings ? _primaryColor : Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            width: 30,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                title,
                style: TextStyle(
                  color: isSavings ? _primaryColor : Colors.white,
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
                    title: 'Deposit',
                    value: deposit,
                  ),
                  SizedBox(
                    width: 24,
                  ),
                  _reportInnerCell(
                    isSavings: isSavings,
                    title: 'Rate',
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
            color: isSavings ? _primaryColor.withOpacity(0.5) : Colors.white,
            fontSize: 14,
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
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
