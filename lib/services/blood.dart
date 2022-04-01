// import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:uuid/uuid.dart';
// import 'package:http/http.dart' as http;
// import 'package:geolocator/geolocator.dart';

class BloodService with ChangeNotifier {
  Map<String, Object> _filters = {
    'area': 'All',
    'dept': 'All',
    'year': 'All',
    'hostel': false,
    'willing': true,
    'passedout': false,
    'faculty': false,
  };

  Map<String, Object> _donationFilters = {
    'area': 'All',
    'dept': 'All',
    'donor': '',
    'bloodGroup': 'All',
    'isArranged': false,
  };

  Map<String, int> _deptCount = {
    'CSE': 0,
    'IT': 0,
    'FT': 0,
    'EEE': 0,
    'ECE': 0,
    'B.SC': 0,
    'AUTO': 0,
    'CIVIL': 0,
    'E&I': 0,
    'MCA': 0,
    'MECH': 0,
    'MTS': 0,
    'CHE': 0,
  };

  bool _isLoading = false;
  String _bloodGroup;
  List _data = [];
  List _perData = [];
  List _perDonations = [];
  // List _areaFilteredData = [];
  List _admins = [];

  List _donations = [];

  Map<String, Object> get filters {
    return {..._filters};
  }

  Map<String, Object> get deptCount {
    return {..._deptCount};
  }

