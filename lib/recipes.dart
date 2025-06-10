import 'package:flutter/material.dart';
import 'controlScreen.dart';
import 'setting.dart';
import 'kabsaingredients.dart';
import 'pastaingredient.dart';
import 'soupingredient.dart';

class RecipesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        iconSize: 30.0,
        currentIndex: 0,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RecipesPage()),
              );
              break;
            case 1:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ControlScreen()),
              );
              break;
            case 2:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsPage()),
              );
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dining_sharp), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.home_sharp), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.settings_sharp), label: ''),
        ],
      ),
      body: Stack(
        children: [
          Image.asset(
            'images/background.jpg',
            fit: BoxFit.cover,
          ),
          Container(
              child: SafeArea(
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Recipes',
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontFamily: 'Pacifico',
                        ),
                      ),
                      Image(
                        image: AssetImage('images/bar.png'),
                        height: 100,
                      )
                    ],
                  ),
                ),
                SizedBox(height: 60.0),
                Container(
                  width: 350.0,
                  child: Column(
                    children: [
                      RecipeButton(
                        name: 'Kabsa',
                        imagePath: 'images/kabsaa.jpg',
                        targetPage: Kabsaing(),
                      ),
                      SizedBox(height: 16),
                      RecipeButton(
                        name: 'Pasta',
                        imagePath: 'images/pasta.jpg',
                        targetPage: Pastaing(),
                      ),
                      SizedBox(height: 16),
                      RecipeButton(
                        name: 'Soup',
                        imagePath: 'images/soup.jpg',
                        targetPage: Souping(),
                      ),
                    ],
                  ),
                )
              ],
            ),
          )),
        ],
      ),
    );
  }
}

class RecipeButton extends StatelessWidget {
  final String name;
  final String imagePath;
  final Widget targetPage;

  const RecipeButton({
    required this.name,
    required this.imagePath,
    required this.targetPage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => targetPage),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40),
          ),
        ),
        child: Row(
          children: [
            ClipOval(
              child: Image.asset(imagePath,
                  width: 50, height: 50, fit: BoxFit.cover),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Text(
                name,
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins'),
              ),
            ),
            const Icon(Icons.arrow_forward, size: 28),
          ],
        ),
      ),
    );
  }
}
