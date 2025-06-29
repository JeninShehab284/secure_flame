import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controlScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'TemperatureMonitor.dart';
import 'package:firebase_database/firebase_database.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(SecureFlameApp());
  TemperatureMonitor().init();
  await Firebase.initializeApp().then((_) {
    print("✅ Firebase Initialized");
  });
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

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  void initState() {
    super.initState();
    testFirebase();
    FirebaseDatabase.instance.ref("test_from_flutter").set({
      "status": "flutter_connected",
    }).then((_) {
      print("✅ تمت الكتابة بنجاح");
    }).catchError((e) {
      print("❌ فشل الاتصال بـ Firebase: $e");
    });
  }

  void testFirebase() async {
    try {
      final ref = FirebaseDatabase.instance.ref("test");
      await ref.set({"message": "hello"});
      print("✅ تم الإرسال إلى Firebase بنجاح");
    } catch (e) {
      print("❌ خطأ في الاتصال بـ Firebase: $e");
    }
  }

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
