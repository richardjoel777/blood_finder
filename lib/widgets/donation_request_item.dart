import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nss_blood_finder/services/blood.dart';
import 'package:url_launcher/url_launcher.dart';

class DonationRequestItem extends StatelessWidget {
  final userData;
  const DonationRequestItem({
    this.userData,
    Key key,
  }) : super(key: key);

  String getRom(String num) {
    switch (num) {
      case "1":
        return "I";
      case "2":
        return "II";
      case "3":
        return "III";
      case "4":
        return "IV";
      case "5":
        return "V";
    }
    return "";
  }

  bool isWithinThreeMonths(var datetime) {
    return DateTime.now()
            .difference(
                DateTime.fromMillisecondsSinceEpoch(datetime.seconds * 1000))
            .inDays <=
        90;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        bottom: 10,
      ),
      child: Stack(children: [
        Card(
          color: userData['lastDonated'] != null
              ? (!isWithinThreeMonths(userData['lastDonated'])
                  ? Colors.white
                  : Colors.red[100])
              : Colors.white,
          elevation: 5,
          child: Container(
            height: 160,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  width: 150,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FittedBox(
                        child: Text(userData['name'],
                            style: Theme.of(context)
                                .textTheme
                                .headline6
                                .copyWith(color: Colors.black)),
                        fit: BoxFit.fitWidth,
                      ),
                      Text(userData['bloodGroup'],
                          style: Theme.of(context).textTheme.headline1),
                      if (userData['year'] != "FACULTY" &&
                          userData['year'] != "PASSED OUT")
                        Text(
                            '${getRom(userData['year'].toString())}-${userData['dept']}-${userData['sec']}',
                            style: Theme.of(context).textTheme.headline1),
                      if (userData['year'] == "FACULTY" ||
                          userData['year'] == "PASSED OUT")
                        Text(userData['year'],
                            style: Theme.of(context).textTheme.headline1),
                      Text(userData['rollno'],
                          style: Theme.of(context).textTheme.headline1),
                      FittedBox(
                        child: Text(userData['area'],
                            style: Theme.of(context)
                                .textTheme
                                .headline1
                                .copyWith(fontSize: 14)),
                        fit: BoxFit.fitWidth,
                      ),
                      if (isWithinThreeMonths(userData['lastDonated']))
                        Text(
                          DateFormat.yMd().format(
                              DateTime.fromMillisecondsSinceEpoch(
                                  userData['lastDonated'].seconds * 1000)),
                          style: Theme.of(context)
                              .textTheme
                              .headline1
                              .copyWith(fontSize: 14),
                        ),
                    ],
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                        onPressed: () async {
                          await BloodService.updateLastCalled(
                              userData['rollno']);
                          // userData['lastCalled'] = DateTime.now();
                          launch(('tel:${userData['phone1']}'));
                        },
                        child: Text(userData['phone1'])),
                    // TextButton(
                    //     onPressed: () async {
                    //       await BloodService.updateLastCalled(
                    //           userData['rollno']);
                    //       launch(('tel:${userData['phone2']}'));
                    //     },
                    //     child: Text(userData['phone2'])),
                    IconButton(
                        onPressed: () async {
                          String detail =
                              '${userData['name']}\n${userData['rollno']}\n${userData['phone1']}\n${userData['bloodGroup']}';
                          var url = "https://wa.me/?text=${Uri.encodeComponent(detail)}";
                          await launch(url);
                          // Clipboard.setData(ClipboardData(text: detail));
                          // Fluttertoast.showToast(msg: "Donor details copied to  clipBoard");
                        },
                        icon: Icon(Icons.share)),
                  ],
                )
              ],
            ),
          ),
        ),
        if (userData['lastCalled'] != null &&
            DateTime.now()
                    .difference(DateTime.fromMillisecondsSinceEpoch(
                        userData['lastCalled'].seconds * 1000))
                    .inHours <=
                24)
          Positioned(
              right: 10,
              top: 0,
              child: Chip(
                  padding: EdgeInsets.all(0),
                  backgroundColor: Colors.red,
                  label:
                      Text('CALLED', style: TextStyle(color: Colors.white)))),
      ]),
    );
  }
}
