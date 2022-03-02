import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:nss_blood_finder/screens/formImgScreen.dart';
import 'package:nss_blood_finder/services/blood.dart';
import 'package:nss_blood_finder/widgets/main_drawer.dart';
import 'package:provider/provider.dart';

class UpdateReqScreen extends StatefulWidget {
  static const routeName = '/update-request';
  @override
  _EditScreenState createState() => _EditScreenState();
}

class _EditScreenState extends State<UpdateReqScreen> {
  bool isInit = true;
  bool isArranged = false;
  bool isLoading = false;
  var requestData;
  String bloodgroup;
  String id;
  List bloodGroups = [];
  ImagePicker imagePicker;
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
  TextEditingController accompanyNameTextEditingController =
      new TextEditingController();
  TextEditingController accompanyRollnoTextEditingController =
      new TextEditingController();

  List<Map<String, dynamic>> donors = [];
  List departments = [];

  void initState() {
    super.initState();
    imagePicker = ImagePicker();
  }

  @override
  void didChangeDependencies() async {
    if (isInit) {
      setState(() {
        id = ModalRoute.of(context).settings.arguments as String;
      });
      final bloodservice = Provider.of<BloodService>(context, listen: false);
      bloodGroups = await bloodservice.getBloodGroups();
      requestData = await bloodservice.getRequestData(id);
      departments = await bloodservice.getDepartments();
      log(requestData.toString());
      if (requestData != null) {
        setState(() {
          bloodgroup = requestData['bloodGroup'];
          hospitalNameTextEditingController.text = requestData['hospitalName'];
          inchargeNameTextEditingController.text = requestData['inchargeName'];
          inchargeRollnoTextEditingController.text =
              requestData['inchargeRollno'];
          isArranged = requestData['isArranged'];
          accompanyNameTextEditingController.text =
              requestData['accompanyName'];
          accompanyRollnoTextEditingController.text =
              requestData['accompanyRollno'];
          patientNameTextEditingController.text = requestData['patientName'];
          patientPhoneTextEditingController.text = requestData['patientPhone'];
          reasonTextEditingController.text = requestData['reason'];
          unitsTextEditingController.text = requestData['units'];
          for (int i = 0; i < int.parse(unitsTextEditingController.text); i++) {
            donors.add({
              'name': new TextEditingController(
                  text: requestData['donors'][i]['name'].toString()),
              'rollno': new TextEditingController(
                  text: requestData['donors'][i]['rollno'].toString()),
              'formImg': requestData['donors'][i]['formImg'],
              'dept': requestData['donors'][i]['dept']
            });
          }
        });
      }
      setState(() {
        isInit = false;
      });
    }
    super.didChangeDependencies();
  }

  showErrorMessage(String msg) {
    Fluttertoast.showToast(msg: msg);
  }

