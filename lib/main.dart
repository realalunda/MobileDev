import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyHomePage(title: 'Exercise'));
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _activityController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();
  final TextEditingController _caloriesController = TextEditingController();

  Future<void> _addWorkout() async {
    await FirebaseFirestore.instance.collection('Workout').add({
      'activity': _activityController.text,
      'duration': int.parse(_durationController.text),
      'calories': int.parse(_caloriesController.text),
      'timestamp': FieldValue.serverTimestamp(),
    });
    _activityController.clear();
    _durationController.clear();
    _caloriesController.clear();
  }

  Future<void> _updateWorkout(String id, String activity, int duration) async {
    await FirebaseFirestore.instance.collection('Workout').doc(id).update({
      'activity': activity,
      'duration': duration,
    });
  }

  Future<void> _deleteWorkout(String id) async {
    await FirebaseFirestore.instance.collection('Workout').doc(id).delete();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // เอา debug ออก
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(
              255, 87, 180, 186), // เปลี่ยนสี appbar เป็นสีฟ้า
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Exercise',
                  style: TextStyle(
                      color: Colors
                          .white)), // เปลี่ยนสีตัวอักษรใน appbar เป็นสีขาว
              const Icon(Icons.sports,
                  color: Colors
                      .white), // ไอคอนกีฬาด้านขวาชิดขอบใน appbar ไม่สามารถกดได้
            ],
          ),
        ),
        body: Container(
          color: const Color.fromARGB(255, 253, 251, 238), // เปลี่ยนสีพื้นหลัง
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Image.network(
                        'https://w0.peakpx.com/wallpaper/926/686/HD-wallpaper-winter-extreme-sports-winter-mountains-snowboarding-skiing-extreme-sports-parachuting.jpg', // URL ของรูปภาพ
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(height: 10),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: const Offset(0, 3),
                            ),
                          ],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              TextField(
                                controller: _activityController,
                                decoration: const InputDecoration(
                                  labelText: 'Activity',
                                  border: OutlineInputBorder(),
                                ),
                                style: const TextStyle(
                                    color: Colors
                                        .black), // เปลี่ยนสีข้อความที่พิมพ์เป็นสีดำ
                              ),
                              const SizedBox(height: 10),
                              TextField(
                                controller: _durationController,
                                decoration: const InputDecoration(
                                  labelText: 'Duration (minutes)',
                                  border: OutlineInputBorder(),
                                ),
                                keyboardType: TextInputType.number,
                                style: const TextStyle(
                                    color: Colors
                                        .black), // เปลี่ยนสีข้อความที่พิมพ์เป็นสีดำ
                              ),
                              const SizedBox(height: 10),
                              TextField(
                                controller: _caloriesController,
                                decoration: const InputDecoration(
                                  labelText: 'Calories Burned',
                                  border: OutlineInputBorder(),
                                ),
                                keyboardType: TextInputType.number,
                                style: const TextStyle(
                                    color: Colors
                                        .black), // เปลี่ยนสีข้อความที่พิมพ์เป็นสีดำ
                              ),
                              const SizedBox(height: 10),
                              ElevatedButton(
                                onPressed: _addWorkout,
                                child: const Text('Add Workout',
                                    style: TextStyle(
                                        color: Color.fromARGB(255, 255, 255,
                                            255))), // เปลี่ยนสีข้อความปุ่มเป็นสีดำ
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color.fromARGB(255, 1,
                                      85, 81), // เปลี่ยนสีปุ่มเป็นสีเขียว
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 50, vertical: 15),
                                  textStyle: const TextStyle(fontSize: 16),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'History Menu',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('Workout')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    final workouts = snapshot.data!.docs;
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: workouts.length,
                      itemBuilder: (context, index) {
                        final workout = workouts[index];
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 5,
                                  blurRadius: 7,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ListTile(
                              title: Text(workout['activity']),
                              subtitle:
                                  Text('Calories: ${workout['calories']}'),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit,
                                        color: Color.fromARGB(255, 1, 85,
                                            81)), // เปลี่ยนสีไอคอน edit เป็นสีเขียว
                                    onPressed: () {
                                      _activityController.text =
                                          workout['activity'];
                                      _durationController.text =
                                          workout['duration'].toString();
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: const Text('Edit Workout'),
                                            content: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                TextField(
                                                  controller:
                                                      _activityController,
                                                  decoration:
                                                      const InputDecoration(
                                                    labelText: 'Activity',
                                                    border:
                                                        OutlineInputBorder(),
                                                  ),
                                                  style: const TextStyle(
                                                      color: Colors
                                                          .black), // เปลี่ยนสีข้อความที่พิมพ์เป็นสีดำ
                                                ),
                                                const SizedBox(height: 10),
                                                TextField(
                                                  controller:
                                                      _durationController,
                                                  decoration:
                                                      const InputDecoration(
                                                    labelText:
                                                        'Duration (minutes)',
                                                    border:
                                                        OutlineInputBorder(),
                                                  ),
                                                  keyboardType:
                                                      TextInputType.number,
                                                  style: const TextStyle(
                                                      color: Colors
                                                          .black), // เปลี่ยนสีข้อความที่พิมพ์เป็นสีดำ
                                                ),
                                              ],
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  _updateWorkout(
                                                    workout.id,
                                                    _activityController.text,
                                                    int.parse(
                                                        _durationController
                                                            .text),
                                                  );
                                                  Navigator.of(context).pop();
                                                },
                                                child: const Text('Save'),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete,
                                        color: Color.fromARGB(255, 254, 79,
                                            45)), // เปลี่ยนสีไอคอน delete เป็นสีแดง
                                    onPressed: () => _deleteWorkout(workout.id),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
