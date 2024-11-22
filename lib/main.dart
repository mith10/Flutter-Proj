import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'HomeScreen.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  String storageBucketUrl = 'gs://unique-solutions-15768.appspot.com';
  Platform.isAndroid
      ? await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: 'AIzaSyAy7wuG7KDlHT737NNsNjjSScnQ6LPoNhI',
      appId: '1:448572083843:android:bfd9b11099d31c9d6295b6',
      messagingSenderId: '448572083843',
      projectId: 'unique-solutions-15768',
      storageBucket: storageBucketUrl,
    ),
  )
      : await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Company App',
      theme: ThemeData(
        primarySwatch: Colors.grey, // Set the primary color here
      ),
      home: const HomeScreen(),
    );
  }
}


