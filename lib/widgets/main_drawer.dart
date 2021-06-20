import 'package:flutter/material.dart';
import 'package:nss_blood_finder/screens/addAccountScreen.dart';
import 'package:nss_blood_finder/screens/addData.dart';
import 'package:nss_blood_finder/screens/createReqScreen.dart';
import 'package:nss_blood_finder/screens/edit_profile.dart';
import 'package:nss_blood_finder/screens/edit_screen.dart';
import 'package:nss_blood_finder/screens/loginScreen.dart';
import 'package:nss_blood_finder/screens/registerScreen.dart';
import 'package:nss_blood_finder/services/auth.dart';
import 'package:nss_blood_finder/services/blood.dart';
import 'package:provider/provider.dart';

class MainDrawer extends StatefulWidget {
  @override
  _MainDrawerState createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {

  List admins = [];
  bool isInit = true;

  Widget buildListTile(String title, IconData icon, Function tapHandler) {
    return ListTile(
      leading: Icon(
        icon,
        size: 26,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontFamily: 'RobotoCondensed',
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      onTap: tapHandler,
    );
  }

  @override
  void didChangeDependencies() async {
    if(isInit){
      admins = await Provider.of<BloodService>(context, listen: false).getAdmins();
      isInit = false;
      setState(() {
      });
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    return Drawer(
      child: Column(
        children: [
          Container(
            height: 120,
            width: double.infinity,
            padding: EdgeInsets.all(20),
            alignment: Alignment.centerLeft,
            color: Theme.of(context).primaryColor,
            child: Text(
              'KEC Blood Finder',
              style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                  color: Colors.white),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          if(auth.currentUser != null) buildListTile(
            'Home',
           Icons.home,
            () {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil('/', (route) => false);
            },
          ),
          if(auth.currentUser != null && admins.contains(auth.currentUser.uid)) buildListTile(
            'Edit Donation Detail',
            Icons.edit,
            () {
              Navigator.of(context)
                  .pushNamed(EditScreen.routeName,);
            },
          ),
          if(auth.currentUser == null) buildListTile("login", Icons.login, () {
            Navigator.of(context).pushNamed(
                LoginScreen.routeName,);
          }),
          if(auth.currentUser == null) buildListTile("Register", Icons.login, () {
            Navigator.of(context).pushNamed(
                RegisterScreen.routeName,);
          }),
          if(auth.currentUser != null && admins.contains(auth.currentUser.uid)) buildListTile("Edit Profile", Icons.edit, () {
            Navigator.of(context).pushNamed(
                EditProfileScreen.routeName,);
          }),
          if(auth.currentUser != null && admins.contains(auth.currentUser.uid)) buildListTile("Add Profile", Icons.add, () {
            Navigator.of(context).pushNamed(
                AddDataScreen.routeName,);
          }),
          if(auth.currentUser != null && admins.contains(auth.currentUser.uid)) buildListTile("Add Account", Icons.create, () {
            Navigator.of(context).pushNamed(
                AddAccountScreen.routeName,);
          }),
          if(auth.currentUser != null && admins.contains(auth.currentUser.uid)) buildListTile("Create Request", Icons.create, () {
            Navigator.of(context).pushNamed(
                CreateReqScreen.routeName,);
          }),
          if(auth.currentUser != null) buildListTile("Logout", Icons.logout, () async {
            await Provider.of<AuthProvider>(context, listen: false).signOut().then((_) =>
                Navigator.of(context)
                    .pushNamedAndRemoveUntil(LoginScreen.routeName, (route) => false));
          }),
        ],
      ),
    );
  }
}
