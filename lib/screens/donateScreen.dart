import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:nss_blood_finder/services/blood.dart';

import '../widgets/donation_request_item.dart';

class DonateScreen extends StatefulWidget {
  static const routeName = '/donate';
  @override
  _DonateScreenState createState() => _DonateScreenState();
}

class _DonateScreenState extends State<DonateScreen> {
  List filteredData = [];
  bool isLoaded = false;
  bool isLoading = false;
  List deptFilteredData = [];
  String dept;
  Geolocator geolocator = Geolocator();
  bool isAreaFilter = false;
  Future<void> getDonorData(List donorData, String hospitalArea) async {
    // print("hi");
    // print(donorData.length);
    //
    if (!isLoaded) {
      setState(() {
        filteredData = [];
      });
      var hArea = '$hospitalArea India';
      final hUrl = Uri.parse(
          'https://nominatim.openstreetmap.org/search/$hArea?format=json');
      var hospitalRes = await http.get(hUrl);
      print(hospitalRes.statusCode);
      if (hospitalRes.statusCode == 200) {
        var hospitalResData = jsonDecode(hospitalRes.body);
        // print(hospitalResData);
        donorData.forEach((u) async {
          // print(u['area']);
          var uArea = '${u['area']} India';
          var url = Uri.parse(
              'https://nominatim.openstreetmap.org/search/$uArea?format=json');
          var res = await http.get(url);
          var resData = jsonDecode(res.body);
          if (resData.length > 0) {
            // print(hospitalResData[0]["lat"]);
            // print(hospitalResData[0]["lon"]);
            // print(resData[0]["lat"]);
            // print(resData[0]["lon"]);
            var distance = (await geolocator.distanceBetween(
                    double.parse(hospitalResData[0]["lat"]),
                    double.parse(hospitalResData[0]["lon"]),
                    double.parse(resData[0]["lat"]),
                    double.parse(resData[0]["lon"])) /
                1000);
            print('${u['area']} $distance');
            if (distance <= 50) {
              setState(() {
                filteredData.add(u);
              });
              // print("added");
            }
          }
        });
      } else {
        print(hospitalRes.statusCode);
      }
    }
    setState(() {
      isLoaded = true;
      isLoading = false;
    });
  }

  // Future<void> addLatLong() async {
  //   var fb = FirebaseFirestore.instance;
  //   await fb
  //       .collection("data")
  //       .where(
  //         "bloodGroup",
  //       )
  //       .get()
  //       .then((snapshots) {
  //     snapshots.docs.forEach((doc) async {
  //       var uArea = '${doc.data()['area']} India';
  //       var url = Uri.parse(
  //           'https://nominatim.openstreetmap.org/search/$uArea?format=json');
  //       var res = await http.get(url);
  //       var resData = jsonDecode(res.body);
  //       if (resData.length > 0) {
  //         await BloodService()
  //             .latLong(doc.id, double.parse(resData[0]["lat"]), double.parse(resData[0]["long"]));
  //       } else {
  //         await BloodService()
  //             .latLong(doc.id, 0.0, 0.0);
  //       }
  //     });
  //   });
  //   print("FINISHED");
  // }

  @override
  Widget build(BuildContext context) {
    List loadedData = ModalRoute.of(context).settings.arguments as List;
    deptFilteredData = dept == null || dept == "All"
        ? loadedData[0]
        : loadedData[0].where((i) => i['dept'] == dept).toList();
    return Scaffold(
      backgroundColor: Theme.of(context).canvasColor,
      appBar: AppBar(
        title: Text(
          'Find ${loadedData[2]} Blood',
          style: Theme.of(context).textTheme.headline6,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      "Filter by Dept : ",
                      style: Theme.of(context)
                          .textTheme
                          .headline6
                          .copyWith(fontSize: 14, color: Colors.black),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    DropdownButton<String>(
                      value: dept == null ? null : dept,
                      items: <String>[
                        'All',
                        'AUTOMOBILE',
                        'B.sc',
                        'CIVIL',
                        'CSE',
                        'ECE',
                        'EEE',
                        'E&I',
                        'FT',
                        'IT',
                        'MCA',
                        'MECH',
                        'MTS',
                      ].map((String v) {
                        return new DropdownMenuItem<String>(
                          value: v,
                          child: Text(v),
                        );
                      }).toList(),
                      onChanged: (newValue) async {
                        setState(() {
                          dept = newValue;
                          isLoaded = false;
                          deptFilteredData = dept!="All" ? loadedData[0]
                              .where((i) => i['dept'] == dept)
                              .toList() : loadedData[0];
                        });
                        if (isAreaFilter) {
                          setState(() {
                            isLoading = true;
                          });
                          await getDonorData(deptFilteredData, loadedData[1]);
                        }
                      },
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'Show Donors from 50km radius',
                      style: Theme.of(context)
                          .textTheme
                          .headline6
                          .copyWith(fontSize: 14, color: Colors.black),
                    ),
                    Switch(
                        value: isAreaFilter,
                        onChanged: (value) async {
                          setState(() {
                            isAreaFilter = value;
                          });
                          if (isAreaFilter) {
                            setState(() {
                              isLoading = true;
                            });
                            await getDonorData(deptFilteredData, loadedData[1]);
                          }
                        }),
                  ],
                ),
              ],
            ),
            !isLoading
                ? Container(
                    // padding: EdgeInsets.all(15),
                    height: 559,
                    margin: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                    child: (isAreaFilter
                            ? filteredData.length > 0
                            : deptFilteredData.length > 0)
                        ? ListView.builder(
                            itemBuilder: (context, index) {
                              return !isAreaFilter
                                  ? DonationRequestItem(
                                      userData: deptFilteredData[index])
                                  : DonationRequestItem(
                                      userData: filteredData[index]);
                            },
                            itemCount: !isAreaFilter
                                ? deptFilteredData.length
                                : filteredData.length)
                        : Container(
                            width: double.infinity,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                    height: 200,
                                    child: Image.asset(
                                      'assets/images/empty.png',
                                      fit: BoxFit.cover,
                                    )),
                                SizedBox(
                                  height: 20,
                                ),
                                Text("No Requests for You now",
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline1
                                        .copyWith(
                                            fontSize: 16,
                                            fontWeight: FontWeight.normal)),
                              ],
                            ),
                          ))
                : Center(child: CircularProgressIndicator()),
          ],
        ),
      ),
    );
  }
}
