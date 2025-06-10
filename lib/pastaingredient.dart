import 'package:flutter/material.dart';
import 'pastainstructions.dart';
import 'recipes.dart';
import 'controlScreen.dart';
import 'setting.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Pastaing extends StatelessWidget {
  Future<List<String>> fetchIngredients() async {
    final doc = await FirebaseFirestore.instance
        .collection('recipes')
        .doc('Pasta')
        .get();
    final data = doc.data();
    if (data != null && data.containsKey('ingredients')) {
      return List<String>.from(data['ingredients']);
    } else {
      return [];
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
        child: FutureBuilder<List<String>>(
          future: fetchIngredients(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error loading ingredients.'));
            }

            final ingredients = snapshot.data ?? [];

            return ListView(
              children: [
                buildHeader(context),
                SizedBox(height: 10),
                ...ingredients.map((item) => buildIngredientTile(item)),
                buildButtons(context),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget buildHeader(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 250,
          width: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('images/pasta.jpg'),
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
            icon:
                Icon(Icons.arrow_circle_left, color: Colors.white, size: 40.0),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => RecipesPage()));
            },
          ),
        ),
        Positioned(
          bottom: 20,
          left: 20,
          child: Text(
            'INGREDIENTS',
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
    );
  }

  Widget buildIngredientTile(String item) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 5,
              offset: Offset(0, 2),
            )
          ],
        ),
        child: Text(
          item,
          style: TextStyle(fontSize: 16),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget buildButtons(BuildContext context) {
    return Container(
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
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Pastains()));
            },
            child: Text(
              'view the full recipe',
              style: TextStyle(
                  fontSize: 15.0,
                  color: Colors.black,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.amberAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              elevation: 3,
            ),
            onPressed: () async {
              final Uri youtubeUrl =
                  Uri.parse('https://www.youtube.com/watch?v=jISP4kzfa_U');
              if (await canLaunchUrl(youtubeUrl)) {
                await launchUrl(youtubeUrl,
                    mode: LaunchMode.externalApplication);
              } else {
                throw 'Could not launch $youtubeUrl';
              }
            },
            child: Text(
              'view the video',
              style: TextStyle(
                  fontSize: 15.0,
                  color: Colors.black,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
