import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nss_blood_finder/screens/donateScreen.dart';
import 'package:nss_blood_finder/services/blood.dart';

class RequestsScreen extends StatefulWidget {
  @override
  _RequestsScreenState createState() => _RequestsScreenState();
}

class _RequestsScreenState extends State<RequestsScreen> {
  TextEditingController areaTextEditingController = new TextEditingController();
  String bloodgroup;
  BloodService bloodService = BloodService();

  showErrorMessage(String msg) {
    Fluttertoast.showToast(msg: msg);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Blood Finder', style: Theme.of(context).textTheme.headline6,),),
      body: SingleChildScrollView(
              child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Center(
            child: Column(
              children: [
                SizedBox(
                  height: 35.0,
                ),
                Image(
                  image: AssetImage("assets/images/logo.png"),
                  width: 290.0,
                  height: 200.0,
                  alignment: Alignment.center,
                ),
                SizedBox(
                  height: 20.0,
                ),
                Text(
                  "Request Blood",
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
                      Row(
                        children: [
                          Text(
                            "Blood Group : ",
                            style: Theme.of(context).textTheme.headline1.copyWith(
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                                color: Colors.black),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          DropdownButton<String>(
                            value: bloodgroup != null ? bloodgroup : null,
                            items: <String>[
                              'A+',
                              'B+',
                              'AB+',
                              'O+',
                              'A-',
                              'B-',
                              'AB-',
                              'O-'
                            ].map((String v) {
                              return new DropdownMenuItem<String>(
                                value: v,
                                child: Text(v),
                              );
                            }).toList(),
                            onChanged: (newValue) {
                              setState(() {
                                bloodgroup = newValue;
                              });
                            },
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 1.0,
                      ),
                      TextField(
                        controller: areaTextEditingController,
                        decoration: InputDecoration(
                            labelText: "Area",
                            labelStyle: TextStyle(
                                fontSize: 14.0, fontFamily: 'RobotoCondensed'),
                            hintStyle:
                                TextStyle(color: Colors.grey, fontSize: 10.0)),
                        style: TextStyle(fontSize: 14.0),
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
                              "Request Blood",
                              style: Theme.of(context).textTheme.headline6,
                            ),
                          ),
                        ),
                        onPressed: () async {
                          if (bloodgroup == null) {
                            showErrorMessage("Blood Group is mandatory");
                          } else if (areaTextEditingController.text.isEmpty) {
                            showErrorMessage("Area is mandatory");
                          } else {
                            List bloodData =
                                await bloodService.getBloodData(bloodgroup);
                            Navigator.pushNamed(context, DonateScreen.routeName,
                                arguments: [bloodData, areaTextEditingController.text, bloodgroup]);
                            // await .uploadRequest(
                            //     nameTextEditingController.text,
                            //     bloodgroup,
                            //     _selectedRequiredDate,
                            //     _selectedDOB,
                            //     pinCodeTextEditingController.text,
                            //     int.parse(ageTextEditingController.text),
                            //     int.parse(unitsTextEditingController.text),
                            //     areaTextEditingController.text,
                            //     isCritical);
                            // Fluttertoast.showToast(
                            //     msg: "Your Request is successfully placed");
                            //     Navigator.pushNamedAndRemoveUntil(
                            //   context, '/', (route) => false);
                          }
                        },
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