  Map<String, Object> get donationFilters {
    return {..._donationFilters};
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

  List get donations {
    return [..._donations];
  }

  List get admins {
    return [..._admins];
  }

  void resetFilters() {
    _filters = {
      'area': 'All',
      'dept': 'All',
      'year': 'All',
      'hostel': false,
      'willing': true,
      'passedout': false,
      'faculty': false,
    };
  }

  Future<void> setDeptCount() async {
    try {
      var fb = FirebaseFirestore.instance;
      var snapshots = await fb.collection("requests").get();
      List temp = [];
      snapshots.docs.forEach((doc) {
        temp.add(doc.data());
        if (temp.length == snapshots.docs.length) {
          temp.sort((a, b) =>
              -a['createdAt'].seconds.compareTo(b['createdAt'].seconds));
          _perDonations = temp;
          _donations = temp;
        }
      });
      var year = DateTime.now().year;
      for (var donation in donations) {
        var donationYear = DateTime.fromMillisecondsSinceEpoch(
                donation['createdAt'].seconds * 1000)
            .year;
        if (donation['isArranged'] && year == donationYear) {
          for (var donor in donation['donors']) {
            if (donor['rollno'] != '') {
              _deptCount[donor['dept']]++;
            }
          }
        }
      }
    } catch (ex) {
      log(ex.toString());
    }
    notifyListeners();
  }

  void resetDeptCount() {
    _deptCount = {
      'IT': 0,
      'FT': 0,
      'EEE': 0,
      'ECE': 0,
      'CSE': 0,
      'B.SC': 0,
      'AUTO': 0,
      'CIVIL': 0,
      'E&I': 0,
      'MCA': 0,
      'MECH': 0,
      'MTS': 0,
      'CHE': 0,
    };
  }

  Future<void> getBloodData(String bloodGroup) async {
    _isLoading = true;
    // print('BLOOD $bloodGroup');
    List temp = [];
    var fb = FirebaseFirestore.instance;
    try {
      if (bloodGroup != "All") {
        await fb
            .collection("donorsData")
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
              // _areaFilteredData = temp;
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
        await fb.collection("donorsData").get().then((snapshots) {
          snapshots.docs.forEach((doc) {
            temp.add(doc.data());
            if (temp.length == snapshots.size) {
              temp.sort((a, b) =>
                  a['lastDonated'].seconds.compareTo(b['lastDonated'].seconds));
              _data = temp;
              _perData = temp;
              // _areaFilteredData = temp;
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
    } catch (ex) {
      Fluttertoast.showToast(msg: ex.message);
    }
  }

  Future<void> updateDonateInfo(String rollno, DateTime date) async {
    String docId;
    try {
      var fb = FirebaseFirestore.instance;
      await fb
          .collection("donorsData")
          .limit(1)
          .where("rollno", isEqualTo: rollno)
          .get()
          .then((snapshots) async {
        docId = snapshots.docs[0].id;
        await fb
            .collection("donorsData")
            .doc(docId)
            .update({'lastDonated': date});
        Fluttertoast.showToast(msg: "Updated successfuly");
      });
    } catch (ex) {
      Fluttertoast.showToast(msg: ex.message);
    }
  }

  // Future<void> getDonorData(String hospitalArea) async {
  //   int i = 0;
  //   // print(hospitalArea);
  //   Geolocator geolocator = Geolocator();
  //   List filteredData = [];
  //   var hArea = '$hospitalArea India';
  //   // print(_data.length);
  //   final hUrl = Uri.parse(
  //       'https://nominatim.openstreetmap.org/search/$hArea?format=json');
  //   var hospitalRes = await http.get(hUrl);
  //   if (hospitalRes.statusCode == 200) {
  //     var hospitalResData = jsonDecode(hospitalRes.body);
  //     _data.forEach((u) async {
  //       if (u['lat'] != null) {
  //         var distance = (await geolocator.distanceBetween(
  //                 double.parse(hospitalResData[0]["lat"]),
  //                 double.parse(hospitalResData[0]["lon"]),
  //                 double.parse(u['lat']),
  //                 double.parse(u['long'])) /
  //             1000);
  //         if (distance <= 60) {
  //           filteredData.add(u);
  //         }
  //       } else {
  //         filteredData.add(u);
  //       }
  //       i++;
  //       if (i == _data.length) {
  //         _data = filteredData;
  //         _areaFilteredData = filteredData;
  //         _isLoading = false;
  //         notifyListeners();
  //       }
  //     });
  //   } else {
  //     Fluttertoast.showToast(msg: "Something went wrong");
  //   }
  // }

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
      if (_filters['area'] != 'All' && d['area'] != _filters['area']) {
        return false;
      }
      return true;
    }).toList();
    // print(_data);
    notifyListeners();
  }

  Future<List> getBloodGroups() async {
    try {
      var fb = FirebaseFirestore.instance;
      var doc = await fb.collection("blooddata").doc("blooddata").get();
      return doc.data()['groups'];
    } catch (ex) {
      print(ex.message);
    }
    return [];
  }

  bool reqDateValid(var request) {
    return (DateTime.now()
                .difference(
                    DateTime.fromMillisecondsSinceEpoch(request.seconds * 1000))
                .inMinutes <
            90) &&
        (DateTime.now()
                .difference(
                    DateTime.fromMillisecondsSinceEpoch(request.seconds * 1000))
                .inMinutes >=
            0);
  }

  Future<bool> validateRequest(String id) async {
    try {
      var fb = FirebaseFirestore.instance;
      var doc = await fb.collection("requests").doc(id).get();
      if (doc.exists && reqDateValid(doc.get('createdAt'))) {
        return true;
      } else {
        return false;
      }
    } catch (ex) {
      print(ex.toString());
    }
    return false;
  }

  // Future<List> getRequests() async {
  //   var fb = FirebaseFirestore.instance;
  //   var doc = await fb.collection("blooddata").doc("blooddata").get();
  //   return doc.data()['requests'];
  // }

  Future<List> getDepartments() async {
    try {
      var fb = FirebaseFirestore.instance;
      var doc = await fb.collection("blooddata").doc("blooddata").get();
      return doc.data()['departments'];
    } catch (ex) {
      print(ex.message);
    }
    return [];
  }

  Future<List> getDistricts() async {
    try {
      var fb = FirebaseFirestore.instance;
      var doc = await fb.collection("blooddata").doc("blooddata").get();
      return doc.data()['districts'];
    } catch (ex) {
      print(ex.message);
    }
    return [];
  }

  Future<Map> getUserData(String rollno) async {
    String docId;
    Map res;
    try {
      //print("HI HELLO");
      var fb = FirebaseFirestore.instance;
      await fb
          .collection("donorsData")
          .limit(1)
          .where("rollno", isEqualTo: rollno)
          .get()
          .then((snapshots) async {
        docId = snapshots.docs[0].id;
        await fb.collection("donorsData").doc(docId).get().then((value) {
          res = value.data();
        });
      });
    } catch (ex) {
      Fluttertoast.showToast(msg: ex.message);
    }
    return res;
  }

  Future<Map> getRequestData(String id) async {
    Map res;
    try {
      //print("HI HELLO");
      var fb = FirebaseFirestore.instance;
      var doc = await fb.collection("requests").doc(id).get();
      res = doc.data();
    } catch (ex) {
      Fluttertoast.showToast(msg: ex.message);
    }
    return res;
  }

  static Future<String> getIdofUser(String rollno) async {
    try {
      var snapshot = await FirebaseFirestore.instance
          .collection("donorsData")
          .where("rollno", isEqualTo: rollno)
          .get();
      return snapshot.docs.first.id;
    } catch (ex) {
      print(ex.message);
      return "";
    }
  }

  static Future<void> updateLastCalled(String rollno) async {
    try {
      var fb = FirebaseFirestore.instance;
      var id = await getIdofUser(rollno);
      print(id);
      await fb.collection("donorsData").doc(id).update({
        'lastCalled': DateTime.now(),
      });
    } catch (ex) {
      print(ex.message);
    }
    return 0;
  }

  static Future<void> bulkUpdate(List rollnos, DateTime date) async {
    try {
      var fb = FirebaseFirestore.instance;
      for (int i = 0; i < rollnos.length; i++) {
        // print(rollnos[i]);
        var response = await fb
            .collection("donorsData")
            .where("rollno", isEqualTo: rollnos[i])
            .get();
        var batch = fb.batch();
        response.docs.forEach((doc) {
          print(doc.id);
          var docRef = fb.collection("donorsData").doc(doc.id);
          batch.update(docRef, {'lastDonated': date});
        });
        await batch.commit();
      }
    } catch (ex) {
      print(ex);
    }
  }

  Future<String> createRequest(
      String patientName,
      String bloodGroup,
      String hospitalName,
      String area,
      String units,
      String reason,
      String inchargeName,
      String inchargeRollno,
      String patientPhone) async {
    try {
      int size = int.parse(units);
      List<Map<String, String>> donors = [];
      for (int i = 0; i < size; i++) {
        donors.add({'name': '', 'rollno': '', 'dept': '', 'formImg': ''});
      }
      var fb = FirebaseFirestore.instance;
      var newDoc = fb.collection("requests").doc();
      var data = {
        'id': newDoc.id,
        'createdAt': DateTime.now(),
        'patientName': patientName,
        'bloodGroup': bloodGroup,
        'hospitalName': hospitalName,
        'area': area,
        'units': units,
        'reason': reason,
        'inchargeName': inchargeName,
        'inchargeRollno': inchargeRollno,
        'patientPhone': patientPhone,
        'isArranged': false,
        'accompanyName': '',
        'accompanyNameRollno': '',
        'donors': donors,
      };
      await newDoc.set(data);
      Fluttertoast.showToast(msg: "Request Added Successfully");
      return newDoc.id;
    } catch (ex) {
      Fluttertoast.showToast(msg: ex.message);
    }
    return "";
  }

  Future<bool> updateRequest(
    String id,
    String patientName,
    String bloodGroup,
    String hospitalName,
    String area,
    String units,
    String reason,
    String inchargeName,
    String inchargeRollno,
    String patientPhone,
    bool isArranged,
    List<Map<String, String>> donors,
    String accompanyName,
    String accompanyRollNo,
  ) async {
    try {
      var createdAt = DateTime.now();
      var fb = FirebaseFirestore.instance;
      var doc = fb.collection("requests").doc(id);
      var data = {
        'id': id,
        'createdAt': createdAt,
        'patientName': patientName,
        'bloodGroup': bloodGroup,
        'hospitalName': hospitalName,
        'area': area,
        'units': units,
        'reason': reason,
        'inchargeName': inchargeName,
        'inchargeRollno': inchargeRollno,
        'patientPhone': patientPhone,
        'isArranged': isArranged,
        'accompanyName': accompanyName,
        'accompanyRollno': accompanyRollNo,
        'donors': donors,
      };
      await doc.set(data);
      // var docRef = fb.collection("donorsData").doc("La5YHpmSxD4NbzTwUyvH");
      // await docRef.update({
      //   'lastDonated': createdAt,
      //   'donations': FieldValue.arrayUnion([id])
      // });

      WriteBatch _batch = fb.batch();

      for (var donor in donors) {
        if (donor['rollno'] != '') {
          var userId = await getIdofUser(donor['rollno']);
          _batch.update(fb.doc("/donorsData/$userId"), {
            "lastDonated": createdAt,
            "donations": FieldValue.arrayUnion([userId]),
          });
        }
      }

      await _batch.commit();
      if (donations.isNotEmpty) {
        await getDonations();
      }

      return true;
      // Fluttertoast.showToast(msg: "Request Updated Successfully");
    } catch (ex) {
      Fluttertoast.showToast(msg: ex.message);
      return false;
    }
  }

  Future<void> getDonations() async {
    _isLoading = true;
    var fb = FirebaseFirestore.instance;
    try {
      var snapshots = await fb.collection("requests").get();
      List temp = [];
      snapshots.docs.forEach((doc) {
        temp.add(doc.data());
        if (temp.length == snapshots.docs.length) {
          temp.sort((a, b) =>
              -a['createdAt'].seconds.compareTo(b['createdAt'].seconds));
          _perDonations = temp;
          _donations = temp;
          setDonationFilters(_perDonations);
          _isLoading = false;
          notifyListeners();
        }
      });
    } catch (ex) {
      Fluttertoast.showToast(msg: ex.message);
    }
  }

  // Map<String, Object> _donationFilters = {
  //   'area': 'All',
  //   'dept': 'All',
  //   'donor': '',
  //   'bloodGroup': '',
  //   'isArranged': true,
  // };

  void setDonationFilters(List argData) {
    _donations = argData.where((d) {
      if (_donationFilters['area'] != 'All' &&
          d['area'] != _donationFilters['area']) {
        return false;
      }
      if (_donationFilters['isArranged'] == true && d['isArranged'] != true) {
        return false;
      }
      if (_donationFilters['bloodGroup'] != 'All' &&
          d['bloodGroup'] != _donationFilters['bloodGroup']) {
        return false;
      }
      bool isDeptIncl = false;
      bool isDonorIncl = false;
      for (var donor in d['donors']) {
        if (_donationFilters['dept'] != 'All' &&
            donor['dept'] == _donationFilters['dept']) {
          isDeptIncl = true;
        }
        if (_donationFilters['donor'] != '' &&
            donor['rollno'] == _donationFilters['donor']) {
          isDonorIncl = true;
        }
      }
      if (_donationFilters['dept'] != 'All' && !isDeptIncl) {
        return false;
      }
      if (_donationFilters['donor'] != '' && !isDonorIncl) {
        return false;
      }
      return true;
    }).toList();
    // print(_data);
    notifyListeners();
  }

  void resetDonorFilters() {
    _donationFilters = {
      'area': 'All',
      'dept': 'All',
      'donor': '',
      'bloodGroup': 'All',
      'isArranged': false,
    };
  }

  static Future<String> uploadFileToFirestore(String path) async {
    try {
      var uuid = const Uuid();
      String fileName = uuid.v4() + path.split('/').last;
      Reference firebaseStorageRef =
          FirebaseStorage.instance.ref().child('uploads/$fileName');
      UploadTask uploadTask = firebaseStorageRef.putFile(File(path));
      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
      String url = await taskSnapshot.ref.getDownloadURL();
      return url;
    } catch (ex) {
      log(ex.message);
      Fluttertoast.showToast(msg: ex.message);
      return "";
    }
  }

  Future<void> updateUserData(name, bloodgroup, dept, year, rollno, phone1,
      phone2, address, isWilling, isDayScholar) async {
    String docId;
    try {
      var fb = FirebaseFirestore.instance;
      await fb
          .collection("donorsData")
          .limit(1)
          .where("rollno", isEqualTo: rollno)
          .get()
          .then((snapshots) async {
        docId = snapshots.docs[0].id;
        await fb.collection("donorsData").doc(docId).update({
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

  Future<void> addUserData(name, bloodgroup, dept, year, sec, rollno, phone1,
      phone2, address, isWilling, isDayScholar) async {
    try {
      var fb = FirebaseFirestore.instance;
      await fb.collection("donorsData").add({
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

  void changeDonationFilter(Map newFilters) {
    _isLoading = true;
    notifyListeners();
    _donationFilters = newFilters;
    setDonationFilters(_perDonations);
    _isLoading = false;
    notifyListeners();
  }

  void changeFilter(Map newFilters) async {
    _isLoading = true;
    notifyListeners();
    // if (newFilters['area'] != _filters['area'] && newFilters['area'] != '') {
    //   // print("YES");
    //   _filters = newFilters;
    //   await getDonorData(newFilters['area']).then((_) {
    //     setFilters(_perData);
    //   });
    // } else if (newFilters['area'] == _filters['area'] &&
    //     newFilters['area'] != '') {
    //   _filters = newFilters;
    //   setFilters(_areaFilteredData);
    //   _isLoading = false;
    // } else {
    //   _filters = newFilters;
    //   setFilters(_perData);
    //   _isLoading = false;
    // }
    _filters = newFilters;
    setFilters(_perData);
    _isLoading = false;
    notifyListeners();
  }
}
