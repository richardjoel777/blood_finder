import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nss_blood_finder/services/blood.dart';
import 'package:nss_blood_finder/widgets/main_drawer.dart';
import 'package:provider/provider.dart';

class CreateReqScreen extends StatefulWidget {
  static const routeName = '/create-request';
  @override
  _EditScreenState createState() => _EditScreenState();
}

class _EditScreenState extends State<CreateReqScreen> {
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
          'Create Request',
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
              height: 30.0,
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
                    "Add Request",
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ),
              ),
              onPressed: () async {
                String id = (Random().nextInt(90000) + 10000).toString();
                await Provider.of<BloodService>(context, listen: false)
                    .createRequest(id)
                    .then((_) {
                  Clipboard.setData(ClipboardData(text: id));
                  Fluttertoast.showToast(msg: "Request Id copied to Clipboard");
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil('/', (route) => false);
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
