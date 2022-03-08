import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nss_blood_finder/screens/donorDataScreen.dart';
import 'package:nss_blood_finder/services/blood.dart';
import 'package:nss_blood_finder/widgets/main_drawer.dart';
import 'package:provider/provider.dart';

class RequestsScreen extends StatefulWidget {
  @override
  _RequestsScreenState createState() => _RequestsScreenState();
}

class _RequestsScreenState extends State<RequestsScreen> {
  String bloodgroup;
  TextEditingController reqId = new TextEditingController();
  bool isInit = true;
  bool _isLoading = false;
  List bloodGroups = [];
  List requests = [];
  BloodService bloodService = BloodService();

  showErrorMessage(String msg) {
    Fluttertoast.showToast(msg: msg);
  }

  Future<void> didChangeDependencies() async {
    if (isInit) {
      setState(() {
        _isLoading = true;
      });
      List groups = await bloodService.getBloodGroups();
      if (Provider.of<BloodService>(context, listen: false).admins.isEmpty) {
        await Provider.of<BloodService>(context, listen: false).getAdmins();
      }
      setState(() {
        bloodGroups = groups;
        isInit = false;
        _isLoading = false;
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
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
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
                                      .copyWith(
                                          fontSize: 14, color: Colors.black),
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
                                  hintStyle: TextStyle(
                                      color: Colors.grey, fontSize: 10.0)),
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
                                    style:
                                        Theme.of(context).textTheme.headline6,
                                  ),
                                ),
                              ),
                              onPressed: () async {
                                if (bloodgroup == null || reqId.text.isEmpty) {
                                  showErrorMessage("All fields are mandatory");
                                } else {
                                  setState(() {
                                    _isLoading = true;
                                  });
                                  var found = await bloodService
                                      .validateRequest(reqId.text);
                                  setState(() {
                                    _isLoading = false;
                                  });
                                  if (found == true) {
                                    Navigator.of(context).pushNamed(
                                        DonateScreen.routeName,
                                        arguments: bloodgroup);
                                  } else {
                                    showErrorMessage("Invalid Request Id or Request ID exprired");
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
