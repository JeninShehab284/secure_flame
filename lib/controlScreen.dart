import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'recipes.dart';
import 'setting.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'motion_monitor.dart';
import 'gas_monitor.dart';

class ControlScreen extends StatefulWidget {
  @override
  _ControlScreenState createState() => _ControlScreenState();
}

class _ControlScreenState extends State<ControlScreen> {
  int selectedTemp = 0;
  bool motionSensorEnabled = false;
  bool stoveStatus = false;
  bool isLoading = true;
  late DatabaseReference _Rtemperature;
  late DatabaseReference _Rstatus;
  late DatabaseReference _RmotionSensor;
  double temperature = 0;
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  @override
  void initState() {
    super.initState();
    MotionMonitor().init();
    GasLeakMonitor().init();

    _Rstatus = FirebaseDatabase.instance.ref("flame/status");
    _Rtemperature = FirebaseDatabase.instance.ref("flame/temperature");
    _RmotionSensor = FirebaseDatabase.instance.ref("flame/motion_sensor");
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    _Rstatus.onValue.listen((event) {
      //final newStatus = event.snapshot.value.toString();
      final val = event.snapshot.value;
      print("🔥 status = $val");
      setState(() {
        if (val == null) {
          isLoading = true;
        } else {
          isLoading = false;
          stoveStatus = val == true || val.toString().toLowerCase() == 'true';
        }
      });
    });

    _Rtemperature.onValue.listen((event) {
      final newTemp = event.snapshot.value;
      setState(() {
        if (newTemp is double) {
          temperature = newTemp;
        } else if (newTemp is int) {
          temperature = newTemp.toDouble();
        } else if (newTemp is String) {
          temperature = double.tryParse(newTemp)?.toDouble() ?? 0;
        } else {
          temperature = 0;
        }
      });
    });

    _RmotionSensor.onValue.listen((event) {
      final sensorStatus = event.snapshot.value;
      setState(() {
        motionSensorEnabled = sensorStatus.toString().toLowerCase() == 'true';
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        iconSize: 30.0,
        currentIndex: 1,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => RecipesPage()));
              break;
            case 1:
              Navigator.pushReplacement(context,
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
      body: Stack(
        children: [
          Image.asset(
            'images/background.jpg',
            fit: BoxFit.cover,
          ),
          SafeArea(
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Control',
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
                SizedBox(height: 20),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.device_thermostat),
                      SizedBox(width: 5),
                      Text(
                        'Temperature: ${temperature.toStringAsFixed(1)}°C',
                        style: TextStyle(
                            fontSize: 20,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                buildButton(
                  label: 'Start Cooking',
                  icon: Icons.play_circle,
                  onPressed: () async {
                    await _Rstatus.set(true);
                    await FirebaseDatabase.instance
                        .ref("flame/control_temperature")
                        .set(0);
                    final snapshot = await _Rstatus.get();
                    final status = snapshot.value;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(status == true
                            ? "The cook is working✅"
                            : "Failed to start⚠️"),
                        duration: Duration(seconds: 2),
                      ),
                    );
                    setState(() {
                      selectedTemp = 90;
                    });
                  },
                ),
                SizedBox(height: 10),
                buildButton(
                  label: 'End Cooking',
                  icon: Icons.power_settings_new,
                  onPressed: () async {
                    await _Rstatus.set(false);
                    await FirebaseDatabase.instance
                        .ref("flame/control_temperature")
                        .set(0);
                    final snapshot = await _Rstatus.get();
                    final status = snapshot.value;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(status == false
                            ? "The cook turned off🛑"
                            : "Failed to stop⚠️"),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                ),
                SizedBox(height: 20),
                Text(
                  isLoading
                      ? "loading....⏳"
                      : (stoveStatus
                          ? "The cook is working now 🔥"
                          : "The cook is off 🛑"),
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 30),
                Container(
                  width: 350,
                  height: 100,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black,
                      width: 2,
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Temperature control (%)',
                        style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'Poppins',
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
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
                              FirebaseDatabase.instance
                                  .ref("flame/control_temperature")
                                  .set(value);
                            },
                            selectedColor: Colors.black,
                            backgroundColor: Colors.grey[200],
                            labelStyle: TextStyle(
                              color: selectedTemp == value
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Checkbox(
                      value: motionSensorEnabled,
                      onChanged: (val) {
                        setState(() {
                          motionSensorEnabled = val!;
                        });
                        FirebaseDatabase.instance
                            .ref("flame/motion_sensor")
                            .set(val);
                      },
                      activeColor: Colors.black,
                    ),
                    Text(
                      'On / OFF Motion Sensor',
                      style: TextStyle(
                          fontSize: 15.0,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget buildButton({
    required String label,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
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
