import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nss_blood_finder/screens/loginScreen.dart';
import 'package:nss_blood_finder/services/auth.dart';
import 'package:nss_blood_finder/widgets/main_drawer.dart';

class ForgotPasswordScreen extends StatefulWidget {
  static const routeName = '/forgot-password';
  const ForgotPasswordScreen({Key key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  TextEditingController _emailController = new TextEditingController();
  bool _isLoading = false;
  bool _isDone = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Password Reset"),
      ),
      drawer: MainDrawer(),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: EdgeInsets.all(25),
              child: _isDone
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                          Text(
                            "Link to reset password sent to your email.",
                            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 10,),
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
                                  "Go to Login Page",
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline6
                                      .copyWith(fontSize: 24),
                                ),
                              ),
                            ),
                            onPressed: () {
                              Navigator.of(context)
                                  .pushNamed(LoginScreen.routeName);
                            },
                          ),
                        ])
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        TextField(
                          controller: _emailController,
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
                          height: 10,
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
                                "Reset Password",
                                style: Theme.of(context)
                                    .textTheme
                                    .headline6
                                    .copyWith(fontSize: 24),
                              ),
                            ),
                          ),
                          onPressed: () async {
                            if (_emailController.text.isNotEmpty &&
                                _emailController.text.contains("@")) {
                              setState(() {
                                _isLoading = true;
                              });
                              var res = await AuthProvider()
                                  .resetPassword(_emailController.text);
                              setState(() {
                                _isLoading = false;
                                if(res)
                                  _isDone = true;
                              });
                            } else {
                              Fluttertoast.showToast(msg: "Enter Valid Email");
                            }
                          },
                        ),
                      ],
                    ),
            ),
    );
  }
}
