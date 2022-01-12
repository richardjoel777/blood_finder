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
    'passedout': false,
    'faculty': false,
  };
  bool _isLoading = false;
  String _bloodGroup;
  List _data = [];
  List _perData = [];
  List _areaFilteredData = [];
  List _admins = [];

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

  List get admins {
    return [..._admins];
  }

  Future<void> getBloodData(String bloodGroup) async {
    _isLoading = true;
    // print('BLOOD $bloodGroup');
    List temp = [];
    var fb = FirebaseFirestore.instance;
    if (bloodGroup != "All") {
      await fb
          .collection("userData")
          .where("bloodGroup", isEqualTo: bloodGroup)
          .get()
          .then((snapshots) {
        snapshots.docs.forEach((doc) {
          temp.add(doc.data());
          if (temp.length == snapshots.size) {
            temp.sort((a, b) =>
                a['lastDonated'].seconds.compareTo(b['lastDonated'].seconds));
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
    } else {
      await fb.collection("userData").get().then((snapshots) {
        snapshots.docs.forEach((doc) {
          temp.add(doc.data());
          if (temp.length == snapshots.size) {
            temp.sort((a, b) =>
                a['lastDonated'].seconds.compareTo(b['lastDonated'].seconds));
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
  }

  Future<void> updateDonateInfo(String rollno, DateTime date) async {
    String docId;
    try {
      var fb = FirebaseFirestore.instance;
      await fb
          .collection("userData")
          .limit(1)
          .where("rollno", isEqualTo: rollno)
          .get()
          .then((snapshots) async {
        docId = snapshots.docs[0].id;
        await fb
            .collection("userData")
            .doc(docId)
            .update({'lastDonated': date});
        Fluttertoast.showToast(msg: "Updated successfuly");
      });
    } catch (ex) {
      Fluttertoast.showToast(msg: ex.message);
    }
  }

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
        if (u['lat'] != null) {
          var distance = (await geolocator.distanceBetween(
                  double.parse(hospitalResData[0]["lat"]),
                  double.parse(hospitalResData[0]["lon"]),
                  double.parse(u['lat']),
                  double.parse(u['long'])) /
              1000);
          if (distance <= 50) {
            filteredData.add(u);
          }
        } else {
          filteredData.add(u);
        }
        i++;
        if (i == _data.length) {
          _data = filteredData;
          _areaFilteredData = filteredData;
          _isLoading = false;
          notifyListeners();
        }
      });
    } else {
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
      if (_filters['passedout'] == false && d['year'] == "PASSED OUT") {
        return false;
      }
      if (_filters['faculty'] == false && d['year'] == "FACULTY") {
        return false;
      }
      if ((_filters['passedout']) && d['year'] != "PASSED OUT") {
        return false;
      }
      if ((_filters['faculty']) && d['year'] != "FACULTY") {
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
    var doc = await fb.collection("blooddata").doc("blooddata").get();
    return doc.data()['groups'];
  }

  Future<List> getRequests() async {
    var fb = FirebaseFirestore.instance;
    var doc = await fb.collection("blooddata").doc("blooddata").get();
    return doc.data()['requests'];
  }

  Future<List> getDepartments() async {
    var fb = FirebaseFirestore.instance;
    var doc = await fb.collection("blooddata").doc("blooddata").get();
    return doc.data()['departments'];
  }

  Future<Map> getUserData(String rollno) async {
    String docId;
    Map res;
    try {
      //print("HI HELLO");
      var fb = FirebaseFirestore.instance;
      await fb
          .collection("userData")
          .limit(1)
          .where("rollno", isEqualTo: rollno)
          .get()
          .then((snapshots) async {
        docId = snapshots.docs[0].id;
        await fb.collection("userData").doc(docId).get().then((value) {
          res = value.data();
        });
      });
    } catch (ex) {
      Fluttertoast.showToast(msg: ex.message);
    }
    return res;
  }

  static Future<String> getIdofUser(String rollno) async {
    var snapshot = await FirebaseFirestore.instance
        .collection("userData")
        .where("rollno", isEqualTo: rollno)
        .get();
    return snapshot.docs.first.id;
  }

  static Future<void> updateLastCalled(String rollno) async {
    var fb = FirebaseFirestore.instance;
    var id = await getIdofUser(rollno);
    print(id);
    await fb.collection("userData").doc(id).update({
      'lastCalled': DateTime.now(),
    });
    return 0;
  }

  

  Future<void> createRequest(String reqId) async {
    try {
      var fb = FirebaseFirestore.instance;
      await fb.collection("blooddata").doc("blooddata").get().then((doc) async {
        List requests = doc.data()['requests'];
        requests.add({'id': reqId, 'time': DateTime.now()});
        await fb
            .collection("blooddata")
            .doc("blooddata")
            .update({'requests': requests}).then((value) =>
                Fluttertoast.showToast(msg: "Request Added Successfully"));
      });
    } catch (ex) {
      Fluttertoast.showToast(msg: ex.message);
    }
  }

  Future<void> updateUserData(name, bloodgroup, dept, year, rollno, phone1,
      phone2, address, isWilling, isDayScholar) async {
    String docId;
    try {
      var fb = FirebaseFirestore.instance;
      await fb
          .collection("userData")
          .limit(1)
          .where("rollno", isEqualTo: rollno)
          .get()
          .then((snapshots) async {
        docId = snapshots.docs[0].id;
        await fb.collection("userData").doc(docId).update({
          'name': name,
          'bloodGroup': bloodgroup,
          'dept': dept,
          'year': year,
          'rollno': rollno,
          'phone1': phone1,
          'phone2': phone2,
          'area': address,
          'isWilling': isWilling,
          'isDayScholar': isDayScholar,
        });
        Fluttertoast.showToast(msg: "Updated successfuly");
      });
    } catch (ex) {
      Fluttertoast.showToast(msg: ex.message);
    }
  }

  Future<void> addUserData(name, bloodgroup, dept, year, rollno, phone1, phone2,
      address, isWilling, isDayScholar) async {
    try {
      var fb = FirebaseFirestore.instance;
      await fb.collection("userData").add({
        'name': name,
        'bloodGroup': bloodgroup,
        'dept': dept,
        'year': year,
        'rollno': rollno,
        'phone1': phone1,
        'phone2': phone2,
        'area': address,
        'isWilling': isWilling,
        'isDayScholar': isDayScholar,
        'lastDonated': DateTime(2020, 12, 1),
      });
      Fluttertoast.showToast(msg: "Added successfuly");
    } catch (ex) {
      Fluttertoast.showToast(msg: ex.message);
    }
  }

  Future<void> getAdmins() async {
    List admins = [];
    try {
      await FirebaseFirestore.instance
          .collection("admins")
          .doc("admins")
          .get()
          .then((value) {
        admins = value.data()['admins'];
      });
      _admins = admins;
    } catch (ex) {
      print(ex);
    }
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
}