  void _handleImagePicker(int index) async {
    setState(() {
      isLoading = true;
    });
    // log(_refImgs.length.toString());
    XFile image = await imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 100,
        preferredCameraDevice: CameraDevice.front);
    var url = await BloodService.uploadFileToFirestore(image.path);
    setState(() {
      donors[index]['formImg'] = url;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MainDrawer(),
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Update Request',
          style: Theme.of(context).textTheme.headline6,
        ),
      ),
      body: isInit || isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
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
                    TextField(
                      controller: unitsTextEditingController,
                      keyboardType: TextInputType.number,
                      enabled: false,
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
                    Row(
                      children: [
                        Text(
                          "Is Arranged?",
                          style: Theme.of(context).textTheme.headline1.copyWith(
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                              color: Colors.black),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Switch(
                            value: isArranged,
                            focusColor: Theme.of(context).primaryColor,
                            onChanged: (value) {
                              setState(() {
                                isArranged = value;
                              });
                            }),
                      ],
                    ),
                    if (isArranged)
                      Column(
                        children: [
                          TextField(
                            controller: accompanyNameTextEditingController,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                                labelText: "Accompanying Volunteer Name",
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
                          TextField(
                            controller: accompanyRollnoTextEditingController,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                                labelText: "Accompanying Volunteer Rollno.",
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
                          if (isArranged)
                            ...donors
                                .map((e) => Column(
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: TextField(
                                                controller: e['name'],
                                                keyboardType:
                                                    TextInputType.text,
                                                decoration: InputDecoration(
                                                    labelText: "Donor Name",
                                                    labelStyle: TextStyle(
                                                        fontSize: 14.0,
                                                        fontFamily:
                                                            'RobotoCondensed'),
                                                    hintStyle: TextStyle(
                                                        color: Colors.grey,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 10.0)),
                                                style:
                                                    TextStyle(fontSize: 14.0),
                                              ),
                                            ),
                                            Expanded(
                                              child: TextField(
                                                controller: e['rollno'],
                                                keyboardType:
                                                    TextInputType.text,
                                                decoration: InputDecoration(
                                                    labelText: "Donor rollno",
                                                    labelStyle: TextStyle(
                                                        fontSize: 14.0,
                                                        fontFamily:
                                                            'RobotoCondensed'),
                                                    hintStyle: TextStyle(
                                                        color: Colors.grey,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 10.0)),
                                                style:
                                                    TextStyle(fontSize: 14.0),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  "Department : ",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .headline1
                                                      .copyWith(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          color: Colors.black),
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                DropdownButton<String>(
                                                  value: e['dept'] != ""
                                                      ? e['dept']
                                                      : null,
                                                  items: departments
                                                      .map((dynamic v) {
                                                    return new DropdownMenuItem<
                                                        String>(
                                                      value: v,
                                                      child: Text(v),
                                                    );
                                                  }).toList(),
                                                  onChanged: (newValue) {
                                                    setState(() {
                                                      setState(() {
                                                        e['dept'] = newValue;
                                                      });
                                                    });
                                                  },
                                                ),
                                              ],
                                            ),
                                            if (e['formImg'] != "")
                                              GestureDetector(
                                                onTap: () {
                                                  // log("works")
                                                  final df = new DateFormat(
                                                      'dd-MM-yyyy');
                                                  String fileName = df.format(
                                                          new DateTime
                                                                  .fromMillisecondsSinceEpoch(
                                                              requestData['createdAt']
                                                                      .seconds *
                                                                  1000)) +
                                                      "-" +
                                                      (e['name'].text as String).replaceAll(" ", "_");
                                                  Navigator.of(context)
                                                      .pushNamed(
                                                          FormImageScreen
                                                              .routeName,
                                                          arguments: {
                                                        'url': e['formImg'],
                                                        'fileName': fileName
                                                      });
                                                },
                                                child: Hero(
                                                  tag: "formImage",
                                                  child: Container(
                                                    height: 80,
                                                    width: 80,
                                                    margin:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 8),
                                                    decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                            const BorderRadius
                                                                    .all(
                                                                Radius.circular(
                                                                    6)),
                                                        image: DecorationImage(
                                                            image: NetworkImage(
                                                                e['formImg']),
                                                            fit: BoxFit.cover),
                                                        border: Border.all(
                                                            color:
                                                                Colors.grey)),
                                                  ),
                                                ),
                                              ),
                                            if (e['formImg'] == "")
                                              GestureDetector(
                                                onTap: () => _handleImagePicker(
                                                    donors.indexOf(e)),
                                                child: Container(
                                                  height: 80,
                                                  width: 80,
                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          const BorderRadius
                                                                  .all(
                                                              Radius.circular(
                                                                  6)),
                                                      border: Border.all(
                                                          color: Colors.grey)),
                                                  child: const Center(
                                                    child: Icon(
                                                      Icons.add,
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                          ],
                                        )
                                      ],
                                    ))
                                .toList(),
                        ],
                      ),
                    SizedBox(
                      height: 20.0,
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
                            "Update Request",
                            style: Theme.of(context).textTheme.headline6,
                          ),
                        ),
                      ),
                      onPressed: () async {
                        setState(() {
                          isLoading = true;
                        });
                        List<Map<String, String>> donorsData = [];
                        for (var i in donors) {
                          donorsData.add({
                            'name': i['name'].text,
                            'rollno': i['rollno'].text,
                            'formImg': i['formImg'],
                            'dept': i['dept'],
                          });
                        }
                        await Provider.of<BloodService>(context, listen: false)
                            .updateRequest(
                          id,
                          patientNameTextEditingController.text,
                          bloodgroup,
                          hospitalNameTextEditingController.text,
                          unitsTextEditingController.text,
                          reasonTextEditingController.text,
                          inchargeNameTextEditingController.text,
                          inchargeRollnoTextEditingController.text,
                          patientPhoneTextEditingController.text,
                          isArranged,
                          donorsData,
                          accompanyNameTextEditingController.text,
                          accompanyRollnoTextEditingController.text,
                        )
                            .then((_) {
                          setState(() {
                            isLoading = false;
                          });
                          Fluttertoast.showToast(msg: "Updated Successfully");
                          Navigator.of(context)
                              .pushNamedAndRemoveUntil('/', (route) => false);
                        });
                      },
                    ),
                    SizedBox(
                      height: 20,
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
