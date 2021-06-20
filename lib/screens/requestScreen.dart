import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nss_blood_finder/screens/donateScreen.dart';
import 'package:nss_blood_finder/services/blood.dart';
import 'package:nss_blood_finder/widgets/main_drawer.dart';

class RequestsScreen extends StatefulWidget {
  @override
  _RequestsScreenState createState() => _RequestsScreenState();
}

class _RequestsScreenState extends State<RequestsScreen> {
  String bloodgroup;
  TextEditingController reqId = new TextEditingController();
  bool isInit = true;
  List bloodGroups = [];
  List requests = [];
  BloodService bloodService = BloodService();

  showErrorMessage(String msg) {
    Fluttertoast.showToast(msg: msg);
  }

  Future<void> didChangeDependencies() async {
    if (isInit) {
      List groups = await bloodService.getBloodGroups();
      List temprequests = await bloodService.getRequests();
      setState(() {
        bloodGroups = groups;
        requests = temprequests;
        isInit = false;
      });
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: MainDrawer(),
      appBar: AppBar(
        title: Text(
          'KEC Blood Finder',
          style: Theme.of(context).textTheme.headline6,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Center(
            child: Column(
              children: [
                SizedBox(
                  height: 35.0,
                ),
                // Image.network("https://photos.google.com/share/AF1QipN8nc5sZQW3L8MRSPLWgp4Dp2N2vcuzauxrbbaFDz62iNoM0yDepApnSpAOH0_UZw/photo/AF1QipP9LL_yZwyGi3ZgHIvvTNV-2OuJfIDOC-Nn1tEN?key=WWNMSDBldTVVeHRkVE5CczloMzBkUlF5elA4RHVn", height: 200, width: 290, alignment: Alignment.center,),
                Image(
                  image: AssetImage("assets/images/icon.png"),
                  width: 290.0,
                  height: 200.0,
                  alignment: Alignment.center,
                ),
                SizedBox(
                  height: 20.0,
                ),
                Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 1.0,
                      ),
                      SizedBox(
                        height: 30.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            'Blood Group : ',
                            style: Theme.of(context)
                                .textTheme
                                .headline6
                                .copyWith(fontSize: 14, color: Colors.black),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          DropdownButton<String>(
                            value: bloodgroup == null ? null : bloodgroup,
                            items: bloodGroups.map((dynamic v) {
                              return new DropdownMenuItem<String>(
                                value: v,
                                child: Text(v),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                bloodgroup = value;
                              });
                            },
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 1.0,
                      ),
                      TextField(
                        controller: reqId,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            labelText: "Request ID",
                            labelStyle: TextStyle(
                              fontSize: 14.0,
                            ),
                            hintStyle:
                                TextStyle(color: Colors.grey, fontSize: 10.0)),
                        style: TextStyle(fontSize: 14.0),
                      ),
                      SizedBox(
                        height: 30,
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
                              "Find Blood",
                              style: Theme.of(context).textTheme.headline6,
                            ),
                          ),
                        ),
                        onPressed: () async {
                          var found = false;
                          if (bloodgroup == null || reqId.text.isEmpty) {
                            showErrorMessage("All fields are mandatory");
                          } else {
                            for (int i = 0; i < requests.length; i++) {
                              print(DateTime
                                              .fromMillisecondsSinceEpoch(
                                                  requests[i]['time'].seconds *
                                                      1000).difference(DateTime.now())
                                  .inMinutes);
                              if (requests[i]['id'] == reqId.text &&(DateTime.now().difference(DateTime
                                              .fromMillisecondsSinceEpoch(
                                                  requests[i]['time'].seconds *
                                                      1000))
                                          .inMinutes <
                                      30) && (DateTime.now().difference(DateTime
                                              .fromMillisecondsSinceEpoch(
                                                  requests[i]['time'].seconds *
                                                      1000))
                                          .inMinutes >=
                                      0)) {
                                found = true;
                              }
                            }
                            if (found == true) {
                              Navigator.of(context).pushNamed(
                                  DonateScreen.routeName,
                                  arguments: bloodgroup);
                            } else {
                              showErrorMessage("Invalid Request");
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
        ),
      ),
    );
  }
}
