import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controlScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'TemperatureMonitor.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); //Filter configuration
  await Firebase.initializeApp();
  runApp(SecureFlameApp());
  TemperatureMonitor().init(); //temperature monitoring
}

class SecureFlameApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WelcomeScreen(),
    );
  }
}

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'images/background.jpg',
            fit: BoxFit.cover,
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: SafeArea(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      'images/logo.png',
                      height: 200,
                    ),
                    Text(
                      'Secure Flame',
                      style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Pacifico'),
                    ),
                    SizedBox(height: 15),
                    Text(
                      'Welcome to our app! We are here to make your experience better. Explore all the available features and get started now',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 30),
                    Center(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ControlScreen()),
                          );
                        },
                        label: Text(
                          'Start',
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Poppins'),
                        ),
                        icon: Icon(Icons.arrow_forward, color: Colors.black),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber,
                          padding: EdgeInsets.symmetric(
                              horizontal: 40, vertical: 15),
                          shape: StadiumBorder(),
                          elevation: 3.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
