import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:hire/controllers/google_signin.dart';
import 'package:hire/models/user_model.dart';
import 'package:hire/normaluser/contact.dart';

import 'package:hire/normaluser/home.dart';
import 'package:hire/normaluser/login.dart';
import 'package:provider/provider.dart';

import 'aboutus.dart';

class Navbar extends StatefulWidget {
  Navbar({Key? key, this.firstName, this.lastName, this.email, this.profile})
      : super(key: key);
  String? firstName = "";
  String? lastName = "";
  String? email = "";
  String? profile = "";

  @override
  State<Navbar> createState() =>
      _NavbarState(firstName, lastName, email, profile);
}

class _NavbarState extends State<Navbar> {
  String? firstName = "";
  final user = FirebaseAuth.instance.currentUser!;
  String? fullName = "";
  String? lastName = "";
  String? email = "";
  String? photoURL = "";
  String? googleEmail = "";
  String profile = "";
  String? profileGoogleUrl = "";
  double rating = 0;
  @override
  void initState() {
    super.initState();
    // firstName = user.displayName;
    setState(() {
      fullName = user.displayName;
      googleEmail = user.email;
    });
  }

  _NavbarState(this.firstName, this.lastName, this.email, this.photoURL);
  @override
  Widget build(BuildContext context) {
    print(profile);
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: fullName != ""
                ? Text(" ${fullName} ")
                : Text(" $firstName $lastName"),
            accountEmail:
                googleEmail != "" ? Text(" ${googleEmail}") : Text("$email"),
            currentAccountPicture: CircleAvatar(
              radius: 40,
              backgroundImage: profileGoogleUrl != ""
                  ? NetworkImage(profileGoogleUrl!)
                  : NetworkImage(profile)
            ),
            decoration: const BoxDecoration(
              color: Colors.green,
              image: DecorationImage(
                image: NetworkImage(
                  "https://th.bing.com/th/id/OIP.IApVvI7lUml_gN8K6vhkiQHaNK?w=186&h=331&c=7&r=0&o=5&pid=1.7",
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text("Home"),
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => home()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.contact_phone),
            title: const Text("Contact Us "),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const contact()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text("About Us "),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) =>  Aboutus()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text("Logout "),
            onTap: () {
              final provider =
                  Provider.of<GoogleSignInController>(context, listen: false);
              provider.logout();
              Logout(context);
            },
          ),
          const Divider(
            color: Colors.black,
          ),
          Align(
            alignment: Alignment.center,
            child: Column(children: <Widget>[
              Text("Rating : $rating", style: const TextStyle(fontSize: 25)),
              const SizedBox(height: 15),
              RatingBar.builder(
                minRating: 0,
                itemSize: 50,
                itemPadding: const EdgeInsets.symmetric(horizontal: 4),
                itemBuilder: (context, _) => const Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                updateOnDrag: true,
                onRatingUpdate: (rating) => setState(() {
                  this.rating = rating;
                }),
              ),
            ]),
          )
        ],
      ),
    );
  }

  Future<void> Logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LoginScreen()));
  }
}
