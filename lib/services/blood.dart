import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';

class BloodService with ChangeNotifier {
  Map<String, Object> _filters = {
    'area': '',
    'dept': 'All',
    'year': 'All',
    'hostel': false,
    'willing': true,
  };
  bool _isLoading = false;
  String _bloodGroup;
  List _data = [];
  List _perData = [];
  List _areaFilteredData = [];

  Map<String, Object> get filters {
    return {..._filters};
  }

  bool get isLoading {
    return _isLoading;
  }

  String get bloodGroup {
    return _bloodGroup;
  }

  List get bloodData {
    return [..._data];
  }

  Future<void> getBloodData(String bloodGroup) async {
    _isLoading = true;
    // print('BLOOD $bloodGroup');
    List temp = [];
    var fb = FirebaseFirestore.instance;
    await fb
        .collection("data")
        .where("bloodGroup", isEqualTo: bloodGroup)
        .get()
        .then((snapshots) {
      snapshots.docs.forEach((doc) {
        temp.add(doc.data());
        if (temp.length == snapshots.size) {
          temp.sort((a,b) => a['lastDonated'].seconds.compareTo(b['lastDonated'].seconds));
          _data = temp;
          _perData = temp;
          _areaFilteredData = temp;
          _bloodGroup = bloodGroup;
          // print(_data);
          setFilters(_perData);
          // print(_data);
          _isLoading = false;
          notifyListeners();
        }
      });
    });
  }

  Future<void> updateDonateInfo(String rollno, DateTime date) async {
    String docId;
    try {
      var fb = FirebaseFirestore.instance;
      await fb
          .collection("data")
          .limit(1)
          .where("rollno", isEqualTo: rollno)
          .get()
          .then((snapshots) async {
        docId = snapshots.docs[0].id;
        await fb.collection("data").doc(docId).update({'lastDonated': date});
        Fluttertoast.showToast(msg: "Updated successfuly");
      });
    } catch (ex) {
      Fluttertoast.showToast(msg: ex.message);
    }
  }

  // Future<void> updateDummyDate() async {
  //   try {
  //     var fb = FirebaseFirestore.instance;
  //     await fb.collection("data").get().then((snapshots) async {
  //       snapshots.docs.forEach((doc) async {
  //         await fb.collection("data").doc(doc.id).update({'lastDonated': DateTime(2021,1,1)});
  //       });
  //     });
  //   } catch (ex) {
  //     print(ex.message);
  //   }
  // }

  Future<void> getDonorData(String hospitalArea) async {
    int i = 0;
    // print(hospitalArea);
    Geolocator geolocator = Geolocator();
    List filteredData = [];
    var hArea = '$hospitalArea India';
    // print(_data.length);
    final hUrl = Uri.parse(
        'https://nominatim.openstreetmap.org/search/$hArea?format=json');
    var hospitalRes = await http.get(hUrl);
    if (hospitalRes.statusCode == 200) {
      var hospitalResData = jsonDecode(hospitalRes.body);
      _data.forEach((u) async {
        try {
          var uArea = '${u['area']} India';
          var url = Uri.parse(
              'https://nominatim.openstreetmap.org/search/$uArea?format=json');
          var res = await http.get(url);
          var resData = jsonDecode(res.body);
          if (resData.length > 0) {
            var distance = (await geolocator.distanceBetween(
                    double.parse(hospitalResData[0]["lat"]),
                    double.parse(hospitalResData[0]["lon"]),
                    double.parse(resData[0]["lat"]),
                    double.parse(resData[0]["lon"])) /
                1000);
            if (distance <= 50) {
              filteredData.add(u);
            }
          } else {
            filteredData.add(u);
          }
        } on Exception catch (_) {
          i++;
          // print(e);
        }
        i++;
        // print(i);
        if (i == _data.length) {
          _data = filteredData;
          _areaFilteredData = filteredData;
          // print("BYE");
          // print(_data);
          _isLoading = false;
          notifyListeners();
        }
      });
    } else {
      // print("NOT WORKING");
      Fluttertoast.showToast(msg: "Something went wrong");
    }
  }

  void setFilters(List argData) {
    _data = argData.where((d) {
      if (_filters['dept'] != 'All' && d['dept'] != _filters['dept']) {
        return false;
      }
      if (_filters['year'] != 'All' && d['year'] != _filters['year']) {
        return false;
      }
      if ((_filters['willing']) && d['isWilling'] == false) {
        return false;
      }
      if ((_filters['hostel']) && d['isDayScholar'] == true) {
        return false;
      }
      return true;
    }).toList();
    // print(_data);
    notifyListeners();
  }

  Future<List> getBloodGroups() async {
    var fb = FirebaseFirestore.instance;
    var doc = await fb.collection("data").doc("bloodGroups").get();
    return doc.data()['groups'];
  }

  void changeFilter(Map newFilters) async {
    _isLoading = true;
    notifyListeners();
    if (newFilters['area'] != _filters['area'] && newFilters['area'] != '') {
      // print("YES");
      _filters = newFilters;
      await getDonorData(newFilters['area']).then((_) {
        setFilters(_perData);
      });
    } else if (newFilters['area'] == _filters['area'] &&
        newFilters['area'] != '') {
      _filters = newFilters;
      setFilters(_areaFilteredData);
      _isLoading = false;
    } else {
      _filters = newFilters;
      setFilters(_perData);
      _isLoading = false;
    }
    notifyListeners();
  }

  Future<List> getDepartments() async {
    var fb = FirebaseFirestore.instance;
    var doc = await fb.collection("data").doc("bloodGroups").get();
    return doc.data()['departments'];
  }
}
