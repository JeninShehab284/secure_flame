import 'package:flutter/material.dart';

void main() {
  runApp(SecureFlameApp());
}

class SecureFlameApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ControlScreen(),
    );
  }
}

class ControlScreen extends StatefulWidget {
  @override
  _ControlScreenState createState() => _ControlScreenState();
}

class _ControlScreenState extends State<ControlScreen> {
  int selectedTemp = 0;
  bool motionSensorEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Control',
          style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontFamily: 'Poppins',
              fontSize: 30.0),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Image.asset(
              'images/logo.png', // حط صورة الشعار هنا
              width: 40,
            ),
          ),
        ],
        iconTheme: IconThemeData(color: Colors.black),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: '',
          ),
        ],
      ),
      body: Stack(
        children: [
          Image.asset(
            'images/background.jpg', // ضع هنا اسم ملف الخلفية
            fit: BoxFit.cover,
          ),
          // أشكال الخلفية الصفراء
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                SizedBox(height: 20),

                // درجة الحرارة
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.device_thermostat),
                      SizedBox(width: 10),
                      Text(
                        'Temperature: 25°C',
                        style: TextStyle(fontSize: 16, fontFamily: 'Poppins'),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),

                // زر Start Cooking
                buildButton(
                  label: 'Start Cooking',
                  icon: Icons.play_circle,
                  onPressed: () {},
                ),
                SizedBox(height: 10),

                // زر End Cooking
                buildButton(
                  label: 'End Cooking',
                  icon: Icons.power_settings_new,
                  onPressed: () {},
                ),
                SizedBox(height: 30),

                // التحكم بنسبة الحرارة
                Text(
                  'Temperature control (%)',
                  style: TextStyle(
                      fontSize: 16, fontFamily: 'Poppins', color: Colors.grey),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [25, 50, 75, 100].map((value) {
                    return ChoiceChip(
                      label: Text('$value'),
                      selected: selectedTemp == value,
                      onSelected: (_) {
                        setState(() {
                          selectedTemp = value;
                        });
                      },
                      selectedColor: Colors.black,
                      backgroundColor: Colors.grey[200],
                      labelStyle: TextStyle(
                        color:
                            selectedTemp == value ? Colors.white : Colors.black,
                      ),
                    );
                  }).toList(),
                ),
                SizedBox(height: 20),

                // حسّاس الحركة
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Checkbox(
                      value: motionSensorEnabled,
                      onChanged: (val) {
                        setState(() {
                          motionSensorEnabled = val!;
                        });
                      },
                    ),
                    Text('On / OFF Motion Sensor'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // زر مخصص
  Widget buildButton(
      {required String label,
      required IconData icon,
      required VoidCallback onPressed}) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, color: Colors.white),
      label: Text(
        label,
        style: TextStyle(fontSize: 16),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black,
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: StadiumBorder(),
      ),
    );
  }
}
