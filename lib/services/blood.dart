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
      await fb.collection("userData").get().then((snapshots) {
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
    var fb = FirebaseFirestore.instance;
    var doc = await fb.collection("blooddata").doc("blooddata").get();
    return doc.data()['groups'];
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
      log("Hi");
      var fb = FirebaseFirestore.instance;
      log(id);
      var doc = await fb.collection("requests").doc(id).get();
      if (doc.exists && reqDateValid(doc.get('createdAt'))) {
        log("Yes");
        return true;
      } else {
        print("No");
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
    var fb = FirebaseFirestore.instance;
    var doc = await fb.collection("blooddata").doc("blooddata").get();
    return doc.data()['departments'];
  }

  Future<List> getDistricts() async {
    var fb = FirebaseFirestore.instance;
    var doc = await fb.collection("blooddata").doc("blooddata").get();
    return doc.data()['districts'];
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

  static Future<void> bulkUpdate(List rollnos, DateTime date) async {
    try {
      var fb = FirebaseFirestore.instance;
      for (int i = 0; i < rollnos.length; i++) {
        // print(rollnos[i]);
        var response = await fb
            .collection("userData")
            .where("rollno", isEqualTo: rollnos[i])
            .get();
        var batch = fb.batch();
        response.docs.forEach((doc) {
          print(doc.id);
          var docRef = fb.collection("userData").doc(doc.id);
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

  Future<void> updateRequest(
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
      // var docRef = fb.collection("userData").doc("La5YHpmSxD4NbzTwUyvH");
      // await docRef.update({
      //   'lastDonated': createdAt,
      //   'donations': FieldValue.arrayUnion([id])
      // });

      WriteBatch _batch = fb.batch();

      for (var donor in donors) {
        if (donor['rollno'] != '') {
          var userId = await getIdofUser(donor['rollno']);
          _batch.update(fb.doc("/userData/$userId"), {
            "lastDonated": createdAt,
            "donations": FieldValue.arrayUnion([userId]),
          });
        }
      }

      await _batch.commit();
      if (donations.isNotEmpty) {
        await getDonations();
      }
      // Fluttertoast.showToast(msg: "Request Updated Successfully");
    } catch (ex) {
      Fluttertoast.showToast(msg: ex.message);
    }
  }

  Future<void> getDonations() async {
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
        setDonationFilters(_perDonations);
        notifyListeners();
      }
    });
  }

  // Map<String, Object> _donationFilters = {
  //   'area': 'All',
  //   'dept': 'All',
  //   'donor': '',
  //   'bloodGroup': '',
  //   'isArranged': true,
  // };

  void setDonationFilters(List argData) {
    log("Works");
    // log(_donations.toString());
    log(_donationFilters.toString());
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
    log(_donations.toString());
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
    log("uploading image");
    var uuid = const Uuid();
    String fileName = uuid.v4() + path.split('/').last;
    Reference firebaseStorageRef =
        FirebaseStorage.instance.ref().child('uploads/$fileName');
    UploadTask uploadTask = firebaseStorageRef.putFile(File(path));
    TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
    String url = await taskSnapshot.ref.getDownloadURL();
    return url;
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

  void changeDonationFilter(Map newFilters) {
    _isLoading = true;
    notifyListeners();
    _donationFilters = newFilters;
    log("New Filters" + newFilters.toString());
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
