import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nss_blood_finder/screens/profileScreen.dart';
import 'package:nss_blood_finder/widgets/main_drawer.dart';

class EditProfileScreen extends StatefulWidget {
  static const routeName = '/edit-profile-prompt';
  @override
  _EditScreenState createState() => _EditScreenState();
}

class _EditScreenState extends State<EditProfileScreen> {
  TextEditingController rollno = TextEditingController();

  showErrorMessage(String msg) {
    Fluttertoast.showToast(msg: msg);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MainDrawer(),
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Edit',
          style: Theme.of(context).textTheme.headline6,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 50),
            Image(
              image: AssetImage("assets/images/icon.jpg"),
              width: 290.0,
              height: 200.0,
              alignment: Alignment.center,
            ),
            SizedBox(
              height: 20.0,
            ),
            TextField(
                controller: rollno,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                    labelText: "Roll no.",
                    labelStyle: TextStyle(
                        fontSize: 14.0, fontFamily: 'RobotoCondensed'),
                    hintStyle: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                        fontSize: 10.0)),
                style: TextStyle(fontSize: 14.0)),
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
                    "Load Data",
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ),
              ),
              onPressed: () async {
                if (rollno.text.isEmpty) {
                  showErrorMessage("Roll no. is mandatory");
                } else {
                    Navigator.pushNamed(
                        context, ProfileScreen.routeName, arguments: rollno.text.toUpperCase());
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
