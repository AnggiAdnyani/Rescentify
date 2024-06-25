import 'package:firebase_core/firebase_core.dart'; // Impor pustaka Firebase untuk inisialisasi Firebase
import 'package:flutter/material.dart'; // Impor pustaka Material untuk widget
import 'package:get/get.dart'; // Impor pustaka GetX untuk manajemen state dan navigasi
import 'package:uts/screens/welcome_screen.dart'; // Impor WelcomeScreen, sesuaikan path dengan struktur proyek

void main() async {
  // Fungsi utama aplikasi, titik masuk
  WidgetsFlutterBinding.ensureInitialized(); 
  // Memastikan widget binding sudah terinisialisasi sebelum menjalankan Firebase
  await Firebase.initializeApp(); 
  // Menginisialisasi Firebase sebelum menjalankan aplikasi
  runApp(MyApp()); 
  // Menjalankan aplikasi dengan MyApp sebagai root widget
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const GetMaterialApp(
      debugShowCheckedModeBanner: false, 
      title: 'My App', 
      home: WelcomeScreen(), 
    );
  }
}
