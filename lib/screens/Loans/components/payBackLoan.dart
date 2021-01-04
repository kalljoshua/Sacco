import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sacco_app/api/api.dart';
import 'package:sacco_app/screens/Home/homeScreen.dart';
import 'package:toast/toast.dart';

class PayLoanPage extends StatefulWidget {
  @override
  _PayLoanPageState createState() => _PayLoanPageState();
}

class _PayLoanPageState extends State<PayLoanPage> {
  TextEditingController amountController = TextEditingController();
  TextEditingController methodController = TextEditingController();
  

  bool _isLoading = false; 
  String _value = '';
  bool _isChecked = true;

  List loansData = List();

  @override
  void initState() {
    super.initState();
    this.fetchTransactions();
  }

  fetchTransactions() async {
     var response = await CallApi().getData('loan/myLoans'); 

     if (response.statusCode == 200) {

      var loans = json.decode(response.body);    

      print("Loans: "+response.body);  
      
      setState(() {
        loansData = loans;
      });
      
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pay Loan'),
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
                "Pay Loan Form",
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
                      controller: amountController,
                      keyboardType: TextInputType.text,
                      obscureText: false,
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.attach_money,
                          color: Colors.grey,
                        ),
                        hintText: "Amount to pay",
                        hintStyle: TextStyle(
                            color: Color(0xFF9b9b9b),
                            fontSize: 15,
                            fontWeight: FontWeight.normal),
                      ),
                    ),
                    SizedBox(height: 15),
                    if(loansData.length <= 0 )
                    Text("You have no running loans")
                    else
                    Text("Select Loan to pay"),
                     Column(
                          children: loansData
                              .map((item) => CheckboxListTile(
                                    title: Text(item['totalDue'].toString()),
                                    value: _isChecked,
                                    onChanged: (val) {
                                      setState(() {
                                        _isChecked = val;
                                        if (val == true) {
                                          _value = item['id'].toString();
                                        }
                                      });
                                    },
                                  ))
                              .toList(),
                        ),
                      
                     
                   /* DropdownButton(
                      value: _value,
                      items: loansData.map((item) {
                        return new DropdownMenuItem(
                          child: new Text(item['totalDue'].toString()),
                          value: item['id'].toString(),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _value = loansData.isEmpty
                              ? value
                              : loansData.firstWhere((item) => item.value == value.value);;
                        });
                      }),*/
                      
                    SizedBox(height: 15),
                    TextField(
                      style: TextStyle(color: Color(0xFF000000)),
                      cursorColor: Color(0xFF9b9b9b),
                      controller: methodController,
                      keyboardType: TextInputType.text,
                      obscureText: false,
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.money,
                          color: Colors.grey,
                        ),
                        hintText: "Payment Method",
                        hintStyle: TextStyle(
                            color: Color(0xFF9b9b9b),
                            fontSize: 15,
                            fontWeight: FontWeight.normal),
                      ),
                    ),
                    SizedBox(
                        height: 20,
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
                          onPressed: _isLoading ? null : _handleLoanPay,
                          color: Colors.orange,
                          padding: EdgeInsets.symmetric(horizontal: 50),
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          child: Text(
                            _isLoading ? 'Paying...' : 'Pay Loan',
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

  
  void _handleLoanPay() async {
    setState(() {
      _isLoading = true;
    });

    var amount = amountController.text;

    var data = {
        "amount": amountController.text,
        "loanId": _value,
        "transactionType": methodController.text
      };

    var response = await CallApi().postDataHeader(data,'transaction/loan/mobileRepay');

    print("posted: " + jsonEncode(data));
    print("Reached Here: "+ response.body);

    if (response.statusCode == 200) {
      
      print("Sucessful: " + response.body);
      Toast.show("Successfully paid $amount", context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM, backgroundColor:Colors.green);
      setState(() {
        _isLoading = false;
      });
      Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) => HomePage())).then((value){
          
        });
    } else {
      Toast.show("Loan payment failed", context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM, backgroundColor:Colors.green);
      print("failed: " + response.statusCode.toString());
      setState(() {
        _isLoading = false;
      });
      Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) => HomePage())).then((value){
         
        });
    }
  }
}
