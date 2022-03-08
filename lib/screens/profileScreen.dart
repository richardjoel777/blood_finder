import '../services/blood.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ProfileScreen extends StatefulWidget {
  static const routeName = '/edit-profile';
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isInit = true;
  bool isLoading = false;
  TextEditingController nameTextEditingController = new TextEditingController();
  TextEditingController rollnoTextEditingController =
      new TextEditingController();
  TextEditingController phone1TextEditingController =
      new TextEditingController();
  TextEditingController phone2TextEditingController =
      new TextEditingController();
  String bloodgroup;
  String area;
  String dept;
  String year;
  String sec;
  bool isDayScholar = false;
  bool isWilling = false;
  List bloodGroups = [];
  List districts = [];
  List years = ["1", "2", "3", "4", "FACULTY", "PASSED OUT"];
  List sections = ["A", "B", "C", "D", "E", "F"];
  List departments = [];
  @override
  void didChangeDependencies() async {
    if (isInit) {
      setState(() {
        isLoading = true;
      });
      var rollNo = ModalRoute.of(context).settings.arguments as String;
      final bloodservice = Provider.of<BloodService>(context, listen: false);
      departments = await bloodservice.getDepartments();
      bloodGroups = await bloodservice.getBloodGroups();
      districts = await bloodservice.getDistricts();
      final userData = await bloodservice.getUserData(rollNo.toUpperCase());
      if (userData != null) {
        nameTextEditingController.text = userData['name'];
        rollnoTextEditingController.text = userData['rollno'];
        phone1TextEditingController.text = userData['phone1'];
        phone2TextEditingController.text = userData['phone2'];
        area = userData['area'];
        bloodgroup = userData['bloodGroup'];
        dept = userData['dept'];
        year = userData['year'];
        isWilling = userData['isWilling'];
        isDayScholar = userData['isDayScholar'];
        sec = userData['sec'];
        setState(() {
          isInit = false;
          isLoading = false;
        });
      } else {
        Navigator.of(context).pop();
      }
    }
    super.didChangeDependencies();
  }

  showErrorMessage(String msg) {
    Fluttertoast.showToast(msg: msg);
  }

  @override
  Widget build(BuildContext context) {
    final bloodService = Provider.of<BloodService>(context, listen: false);
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            "Profile",
            style: Theme.of(context).textTheme.headline6,
          ),
        ),
        body: isLoading
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 25.0,
                      ),
                      Image(
                        image: AssetImage("assets/images/icon.png"),
                        width: 290.0,
                        height: 200.0,
                        alignment: Alignment.center,
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Text(
                        "Update Profile",
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
                              controller: nameTextEditingController,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                  labelText: "Name",
                                  labelStyle: TextStyle(
                                      fontSize: 14.0,
                                      fontFamily: 'RobotoCondensed'),
                                  hintStyle: TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 10.0)),
                              style: TextStyle(fontSize: 14.0),
                            ),
                            SizedBox(
                              height: 1.0,
                            ),
                            Row(
                              children: [
                                Text(
                                  "Blood Group : ",
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline1
                                      .copyWith(
                                          fontSize: 14,
                                          fontWeight: FontWeight.normal,
                                          color: Colors.black),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                DropdownButton<String>(
                                  value: bloodgroup != null ? bloodgroup : null,
                                  items: bloodGroups.map((dynamic v) {
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
                            Row(
                              children: [
                                Text(
                                  "Department : ",
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline1
                                      .copyWith(
                                          fontSize: 14,
                                          fontWeight: FontWeight.normal,
                                          color: Colors.black),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                DropdownButton<String>(
                                  value: dept != null ? dept : null,
                                  items: departments.map((dynamic v) {
                                    return new DropdownMenuItem<String>(
                                      value: v,
                                      child: Text(v),
                                    );
                                  }).toList(),
                                  onChanged: (newValue) {
                                    setState(() {
                                      dept = newValue;
                                    });
                                  },
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 1.0,
                            ),
                            Row(
                              children: [
                                Text(
                                  "Year : ",
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline1
                                      .copyWith(
                                          fontSize: 14,
                                          fontWeight: FontWeight.normal,
                                          color: Colors.black),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                DropdownButton<String>(
                                  value: year != null ? year : null,
                                  items: years.map((dynamic v) {
                                    return new DropdownMenuItem<String>(
                                      value: v,
                                      child: Text(v),
                                    );
                                  }).toList(),
                                  onChanged: (newValue) {
                                    setState(() {
                                      year = newValue;
                                    });
                                  },
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 1.0,
                            ),
                            Row(
                              children: [
                                Text(
                                  "Section : ",
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline1
                                      .copyWith(
                                          fontSize: 14,
                                          fontWeight: FontWeight.normal,
                                          color: Colors.black),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                DropdownButton<String>(
                                  value: sec != null ? sec : null,
                                  items: sections.map((dynamic v) {
                                    return new DropdownMenuItem<String>(
                                      value: v,
                                      child: Text(v),
                                    );
                                  }).toList(),
                                  onChanged: (newValue) {
                                    setState(() {
                                      sec = newValue;
                                    });
                                  },
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 1.0,
                            ),
                            Row(
                              children: [
                                Text(
                                  "Area : ",
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline1
                                      .copyWith(
                                          fontSize: 14,
                                          fontWeight: FontWeight.normal,
                                          color: Colors.black),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                DropdownButton<String>(
                                  value: area != null ? area : null,
                                  items: districts.map((dynamic v) {
                                    return new DropdownMenuItem<String>(
                                      value: v,
                                      child: Text(v),
                                    );
                                  }).toList(),
                                  onChanged: (newValue) {
                                    setState(() {
                                      area = newValue;
                                    });
                                  },
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 1.0,
                            ),
                            TextField(
                              controller: rollnoTextEditingController,
                              decoration: InputDecoration(
                                  labelText: "Roll no.",
                                  labelStyle: TextStyle(
                                      fontSize: 14.0,
                                      fontFamily: 'RobotoCondensed'),
                                  hintStyle: TextStyle(
                                      color: Colors.grey, fontSize: 10.0)),
                              style: TextStyle(fontSize: 14.0),
                            ),
                            SizedBox(
                              height: 1.0,
                            ),
                            TextField(
                              controller: phone1TextEditingController,
                              keyboardType: TextInputType.phone,
                              decoration: InputDecoration(
                                  labelText: "Primary Phone no.",
                                  labelStyle: TextStyle(
                                      fontSize: 14.0,
                                      fontFamily: 'RobotoCondensed'),
                                  hintStyle: TextStyle(
                                      color: Colors.grey, fontSize: 10.0)),
                              style: TextStyle(fontSize: 14.0),
                            ),
                            SizedBox(
                              height: 1.0,
                            ),
                            TextField(
                              controller: phone2TextEditingController,
                              keyboardType: TextInputType.phone,
                              decoration: InputDecoration(
                                  labelText: "Secondary Phone no.",
                                  labelStyle: TextStyle(
                                      fontSize: 14.0,
                                      fontFamily: 'RobotoCondensed'),
                                  hintStyle: TextStyle(
                                      color: Colors.grey, fontSize: 10.0)),
                              style: TextStyle(fontSize: 14.0),
                            ),
                            SizedBox(
                              height: 1,
                            ),
                            Row(
                              children: [
                                Text(
                                  "Is Willing?",
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline1
                                      .copyWith(
                                          fontSize: 14,
                                          fontWeight: FontWeight.normal,
                                          color: Colors.black),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Switch(
                                    value: isWilling,
                                    focusColor: Theme.of(context).primaryColor,
                                    onChanged: (value) {
                                      setState(() {
                                        isWilling = value;
                                      });
                                    }),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  "Is Dayscholar?",
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline1
                                      .copyWith(
                                          fontSize: 14,
                                          fontWeight: FontWeight.normal,
                                          color: Colors.black),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Switch(
                                    value: isDayScholar,
                                    focusColor: Theme.of(context).primaryColor,
                                    onChanged: (value) {
                                      setState(() {
                                        isDayScholar = value;
                                      });
                                    }),
                              ],
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
                                    "Update Account",
                                    style:
                                        Theme.of(context).textTheme.headline6,
                                  ),
                                ),
                              ),
                              onPressed: () async {
                                if (year != "FACULTY" && year != "ALL PASSED") {
                                  if (nameTextEditingController.text.length <
                                      4) {
                                    showErrorMessage(
                                        "Name should be atleast 4 characters");
                                  } else if (rollnoTextEditingController
                                      .text.isEmpty) {
                                    showErrorMessage("Roll no. is mandatory");
                                  } else if (phone1TextEditingController
                                          .text.length <
                                      10) {
                                    showErrorMessage("Enter valid mobile no.");
                                  } else if (area == null) {
                                    showErrorMessage("Address is mandatory");
                                  } else if (bloodgroup == null) {
                                    showErrorMessage(
                                        "Blood Group is mandatory");
                                  } else if (dept == null) {
                                    showErrorMessage("Department is mandatory");
                                  } else if (year == null) {
                                    showErrorMessage("Year is mandatory");
                                  } else if (isWilling == null) {
                                    showErrorMessage("Is Willing is mandatory");
                                  } else if (isDayScholar == null) {
                                    showErrorMessage(
                                        "Is DayScholar is mandatory");
                                  } else {
                                    setState(() {
                                      isLoading = true;
                                    });
                                    await bloodService.updateUserData(
                                      nameTextEditingController.text,
                                      bloodgroup,
                                      dept,
                                      year,
                                      rollnoTextEditingController.text,
                                      phone1TextEditingController.text,
                                      phone2TextEditingController.text,
                                      area,
                                      isWilling,
                                      isDayScholar,
                                    );
                                    setState(() {
                                      isLoading = false;
                                    });
                                    Navigator.of(context)
                                        .pushNamedAndRemoveUntil(
                                            '/', (route) => false);
                                  }
                                } else {
                                  if (nameTextEditingController.text.length <
                                      4) {
                                    showErrorMessage(
                                        "Name should be atleast 4 characters");
                                  } else if (rollnoTextEditingController
                                      .text.isEmpty) {
                                    showErrorMessage("Roll no. is mandatory");
                                  } else if (phone1TextEditingController
                                          .text.length <
                                      10) {
                                    showErrorMessage("Enter valid mobile no.");
                                  } else if (area == null) {
                                    showErrorMessage("Address is mandatory");
                                  } else if (bloodgroup == null) {
                                    showErrorMessage(
                                        "Blood Group is mandatory");
                                  } else if (year == null) {
                                    showErrorMessage("Year is mandatory");
                                  } else if (isWilling == null) {
                                    showErrorMessage("Is Willing is mandatory");
                                  } else if (isDayScholar == null) {
                                    showErrorMessage(
                                        "Is DayScholar is mandatory");
                                  } else {
                                    setState(() {
                                      isLoading = true;
                                    });
                                    await bloodService.updateUserData(
                                      nameTextEditingController.text,
                                      bloodgroup,
                                      dept,
                                      year,
                                      rollnoTextEditingController.text,
                                      phone1TextEditingController.text,
                                      phone2TextEditingController.text,
                                      area,
                                      isWilling,
                                      isDayScholar,
                                    );
                                    setState(() {
                                      isLoading = false;
                                    });
                                    Navigator.of(context)
                                        .pushNamedAndRemoveUntil(
                                            '/', (route) => false);
                                  }
                                }
                              },
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
