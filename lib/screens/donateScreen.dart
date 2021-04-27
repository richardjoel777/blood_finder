import 'package:flutter/material.dart';
import 'package:nss_blood_finder/screens/filters_screen.dart';
import 'package:nss_blood_finder/services/blood.dart';
import 'package:provider/provider.dart';
import '../widgets/donation_request_item.dart';

class DonateScreen extends StatefulWidget {
  static const routeName = '/donate';
  @override
  _DonateScreenState createState() => _DonateScreenState();
}

class _DonateScreenState extends State<DonateScreen> {
  String bloodGroup;
  bool isInit = true;

  @override
  void didChangeDependencies() async {
    if (isInit) {
      setState(() {
        bloodGroup = ModalRoute.of(context).settings.arguments as String;
      });
      await Provider.of<BloodService>(context, listen: false)
          .getBloodData(bloodGroup);
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
        backgroundColor: Theme.of(context).canvasColor,
        appBar: AppBar(
          actions: [
            IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(FiltersScreen.routeName);
              },
              icon: Icon(Icons.filter_list),
            )
          ],
          title: Text(
            'Find ${bloodService.bloodGroup} Blood',
            style: Theme.of(context).textTheme.headline6,
          ),
        ),
        body: bloodService.isLoading==false ? Container(
            // padding: EdgeInsets.all(15),
            height: (mediaQuery.size.height -
                60 -
                mediaQuery.padding.top) *
            0.9,
            margin: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
            child: bloodService.bloodData.length > 0
                ? ListView.builder(
                    itemBuilder: (context, index) {
                      return DonationRequestItem(
                          userData: bloodService.bloodData[index]);
                    },
                    itemCount: bloodService.bloodData.length)
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
                        Text("No Donors found",
                            style: Theme.of(context)
                                .textTheme
                                .headline1
                                .copyWith(
                                    fontSize: 16,
                                    fontWeight: FontWeight.normal)),
                      ],
                    ),
                  )) : Container(
                    color: Colors.black.withOpacity(0.5),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ));
  }
}
