import 'package:fluttertoast/fluttertoast.dart';
import 'package:nss_blood_finder/services/auth.dart';
import 'package:provider/provider.dart';

import 'package:flutter/material.dart';

import '../widgets/main_drawer.dart';

class AddAccountScreen extends StatefulWidget {
  static const String routeName = '/add-account';

  @override
  _AddAccountScreenState createState() => _AddAccountScreenState();
}

class _AddAccountScreenState extends State<AddAccountScreen> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    TextEditingController email = TextEditingController();
    TextEditingController password = TextEditingController();
    final _auth = Provider.of<AuthProvider>(context);
    return Scaffold(
        drawer: MainDrawer(),
        appBar: AppBar(
          title: Text(
            "Create Account",
            style: Theme.of(context).textTheme.headline6,
          ),
        ),
        backgroundColor: Colors.white,
        body: isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
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
                        "Create Account",
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
                                    "Create Account",
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline6
                                        .copyWith(fontSize: 24),
                                  ),
                                ),
                              ),
                              onPressed: () async {
                                print(_auth.passcode);
                                if (email.text.contains("@") &&
                                    password.text.length >= 8) {
                                  setState(() {
                                    isLoading = true;
                                  });
                                  dynamic result = await _auth.signupEmail(
                                      email.text, password.text);
                                  setState(() {
                                      isLoading = false;
                                    });
                                  if (result != null){
                                    Fluttertoast.showToast(
                                        msg: "Registered successfully");
                                    Navigator.of(context)
                                        .pushNamedAndRemoveUntil(
                                            '/', (route) => false);
                                  }
                                } else {
                                  Fluttertoast.showToast(
                                      msg: "Invalid Email or Password");
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ));
  }
}
