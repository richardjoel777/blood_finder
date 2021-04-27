import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:nss_blood_finder/services/blood.dart';
import 'package:provider/provider.dart';

class EditScreen extends StatefulWidget {
  static const routeName = '/edit';
  @override
  _EditScreenState createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  TextEditingController rollno = TextEditingController();
  DateTime _selectedDate;

  showErrorMessage(String msg) {
    Fluttertoast.showToast(msg: msg);
  }

  void _presentDOBDatePicker() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(1930),
            lastDate: DateTime.now())
        .then((pickedDate) {
      if (pickedDate == null) return;
      setState(() {
        _selectedDate = pickedDate;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              height: 1.0,
            ),
            Row(
              children: [
                Text(
                  _selectedDate == null
                      ? "Donated Date : "
                      : 'Picked Date: ${DateFormat.yMd().format(_selectedDate)}',
                  style: Theme.of(context).textTheme.headline1.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      color: Colors.black),
                ),
                TextButton(
                  style: TextButton.styleFrom(
                      primary: Theme.of(context).primaryColor),
                  onPressed: _presentDOBDatePicker,
                  child: Text(
                    "Choose Date",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
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
                    "Update Data",
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ),
              ),
              onPressed: () async {
                if (rollno.text.isEmpty) {
                  showErrorMessage("Roll no. is mandatory");
                } else if (_selectedDate == null) {
                  showErrorMessage("Donated date is mandatory");
                } else {
                  await Provider.of<BloodService>(context, listen: false)
                      .updateDonateInfo(rollno.text, _selectedDate)
                      .then((_) {
                    Navigator.pushNamedAndRemoveUntil(
                        context, '/', (route) => false);
                  });
                }
              },
            ),
            // SizedBox(height: 25,),
            // ElevatedButton(
            //   style: ElevatedButton.styleFrom(
            //     primary: Theme.of(context).primaryColor,
            //     onPrimary: Colors.white,
            //     shape: RoundedRectangleBorder(
            //       borderRadius: new BorderRadius.circular(24.0),
            //     ),
            //   ),
            //   child: Container(
            //     height: 50.0,
            //     child: Center(
            //       child: Text(
            //         "Update Dummy Date ",
            //         style: Theme.of(context).textTheme.headline6,
            //       ),
            //     ),
            //   ),
            //   onPressed: () async {
            //     await Provider.of<BloodService>(context, listen: false)
            //         .updateDummyDate()
            //         .then((_) => print("FINISHED"));
            //   },
            // )
          ],
        ),
      ),
    );
  }
}
