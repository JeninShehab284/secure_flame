import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:secureflame/soupingredient.dart';
import 'recipes.dart';
import 'controlScreen.dart';
import 'setting.dart';
import 'pastaingredient.dart';
import 'package:firebase_database/firebase_database.dart';

class Soupins extends StatefulWidget {
  @override
  _SoupinsState createState() => _SoupinsState();
}

class _SoupinsState extends State<Soupins> {
  List<String> instructions = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchInstructions();
  }

  void fetchInstructions() async {
    final doc = await FirebaseFirestore.instance
        .collection('recipes')
        .doc('soup')
        .get();
    if (doc.exists && doc.data()!.containsKey('instructions')) {
      setState(() {
        instructions = List<String>.from(doc['instructions']);
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      print("No instructions found for Soup.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      bottomNavigationBar: BottomNavigationBar(
        iconSize: 30.0,
        currentIndex: 0,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => RecipesPage()));
              break;
            case 1:
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ControlScreen()));
              break;
            case 2:
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SettingsPage()));
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dining_sharp), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.home_sharp), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.settings_sharp), label: ''),
        ],
      ),
      body: SafeArea(
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : ListView(
                children: [
                  Stack(
                    children: [
                      Container(
                        height: 250,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('images/soup.jpg'),
                            fit: BoxFit.cover,
                            colorFilter: ColorFilter.mode(
                              Colors.black.withOpacity(0.3),
                              BlendMode.darken,
                            ),
                          ),
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(30),
                            bottomRight: Radius.circular(30),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 10,
                        left: 10,
                        child: IconButton(
                          icon: Icon(Icons.arrow_circle_left,
                              color: Colors.white, size: 40.0),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Souping()));
                          },
                        ),
                      ),
                      Positioned(
                        bottom: 20,
                        left: 20,
                        child: Text(
                          'INSTRUCTIONS',
                          style: TextStyle(
                            fontSize: 34,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Anton',
                            letterSpacing: 4.5,
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                blurRadius: 10.0,
                                color: Colors.black.withOpacity(0.7),
                                offset: Offset(2.0, 2.0),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 0, horizontal: 5.0),
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: Colors.black),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children:
                          instructions.map((step) => buildStep(step)).toList(),
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 0, horizontal: 40.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.amberAccent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                            elevation: 3,
                          ),
                          onPressed: () {
                            FirebaseDatabase.instance
                                .ref("flame/status")
                                .set(true);
                          },
                          child: Text(
                            'Start Cooking',
                            style: TextStyle(
                                fontSize: 15.0,
                                color: Colors.black,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

Widget buildStep(String text) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text("•  ",
          style: TextStyle(fontSize: 20, height: 1.5, color: Colors.black)),
      Expanded(
        child: Text(
          text,
          style: TextStyle(
              fontSize: 16,
              height: 1.5,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.bold),
        ),
      ),
    ],
  );
}
