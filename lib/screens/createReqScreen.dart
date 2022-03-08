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
  bool isInit = true;
  bool isLoading = false;
  String bloodgroup;
  String area;
  List bloodGroups = [];
  List districts = [];
  TextEditingController patientNameTextEditingController =
      new TextEditingController();
  TextEditingController hospitalNameTextEditingController =
      new TextEditingController();
  TextEditingController unitsTextEditingController =
      new TextEditingController();
  TextEditingController reasonTextEditingController =
      new TextEditingController();
  TextEditingController inchargeNameTextEditingController =
      new TextEditingController();
  TextEditingController inchargeRollnoTextEditingController =
      new TextEditingController();
  TextEditingController patientPhoneTextEditingController =
      new TextEditingController();

  @override
  void didChangeDependencies() async {
    if (isInit) {
      setState(() {
        isLoading = true;
      });
      final bloodservice = Provider.of<BloodService>(context, listen: false);
      bloodGroups = await bloodservice.getBloodGroups();
      districts = await bloodservice.getDistricts();
      setState(() {
        isInit = false;
        isLoading = false;
      });
    }
    super.didChangeDependencies();
  }

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
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 20),
                    Image(
                      image: AssetImage("assets/images/icon.jpg"),
                      width: 290.0,
                      height: 200.0,
                      alignment: Alignment.center,
                    ),
                    SizedBox(
                      height: 30.0,
                    ),
                    TextField(
                      controller: patientNameTextEditingController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          labelText: "Patient Name",
                          labelStyle: TextStyle(
                              fontSize: 14.0, fontFamily: 'RobotoCondensed'),
                          hintStyle: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                              fontSize: 10.0)),
                      style: TextStyle(fontSize: 14.0),
                    ),
                    SizedBox(
                      height: 5.0,
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
                    TextField(
                      controller: hospitalNameTextEditingController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          labelText: "Hospital Name",
                          labelStyle: TextStyle(
                              fontSize: 14.0, fontFamily: 'RobotoCondensed'),
                          hintStyle: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                              fontSize: 10.0)),
                      style: TextStyle(fontSize: 14.0),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Row(
                      children: [
                        Text(
                          "Area : ",
                          style: Theme.of(context).textTheme.headline1.copyWith(
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
                    TextField(
                      controller: unitsTextEditingController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          labelText: "Units",
                          labelStyle: TextStyle(
                              fontSize: 14.0, fontFamily: 'RobotoCondensed'),
                          hintStyle: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                              fontSize: 10.0)),
                      style: TextStyle(fontSize: 14.0),
                    ),
                    SizedBox(
                      height: 1.0,
                    ),
                    TextField(
                      controller: reasonTextEditingController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          labelText: "Reason for hospitalization",
                          labelStyle: TextStyle(
                              fontSize: 14.0, fontFamily: 'RobotoCondensed'),
                          hintStyle: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                              fontSize: 10.0)),
                      style: TextStyle(fontSize: 14.0),
                    ),
                    SizedBox(
                      height: 1.0,
                    ),
                    TextField(
                      controller: inchargeNameTextEditingController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          labelText: "Volunteer-incharge Name",
                          labelStyle: TextStyle(
                              fontSize: 14.0, fontFamily: 'RobotoCondensed'),
                          hintStyle: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                              fontSize: 10.0)),
                      style: TextStyle(fontSize: 14.0),
                    ),
                    SizedBox(
                      height: 1.0,
                    ),
                    TextField(
                      controller: inchargeRollnoTextEditingController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          labelText: "Volunteer-incharge Rollno.",
                          labelStyle: TextStyle(
                              fontSize: 14.0, fontFamily: 'RobotoCondensed'),
                          hintStyle: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                              fontSize: 10.0)),
                      style: TextStyle(fontSize: 14.0),
                    ),
                    SizedBox(
                      height: 1.0,
                    ),
                    TextField(
                      controller: patientPhoneTextEditingController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          labelText: "Patient Mobile Number",
                          labelStyle: TextStyle(
                              fontSize: 14.0, fontFamily: 'RobotoCondensed'),
                          hintStyle: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                              fontSize: 10.0)),
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
                            "Add Request",
                            style: Theme.of(context).textTheme.headline6,
                          ),
                        ),
                      ),
                      onPressed: () async {
                        if (patientNameTextEditingController.text.isEmpty) {
                          Fluttertoast.showToast(
                              msg: "Patient Name is Mandatory");
                        } else if (bloodgroup == null) {
                          Fluttertoast.showToast(
                              msg: "Patient BloodGroup is Mandatory");
                        } else if (hospitalNameTextEditingController
                            .text.isEmpty) {
                          Fluttertoast.showToast(
                              msg: "Hospital Name is Mandatory");
                        } else if (area == null) {
                          Fluttertoast.showToast(
                              msg: "Hospital Area is Mandatory");
                        } else if (unitsTextEditingController.text.isEmpty) {
                          Fluttertoast.showToast(msg: "Units is Mandatory");
                        } else if (reasonTextEditingController.text.isEmpty) {
                          Fluttertoast.showToast(
                              msg: "Hospitalization Reason is Mandatory");
                        } else if (inchargeNameTextEditingController
                            .text.isEmpty) {
                          Fluttertoast.showToast(
                              msg: "Volunteer Incharge Name is Mandatory");
                        } else if (inchargeRollnoTextEditingController
                            .text.isEmpty) {
                          Fluttertoast.showToast(
                              msg: "Volunteer Incharge Roll no. is Mandatory");
                        } else if (patientPhoneTextEditingController
                            .text.isEmpty) {
                          Fluttertoast.showToast(
                              msg: "Patient Phone Number is Mandatory");
                        }
                        else if (patientPhoneTextEditingController
                            .text.length != 10) {
                          Fluttertoast.showToast(
                              msg: "Enter Valid Phone Number");
                        }
                         else {
                          setState(() {
                            isLoading = true;
                          });
                          var id = await Provider.of<BloodService>(context,
                                  listen: false)
                              .createRequest(
                                  patientNameTextEditingController.text,
                                  bloodgroup,
                                  hospitalNameTextEditingController.text,
                                  area,
                                  unitsTextEditingController.text,
                                  reasonTextEditingController.text,
                                  inchargeNameTextEditingController.text,
                                  inchargeRollnoTextEditingController.text,
                                  patientPhoneTextEditingController.text);
                          setState(() {
                            isLoading = false;
                          });
                          if (id != "") {
                            Clipboard.setData(ClipboardData(text: id));
                            Fluttertoast.showToast(
                                msg: "Request Id copied to Clipboard");
                            Navigator.of(context)
                                .pushNamedAndRemoveUntil('/', (route) => false);
                          }
                        }
                      },
                    ),
                    SizedBox(height: 20.0),
                  ],
                ),
              ),
            ),
    );
  }
}
