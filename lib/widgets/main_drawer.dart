import 'package:flutter/material.dart';
import 'package:nss_blood_finder/screens/edit_screen.dart';
import 'package:nss_blood_finder/screens/loginScreen.dart';
import 'package:nss_blood_finder/services/auth.dart';
import 'package:provider/provider.dart';

class MainDrawer extends StatelessWidget {
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
          buildListTile(
            'Home',
            Icons.home,
            () {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil('/', (route) => false);
            },
          ),
          if(auth.currentUser != null) buildListTile(
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
          
          if(auth.currentUser != null) buildListTile("Logout", Icons.logout, () async {
            await Provider.of<AuthProvider>(context, listen: false).signOut().then((_) =>
                Navigator.of(context)
                    .pushNamedAndRemoveUntil('/', (route) => false));
          })
        ],
      ),
    );
  }
}
