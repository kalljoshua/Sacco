import 'package:flutter/material.dart';
//import 'package:sacco_app/screens/Home/componemts/body.dart';
import 'package:sacco_app/screens/Login/components/background.dart';
import 'package:sacco_app/screens/Signup/signup_screen.dart';
import 'package:sacco_app/screens/Home/homeScreen.dart';
import 'package:sacco_app/components/already_have_an_account_acheck.dart';
import 'package:sacco_app/services/loginService.dart';
import 'package:flutter_svg/svg.dart';
import 'package:toast/toast.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  bool _isLoading = false;

  TextEditingController mobileController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
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
              "LOGIN",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: size.height * 0.03),
            SvgPicture.asset(
              "assets/icons/login.svg",
              height: size.height * 0.35,
            ),
            SizedBox(height: size.height * 0.03),

            /////////////  Email//////////////
                            TextField(
                              style: TextStyle(color: Color(0xFF000000)),
                              controller: mobileController,
                              cursorColor: Color(0xFF9b9b9b),
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.account_circle,
                                  color: Colors.grey,
                                ),
                                hintText: "Username ",
                                hintStyle: TextStyle(
                                    color: Color(0xFF9b9b9b),
                                    fontSize: 15,
                                    fontWeight: FontWeight.normal),
                              ),
                            ),

                            /////////////// password////////////////////
                            TextField(
                              style: TextStyle(color: Color(0xFF000000)),
                              cursorColor: Color(0xFF9b9b9b),
                              controller: passwordController,
                              keyboardType: TextInputType.text,
                              obscureText: true,
                              decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.vpn_key,
                                  color: Colors.grey,
                                ),
                                hintText: "Password",
                                hintStyle: TextStyle(
                                    color: Color(0xFF9b9b9b),
                                    fontSize: 15,
                                    fontWeight: FontWeight.normal),
                              ),
                            ),
            
            /////////////  LogIn Botton///////////////////
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: FlatButton(
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      top: 8, bottom: 8, left: 10, right: 10),
                                  child: Text(
                                    _isLoading ? 'Loging...' : 'Login',
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
                                onPressed: _isLoading ? null : _processLogin,
                              ),
                            ),
            SizedBox(height: size.height * 0.03),
            AlreadyHaveAnAccountCheck(
              press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return SignUpScreen();
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
  void _processLogin() async {
    setState(() {
      _isLoading = true;
    });

    var data = {
      'userName': mobileController.text,
      'password': passwordController.text
    };

    //var data = {'userName': "0752306399", 'password': "QC-6608"};
    //var data = {'userName': "0789647528", 'password': "QC-4283"};
    if(mobileController.text == '' || passwordController.text == '')
    {
      Toast.show("Fields can't be empty!!", context, duration: Toast.LENGTH_LONG, gravity:  Toast.CENTER, backgroundColor:Colors.red);
      setState(() {
      _isLoading = false;
      });   
    } else{


    LoginService service = LoginService();
    var loginResponse = await service.login(data);

    Toast.show(loginResponse.getMessage(), context, duration: Toast.LENGTH_LONG, gravity:  Toast.CENTER, backgroundColor:Colors.red);

    setState(() {
      _isLoading = false;
    });
    if (loginResponse.getStatus() == false) {
      Toast.show("Login Failed", context, duration: Toast.LENGTH_LONG, gravity:  Toast.CENTER, backgroundColor:Colors.red);
      setState(() {
      _isLoading = false;
      }); 
      
    } else{
      Toast.show("Login Successful", context, duration: Toast.LENGTH_LONG, gravity:  Toast.CENTER, backgroundColor:Colors.green);
    Navigator.push(
        context, new MaterialPageRoute(builder: (context) => HomePage()));
    }
   
    }
  }
}
