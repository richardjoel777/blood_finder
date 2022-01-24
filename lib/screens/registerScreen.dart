import 'package:fluttertoast/fluttertoast.dart';
import 'package:nss_blood_finder/screens/loginScreen.dart';
import 'package:nss_blood_finder/services/auth.dart';
import 'package:provider/provider.dart';

import 'package:flutter/material.dart';

import '../widgets/main_drawer.dart';

class RegisterScreen extends StatefulWidget {
  static const String routeName = '/register';

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool isInit = true;
  @override
  void didChangeDependencies() async {
    if (isInit) {
      await Provider.of<AuthProvider>(context, listen: false).getPassCode();
      // await Provider.of<AuthProvider>(context, listen: false).getAuthUsers();
      setState(() {
        isInit = false;
      });
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController email = TextEditingController();
    TextEditingController password = TextEditingController();
    TextEditingController secretCode = TextEditingController();
    final _auth = Provider.of<AuthProvider>(context);
    return isInit
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            drawer: MainDrawer(),
            appBar: AppBar(
              title: Text(
                "Register",
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
            backgroundColor: Colors.white,
            body: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    SizedBox(
                      height: 35.0,
                    ),
                    Image(
                      image: AssetImage("assets/images/icon.jpg"),
                      width: 290.0,
                      height: 200.0,
                      alignment: Alignment.center,
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Text(
                      "Register",
                      style: Theme.of(context)
                          .textTheme
                          .headline6
                          .copyWith(color: Colors.black, fontSize: 24),
                      textAlign: TextAlign.center,
                    ),
                    Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 1.0,
                          ),
                          TextField(
                            controller: email,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                                labelText: "Email",
                                labelStyle: TextStyle(
                                  fontSize: 14.0,
                                ),
                                hintStyle: TextStyle(
                                    color: Colors.grey, fontSize: 10.0)),
                            style: TextStyle(fontSize: 14.0),
                          ),
                          SizedBox(
                            height: 1.0,
                          ),
                          TextField(
                            obscureText: true,
                            controller: password,
                            decoration: InputDecoration(
                                labelText: "Password",
                                labelStyle: TextStyle(
                                  fontSize: 14.0,
                                ),
                                hintStyle: TextStyle(
                                    color: Colors.grey, fontSize: 10.0)),
                            style: TextStyle(fontSize: 14.0),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          TextField(
                            obscureText: true,
                            controller: secretCode,
                            decoration: InputDecoration(
                                labelText: "PassCode",
                                labelStyle: TextStyle(
                                  fontSize: 14.0,
                                ),
                                hintStyle: TextStyle(
                                    color: Colors.grey, fontSize: 10.0)),
                            style: TextStyle(fontSize: 14.0),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Theme.of(context).primaryColor,
                              onPrimary: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(24.0),
                              ),
                            ),
                            child: Container(
                              height: 50.0,
                              child: Center(
                                child: Text(
                                  "Register",
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline6
                                      .copyWith(fontSize: 24),
                                ),
                              ),
                            ),
                            onPressed: () async {
                              print(_auth.passcode);
                              if (!email.text
                                  .toLowerCase()
                                  .endsWith("@kongu.edu")) {
                                Fluttertoast.showToast(
                                    msg: "Enter valid email");
                              }
                              else if(password.text.length < 8)
                              {
                                Fluttertoast.showToast(
                                    msg: "Password length should be atleast 8 characters");
                              }
                              else if(secretCode.text != _auth.passcode)
                              {
                                Fluttertoast.showToast(
                                    msg: "Enter valid Passcode");
                              }
                               else {
                                dynamic result = await _auth.signupEmail(
                                    email.text, password.text);
                                if (result == null) {
                                  Fluttertoast.showToast(
                                      msg: "Something went wrong");
                                } else {
                                  Fluttertoast.showToast(
                                      msg: "Registered successfully");
                                  Navigator.of(context).pushNamedAndRemoveUntil(
                                      '/', (route) => false);
                                }
                              }
                            },
                          ),
                          TextButton(
                            style: TextButton.styleFrom(primary: Colors.black),
                            onPressed: () {
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                  LoginScreen.routeName, (route) => false);
                            },
                            child: Text(
                              "Have an account? Login here!",
                              style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "Raleway"),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ));
  }
}
