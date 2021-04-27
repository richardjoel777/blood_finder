import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:nss_blood_finder/screens/edit_screen.dart';
import 'package:nss_blood_finder/screens/filters_screen.dart';
import 'package:nss_blood_finder/screens/loginScreen.dart';
import 'package:nss_blood_finder/services/auth.dart';
import 'package:nss_blood_finder/services/blood.dart';
import 'package:provider/provider.dart';

import 'package:nss_blood_finder/screens/donateScreen.dart';
import 'package:nss_blood_finder/screens/requestScreen.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
      ChangeNotifierProvider(create: (ctx) => BloodService()),
      ChangeNotifierProvider(create: (ctx) => AuthProvider()),
    ],
    child: MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
              primarySwatch: Colors.red,
              accentColor: Colors.yellowAccent,
              canvasColor: Color.fromRGBO(255, 2254, 229, 1),
              fontFamily: 'Raleway',
              textTheme: ThemeData.light().textTheme.copyWith(
                  bodyText2: TextStyle(
                    color: Color.fromRGBO(20, 51, 51, 1),
                  ),
                  bodyText1: TextStyle(
                    color: Color.fromRGBO(20, 51, 51, 1),
                  ),
                  headline6: TextStyle(
                    color: Color.fromRGBO(255, 255, 255, 1),
                    fontSize: 20,
                    fontFamily: 'RobotoCondensed',
                    fontWeight: FontWeight.bold,
                  ),
                  headline1: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                    fontFamily: 'RobotoCondensed',
                    fontWeight: FontWeight.bold,
                  ))),
      home: RequestsScreen(),
      routes: {
        DonateScreen.routeName: (ctx) => DonateScreen(),
        FiltersScreen.routeName: (ctx) => FiltersScreen(),
        LoginScreen.routeName: (ctx) => LoginScreen(),
        EditScreen.routeName: (ctx) => EditScreen(),
      },
    ));
  }
}
