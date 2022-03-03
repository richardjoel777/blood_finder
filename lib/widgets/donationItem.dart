import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nss_blood_finder/screens/updateRequest.dart';

class DonationItem extends StatelessWidget {
  final donation;
  const DonationItem({
    @required this.donation,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        log("works");
        Navigator.pushNamed(context, UpdateReqScreen.routeName,
            arguments: donation['id']);
      },
      child: Container(
        margin: EdgeInsets.only(
          bottom: 10,
        ),
        child: Stack(children: [
          Card(
            color: Colors.white,
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
                          child: Text(donation['patientName'],
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6
                                  .copyWith(color: Colors.black)),
                          fit: BoxFit.fitWidth,
                        ),
                        FittedBox(
                          child: Text(donation['hospitalName'],
                              style: Theme.of(context)
                              .textTheme
                              .headline1
                              .copyWith(fontSize: 14)),
                          fit: BoxFit.fitWidth,
                        ),
                        FittedBox(
                          child: Text(donation['area'],
                              style: Theme.of(context)
                              .textTheme
                              .headline1
                              .copyWith(fontSize: 14)),
                          fit: BoxFit.fitWidth,
                        ),
                        FittedBox(
                          child: Text(donation['bloodGroup'],
                              style: Theme.of(context)
                              .textTheme
                              .headline1
                              .copyWith(fontSize: 14)),
                          fit: BoxFit.fitWidth,
                        ),
                        FittedBox(
                          child: Text(
                              DateFormat('dd-MM-yyyy')
                                  .format(
                                      new DateTime.fromMillisecondsSinceEpoch(
                                          donation['createdAt'].seconds * 1000))
                                  .toString(),
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
                      if (donation['isArranged'])
                        ElevatedButton(
                          onPressed: () {},
                          child: Text("Arranged"),
                          style:
                              ElevatedButton.styleFrom(primary: Colors.green),
                        ),
                      if (!donation['isArranged'])
                        ElevatedButton(
                          onPressed: () {},
                          child: Text("Not Arranged"),
                          style: ElevatedButton.styleFrom(primary: Colors.red),
                        ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
