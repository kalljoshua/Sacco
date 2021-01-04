import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:sacco_app/api/api.dart';
import 'package:sacco_app/util/userFetch.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:toast/toast.dart';


class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  //word details
  TextEditingController basicSalaryController = TextEditingController();
  TextEditingController companyNameController = TextEditingController();
  TextEditingController employeeIdController = TextEditingController();
  TextEditingController jobController = TextEditingController();
  TextEditingController workStationController = TextEditingController();
  //password
  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  //bank details
  TextEditingController accountNameController = TextEditingController();
  TextEditingController accountNumberController = TextEditingController();
  TextEditingController branchController = TextEditingController();
  TextEditingController nameController = TextEditingController();


  bool _isLoading = false;
  bool showPassword = false;

  File _image;

  User userData;
  @override
  void initState() {
    fetchUser();
    super.initState();
  }

  void fetchUser() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var userSession = localStorage.getString('user');

    var responseJson = jsonDecode(userSession);
    setState(() {
      userData = new User.fromJson(responseJson);
    });
    //print('Response Data: ' + userSession);
  }

  @override
  Widget build(BuildContext context) {
    NumberFormat format = NumberFormat('#,###,###.00'); 

    Future getImage() async {
      var image = await ImagePicker.pickImage(source: ImageSource.gallery);
       //if()
       setState(() {
         _image = image;
          print('Image Path $_image'); 

          print("Profile Picture uploaded");
          Toast.show("Profile Picture uploaded", context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM, backgroundColor:Colors.green);
       });

       String fileName = basename(_image.path);
       StorageReference firebaseStorageRef = FirebaseStorage.instance.ref().child(fileName);
       StorageUploadTask uploadTask = firebaseStorageRef.putFile(_image);
       StorageTaskSnapshot taskSnapshot=await uploadTask.onComplete;


       print("Profile Picture uploaded:" + taskSnapshot.toString());

    }

    
    return Scaffold(
       body: Container(
        padding: EdgeInsets.only(left: 16, top: 15, right: 16),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: ListView(
            children: [              
              SizedBox(
                height: 15,
              ),
              Center(
                child: Stack(
                  children: [
                    Container(
                      child: CircleAvatar(
                      radius: 100,
                      backgroundColor: Color(0xff476cfb),
                      child: ClipOval(
                        child: new SizedBox(
                          width: 120.0,
                          height: 120.0,
                          child: (_image!=null)?Image.file(
                            _image,
                            fit: BoxFit.fill,
                          ):Image.network(
                            "https://images.unsplash.com/photo-1502164980785-f8aa41d53611?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=500&q=60",
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ),
                    ),
                    Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          height: 30,
                          width: 30,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              width: 4,
                              color: Theme.of(context).scaffoldBackgroundColor,
                            ),
                            color: Colors.grey,
                          ),
                          child: IconButton(
                          icon: Icon(
                            Icons.edit,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            getImage();
                          },
                          )
                        )),
                  ],
                ),
              ),
              SizedBox(
                height: 35,
              ),
              Container(
                alignment: Alignment.center,
                child: Text(
                  userData != null
                      ? 'Name: ' +
                          userData.personDto.firstName +
                          ' ' +
                          userData.personDto.lastName
                      : '',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
                ),
              ),
              SizedBox(height: 20),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                alignment: Alignment.center,
                child: Text(
                  userData != null ? 'Email: ' + userData.personDto.email : '',
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 20),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Text(
                          userData != null
                              ? format
                                            .format(userData.accountDto.totalSavings).toString()
                              : '',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text('Savings')
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        Text(
                          userData != null
                              ? userData.accountDto.totalShares.toString()
                              : '',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text('Shares')
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        Text(
                          userData != null
                              ? format
                                            .format(userData.accountDto.pendingFee).toString()
                              : '',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text('Membership')
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 35,
              ),
              ExpansionTile(title: Text("Update Password"),
                  //trailing: Icon(FontAwesomeIcons.signInAlt),
                  children: <Widget>[
                    TextField(
                      style: TextStyle(color: Color(0xFF000000)),
                      cursorColor: Color(0xFF9b9b9b),
                      controller: oldPasswordController,
                      keyboardType: TextInputType.text,
                      obscureText: false,
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.vpn_key,
                          color: Colors.grey,
                        ),
                        hintText: "Username",
                        hintStyle: TextStyle(
                            color: Color(0xFF9b9b9b),
                            fontSize: 15,
                            fontWeight: FontWeight.normal),
                      ),
                    ),
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
                        hintText: "New Password",
                        hintStyle: TextStyle(
                            color: Color(0xFF9b9b9b),
                            fontSize: 15,
                            fontWeight: FontWeight.normal),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [                        
                        RaisedButton(
                          onPressed: _isLoading ? null : _handlePasswordUpdate,
                          color: Colors.green,
                          padding: EdgeInsets.symmetric(horizontal: 50),
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          child: Text(
                            _isLoading ? 'Updating...' : 'SAVE',
                            style: TextStyle(
                                fontSize: 14,
                                letterSpacing: 2.2,
                                color: Colors.white),
                          ),
                        )
                      ],
                    ),
                  ]),
              SizedBox(
                height: 15,
              ),
              ExpansionTile(
                title: Text("Additional Work Information"),
                //trailing: Icon(FontAwesomeIcons.signInAlt),
                children: <Widget>[
                  TextField(
                    style: TextStyle(color: Color(0xFF000000)),
                    controller: companyNameController,
                    cursorColor: Color(0xFF9b9b9b),
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.work,
                        color: Colors.grey,
                      ),
                      hintText: userData != null &&
                              userData.workDto.companyName != null
                          ? userData.workDto.companyName
                          : 'Company Name',
                      hintStyle: TextStyle(
                          color: Color(0xFF9b9b9b),
                          fontSize: 15,
                          fontWeight: FontWeight.normal),
                    ),
                  ),
                  TextField(
                    style: TextStyle(color: Color(0xFF000000)),
                    controller: employeeIdController,
                    cursorColor: Color(0xFF9b9b9b),
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.work,
                        color: Colors.grey,
                      ),
                      hintText: userData != null &&
                              userData.workDto.employeeId != null
                          ? userData.workDto.employeeId
                          : 'Employee ID',
                      hintStyle: TextStyle(
                          color: Color(0xFF9b9b9b),
                          fontSize: 15,
                          fontWeight: FontWeight.normal),
                    ),
                  ),
                  TextField(
                    style: TextStyle(color: Color(0xFF000000)),
                    controller: basicSalaryController,
                    cursorColor: Color(0xFF9b9b9b),
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.work,
                        color: Colors.grey,
                      ),
                      hintText: userData != null &&
                              userData.workDto.basicSalary.toString() != null
                          ? userData.workDto.basicSalary.toString()
                          : 'Basic Salary',
                      hintStyle: TextStyle(
                          color: Color(0xFF9b9b9b),
                          fontSize: 15,
                          fontWeight: FontWeight.normal),
                    ),
                  ),
                  TextField(
                    style: TextStyle(color: Color(0xFF000000)),
                    controller: jobController,
                    cursorColor: Color(0xFF9b9b9b),
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.work,
                        color: Colors.grey,
                      ),
                      hintText: userData != null && userData.workDto.job != null
                          ? userData.workDto.job
                          : 'Job Title',
                      hintStyle: TextStyle(
                          color: Color(0xFF9b9b9b),
                          fontSize: 15,
                          fontWeight: FontWeight.normal),
                    ),
                  ),
                  TextField(
                    style: TextStyle(color: Color(0xFF000000)),
                    controller: workStationController,
                    cursorColor: Color(0xFF9b9b9b),
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.work,
                        color: Colors.grey,
                      ),
                      hintText: userData != null &&
                              userData.workDto.workStation != null
                          ? userData.workDto.workStation
                          : 'WorkStation',
                      hintStyle: TextStyle(
                          color: Color(0xFF9b9b9b),
                          fontSize: 15,
                          fontWeight: FontWeight.normal),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      
                      RaisedButton(
                        onPressed: _isLoading ? null : _handleWorkUpdate,
                        color: Colors.green,
                        padding: EdgeInsets.symmetric(horizontal: 50),
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        child: Text(
                          _isLoading ? 'Updating...' : 'SAVE',
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
              SizedBox(
                height: 15,
              ),              
              ExpansionTile(title: Text("Bank Details"),
                  //trailing: Icon(FontAwesomeIcons.signInAlt),
                  children: <Widget>[
                    TextField(
                      style: TextStyle(color: Color(0xFF000000)),
                      cursorColor: Color(0xFF9b9b9b),
                      controller: accountNameController,
                      keyboardType: TextInputType.text,
                      obscureText: false,
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.vpn_key,
                          color: Colors.grey,
                        ),
                        hintText: "Account Name",
                        hintStyle: TextStyle(
                            color: Color(0xFF9b9b9b),
                            fontSize: 15,
                            fontWeight: FontWeight.normal),
                      ),
                    ),
                    TextField(
                      style: TextStyle(color: Color(0xFF000000)),
                      cursorColor: Color(0xFF9b9b9b),
                      controller: accountNumberController,
                      keyboardType: TextInputType.text,
                      obscureText: true,
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.vpn_key,
                          color: Colors.grey,
                        ),
                        hintText: "Account Number",
                        hintStyle: TextStyle(
                            color: Color(0xFF9b9b9b),
                            fontSize: 15,
                            fontWeight: FontWeight.normal),
                      ),
                    ),
                    TextField(
                      style: TextStyle(color: Color(0xFF000000)),
                      cursorColor: Color(0xFF9b9b9b),
                      controller: branchController,
                      keyboardType: TextInputType.text,
                      obscureText: true,
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.vpn_key,
                          color: Colors.grey,
                        ),
                        hintText: "Branch Number",
                        hintStyle: TextStyle(
                            color: Color(0xFF9b9b9b),
                            fontSize: 15,
                            fontWeight: FontWeight.normal),
                      ),
                    ),
                    TextField(
                      style: TextStyle(color: Color(0xFF000000)),
                      cursorColor: Color(0xFF9b9b9b),
                      controller: nameController,
                      keyboardType: TextInputType.text,
                      obscureText: true,
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.vpn_key,
                          color: Colors.grey,
                        ),
                        hintText: "Bank Name",
                        hintStyle: TextStyle(
                            color: Color(0xFF9b9b9b),
                            fontSize: 15,
                            fontWeight: FontWeight.normal),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        
                        RaisedButton(
                          onPressed: _isLoading ? null : _handleBankUpdate,
                          color: Colors.green,
                          padding: EdgeInsets.symmetric(horizontal: 50),
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          child: Text(
                            _isLoading ? 'Updating...' : 'SAVE',
                            style: TextStyle(
                                fontSize: 14,
                                letterSpacing: 2.2,
                                color: Colors.white),
                          ),
                        )
                      ],
                    ),
                  ]),
            ],
          ),
        ),
      ),
    );
  }


  void _handlePasswordUpdate() async {
    setState(() {
      _isLoading = true;
    });

    var data = {
      'userName': oldPasswordController.text,
      'password': passwordController.text,
    };

    

    var response = await CallApi().putData(data,'authenticate/createPass');

    var passwordData = json.decode(response.body);
    if (response.statusCode == 200) {
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      localStorage.setString('passwordData', json.encode(passwordData));
      log("Sucessful: " + response.statusCode.toString());
      
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

    void _handleBankUpdate() async {
    setState(() {
      _isLoading = true;
    });

    var data = {
      "accountName": accountNameController.text,
      "accountNumber": accountNumberController.text,
      "branch": branchController.text,
      "name": nameController.text
    };

    var response = await CallApi().putData(data,'bank/add');

    var bankData = json.decode(response.body);
    if (response.statusCode == 200) {
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      localStorage.setString('bankData', json.encode(bankData));
      log("Sucessful: " + response.statusCode.toString());
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

  void _handleWorkUpdate() async {
    setState(() {
      _isLoading = true;
    });

    var data = {
      'basicSalary': basicSalaryController.text,
      'companyName': companyNameController.text,
      'employeeId': employeeIdController.text,
      'job': jobController.text,
      'workStation': workStationController.text,
     };

    var response = await CallApi().putData(data,'profile/work/update');
    print("posted: " + jsonEncode(data));
    print("Reached Here");

    var workData = json.decode(response.body);
    if (response.statusCode == 200) {
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      localStorage.setString('WorkData', json.encode(workData));
      log("Sucessful: " + response.statusCode.toString());
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
