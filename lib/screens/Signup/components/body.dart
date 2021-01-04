import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sacco_app/api/api.dart';
import 'package:sacco_app/screens/Login/login_screen.dart';
import 'package:sacco_app/screens/Signup/components/background.dart';
import 'package:sacco_app/components/already_have_an_account_acheck.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sacco_app/screens/Signup/signup_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';


class SignUpBody extends StatefulWidget {
  @override
  _SignUpBodyState createState() => _SignUpBodyState();
}

class _SignUpBodyState extends State<SignUpBody> {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController mailController = TextEditingController();
  TextEditingController ninController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController residenceController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  bool _isLoading = false;

  ScaffoldState scaffoldState; 


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Background(
      child: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(30.0),
          child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "SIGNUP",
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold),
            ),
            SizedBox(height: size.height * 0.03),
            SvgPicture.asset(
              "assets/icons/signup.svg",
              height: size.height * 0.35,
            ),
            /////////////// name////////////
                            TextField(
                              style: TextStyle(color: Color(0xFF000000)),
                              controller: firstNameController,
                              cursorColor: Color(0xFF9b9b9b),
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.account_circle,
                                  color: Colors.grey,
                                ),
                                hintText: "Firstname",
                                hintStyle: TextStyle(
                                    color: Color(0xFF9b9b9b),
                                    fontSize: 15,
                                    fontWeight: FontWeight.normal),
                              ),
                            ),
                            TextField(
                              style: TextStyle(color: Color(0xFF000000)),
                              controller: lastNameController,
                              cursorColor: Color(0xFF9b9b9b),
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.account_circle,
                                  color: Colors.grey,
                                ),
                                hintText: "Lastname",
                                hintStyle: TextStyle(
                                    color: Color(0xFF9b9b9b),
                                    fontSize: 15,
                                    fontWeight: FontWeight.normal),
                              ),
                            ),

                            /////////////// Email ////////////
                            TextField(
                              style: TextStyle(color: Color(0xFF000000)),
                              controller: mailController,
                              cursorColor: Color(0xFF9b9b9b),
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.mail,
                                  color: Colors.grey,
                                ),
                                hintText: "Email ",
                                hintStyle: TextStyle(
                                    color: Color(0xFF9b9b9b),
                                    fontSize: 15,
                                    fontWeight: FontWeight.normal),
                              ),
                            ),

                            /////////////// Gender ////////////
                            TextField(
                              style: TextStyle(color: Color(0xFF000000)),
                              controller: genderController,
                              cursorColor: Color(0xFF9b9b9b),
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.wc_outlined,
                                  color: Colors.grey,
                                ),
                                hintText: "Gender ",
                                hintStyle: TextStyle(
                                    color: Color(0xFF9b9b9b),
                                    fontSize: 15,
                                    fontWeight: FontWeight.normal),
                              ),
                            ),
                            /////////////// password ////////////
                            TextField(
                              style: TextStyle(color: Color(0xFF000000)),
                              cursorColor: Color(0xFF9b9b9b),
                              controller: ninController,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.perm_identity,
                                  color: Colors.grey,
                                ),
                                hintText: "National ID No.",
                                hintStyle: TextStyle(
                                    color: Color(0xFF9b9b9b),
                                    fontSize: 15,
                                    fontWeight: FontWeight.normal),
                              ),
                            ),

                            ///DOB///
                            TextField(
                              style: TextStyle(color: Color(0xFF000000)),
                              controller: dobController,
                              cursorColor: Color(0xFF9b9b9b),
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.calendar_today,
                                  color: Colors.grey,
                                ),
                                hintText: "Date of Birth",
                                hintStyle: TextStyle(
                                    color: Color(0xFF9b9b9b),
                                    fontSize: 15,
                                    fontWeight: FontWeight.normal),
                              ),
                            ),
                            ////phone number///
                            TextField(
                              style: TextStyle(color: Color(0xFF000000)),
                              controller: phoneController,
                              cursorColor: Color(0xFF9b9b9b),
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.mobile_screen_share,
                                  color: Colors.grey,
                                ),
                                hintText: "Phone",
                                hintStyle: TextStyle(
                                    color: Color(0xFF9b9b9b),
                                    fontSize: 15,
                                    fontWeight: FontWeight.normal),
                              ),
                            ),

                            ////residence///
                            TextField(
                              style: TextStyle(color: Color(0xFF000000)),
                              controller: residenceController,
                              cursorColor: Color(0xFF9b9b9b),
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.pin_drop,
                                  color: Colors.grey,
                                ),
                                hintText: "Residence",
                                hintStyle: TextStyle(
                                    color: Color(0xFF9b9b9b),
                                    fontSize: 15,
                                    fontWeight: FontWeight.normal),
                              ),
                            ),
            /////////////// SignUp Button ////////////
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: FlatButton(
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        top: 8, bottom: 8, left: 10, right: 10),
                                    child: Text(
                                      _isLoading
                                          ? 'Creating...'
                                          : 'Create account',
                                      textDirection: TextDirection.ltr,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15.0,
                                        decoration: TextDecoration.none,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                  ),
                                  color: Colors.red,
                                  disabledColor: Colors.grey,
                                  shape: new RoundedRectangleBorder(
                                      borderRadius:
                                          new BorderRadius.circular(20.0)),
                                  onPressed: _isLoading ? null : _handleLogin),
                            ),
            SizedBox(height: size.height * 0.03),
            AlreadyHaveAnAccountCheck(
              login: false,
              press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return LoginScreen();
                    },
                  ),
                );
              },
            ),
          ],
        ),
      )
      ),
    );
  }


  void _handleLogin() async {     

    setState(() {     
      _isLoading = true;
    });

      var data = {
      'firstName': firstNameController.text,
      'lastName': lastNameController.text,
      'email': mailController.text,
      'nin': ninController.text,
      'mobile': phoneController.text,
      'dob': dobController.text,
      'gender': genderController.text,
      'residence': residenceController.text,
    };

    if(firstNameController.text == '' || lastNameController.text == '' || mailController.text == '' || phoneController.text == '')
    {
      Toast.show("Fields can't be empty!!", context, duration: Toast.LENGTH_LONG, gravity:  Toast.CENTER, backgroundColor:Colors.red);
      setState(() {
      _isLoading = false;
    });   
    } else{

    var res = await CallApi().postData(data, 'profile/user/signUp');
    print('Response: '+res.body);
    var body = json.decode(res.body);
    print(res.statusCode);
    if (res.statusCode == 200) {
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      localStorage.setString('token', body['token']);
      localStorage.setString('user', json.encode(body['user']));

      Toast.show("Registration Successfull", context, duration: Toast.LENGTH_LONG, gravity:  Toast.CENTER, backgroundColor:Colors.green);
      setState(() {
      _isLoading = false;
    });     

      Navigator.push(
          context, new MaterialPageRoute(builder: (context) => LoginScreen()));
    } else {
      Toast.show("Failed, please try again", context, duration: Toast.LENGTH_LONG, gravity:  Toast.CENTER, backgroundColor:Colors.green);
      Navigator.push(
          context, new MaterialPageRoute(builder: (context) => SignUpScreen()));

      setState(() {
      _isLoading = false;
    });    
    
      
    }
  }
    
  }
}
