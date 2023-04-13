import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.only(top: 30, left: 15, right: 15),
      children: [
        InkWell(
          onTap: () {
            Navigator.pushNamed(context, '/passchange');
          },
          child: Container(
            color: Color(0xFF262a34),
            child: ListTile(
              leading: Icon(
                Icons.lock_outline,
                color: Color(0xFF0695b4),
              ),
              title: Text('Change Password', style: TextStyle(color: Color(0xFF0695b4))),
              trailing: Icon(
                  Icons.arrow_forward_ios,
                  color: Color(0xFF0695b4),
                ),

              ),
            ),
          ),

        SizedBox(
          height: 20,
        ),
        InkWell(
          onTap: () async{
            final pref = await SharedPreferences.getInstance();
            pref.clear();
            Navigator.pushNamed(context, '/login');
          },
          child: Container(
            decoration:
                BoxDecoration(color: Color(0xFF262a34), borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15))),
            child: ListTile(
              leading: Icon(
                Icons.logout_outlined,
                color: Color(0xFF0695b4),
              ),
              title: Text(
                'Log Out',
                style: TextStyle(color: Color(0xFF0695b4)),
              ),
              trailing: Icon(
                  Icons.arrow_forward_ios,
                  color: Color(0xFF0695b4),
                ),
              ),
            ),
          ),

      ],
    );
  }
}
