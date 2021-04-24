import 'package:cloud_firestore/cloud_firestore.dart';

class BloodService {
  Future<List> getBloodData(String bloodGroup) async {
    List data = [];
    var fb = FirebaseFirestore.instance;
    await fb
        .collection("data")
        .where("bloodGroup", isEqualTo: bloodGroup)
        .where("isWilling", isEqualTo: true)
        .get()
        .then((snapshots) {
      snapshots.docs.forEach((doc) {
        data.add(doc.data());
      });
    });
    return data;
  }

  Future<List> getBloodGroups() async {
    var fb = FirebaseFirestore.instance;
    var doc = await fb.collection("data").doc("bloodGroups").get();
    return doc.data()['groups'];
  }

  Future<List> getDepartments() async {
    var fb = FirebaseFirestore.instance;
    var doc = await fb.collection("data").doc("bloodGroups").get();
    return doc.data()['departments'];
  }

  Future<void> latLong(String docId, double lat, double long) async {
    var fb = FirebaseFirestore.instance;
    await fb.collection("data").doc(docId).update({'lat': lat, 'long': long});
  }
}
