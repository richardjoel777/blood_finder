import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:nss_blood_finder/screens/donationFilterScreen.dart';
import 'package:nss_blood_finder/services/blood.dart';
import 'package:nss_blood_finder/widgets/donationItem.dart';
import 'package:provider/provider.dart';

class DonationsScreen extends StatefulWidget {
  static const routeName = '/donations-history';
  @override
  _DonationsScreenState createState() => _DonationsScreenState();
}

class _DonationsScreenState extends State<DonationsScreen> {
  bool isInit = true;

  @override
  void didChangeDependencies() async {
    if (isInit) {
      await Provider.of<BloodService>(context).getDonations();
      // log(Provider.of<BloodService>(context).donations.toString());
      setState(() {
        isInit = false;
      });
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final bloodService = Provider.of<BloodService>(context);
    final mediaQuery = MediaQuery.of(context);
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: new IconButton(
              icon: new Icon(Icons.arrow_back),
              onPressed: () {
                bloodService.resetDonorFilters();
                Navigator.pop(context, true);
              }),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(DonationFilerScreen.routeName);
              },
              icon: Icon(Icons.filter_list),
            )
          ],
          title: Text(
            "Donations",
            style: Theme.of(context).textTheme.headline6,
          ),
        ),
        body: (!isInit && !bloodService.isLoading)
            ? Container(
                // padding: EdgeInsets.all(15),
                height: (mediaQuery.size.height - 60 - mediaQuery.padding.top) *
                    0.9,
                margin: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                child: bloodService.donations.length > 0
                    // ? Center(child: Text("Donations"),)
                    ? ListView.separated(
                        separatorBuilder: (context, index) => Divider(
                              color: Colors.black,
                            ),
                        itemBuilder: (context, index) {
                          return DonationItem(
                            donation: bloodService.donations[index],
                          );
                        },
                        itemCount: bloodService.donations.length)
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
                            Text("No Donations Yet.",
                                style: Theme.of(context)
                                    .textTheme
                                    .headline1
                                    .copyWith(
                                        fontSize: 16,
                                        fontWeight: FontWeight.normal)),
                          ],
                        ),
                      ))
            : Container(
                color: Colors.black.withOpacity(0.5),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ));
  }
}
