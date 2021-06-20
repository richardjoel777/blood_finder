import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class DonationRequestItem extends StatelessWidget {
  final userData;
  const DonationRequestItem({
    this.userData,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        bottom: 10,
      ),
      child: Card(
        color: userData['lastDonated'] != null
            ? (DateTime.now()
                        .difference(DateTime.fromMillisecondsSinceEpoch(
                            userData['lastDonated'].seconds * 1000))
                        .inDays >
                    90
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
                    if(userData['year'] != "FACULTY" && userData['year'] != "PASSED OUT") Text(
                        '${userData['year'].toString()}-${userData['dept']}-${userData['sec']}',
                        style: Theme.of(context).textTheme.headline1),
                    if(userData['year'] == "FACULTY" || userData['year'] == "PASSED OUT") Text(
                        userData['year'],
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
                  ],
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                      onPressed: () {
                        launch(('tel:${userData['phone1']}'));
                      },
                      child: Text(userData['phone1'])),
                  TextButton(
                      onPressed: () {
                        launch(('tel:${userData['phone2']}'));
                      },
                      child: Text(userData['phone2'])),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
