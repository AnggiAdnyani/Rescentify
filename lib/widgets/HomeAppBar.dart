import 'package:flutter/material.dart';
import 'package:uts/screens/map.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    // Fungsi build digunakan untuk membuat tata letak widget
    return Container(
      // Container untuk menampilkan App Bar di bagian atas halaman
      color: const Color.fromARGB(
          255, 253, 253, 253), // Warna latar belakang App Bar
      padding: const EdgeInsets.all(5), // Padding di dalam Container
      child: Row(
        children: [
          Image.asset(
            'assets/images/logo lilin.jpg',
            width: 50,
            height: 50,
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 15),
            padding: const EdgeInsets.symmetric(horizontal: 15),
            height: 50,
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 214, 197, 163),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 5),
                  height: 70,
                  width: 140,
                  child: TextFormField(
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: "Cari",
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.search,
                    size: 17,
                    color: Color.fromRGBO(6, 6, 6, 0.5),
                  ),
                  onPressed: () {
                    // Tambahkan kode aksi saat tombol pencarian ditekan
                  },
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.location_on,
              size: 30,
              color: const Color.fromARGB(255, 8, 8, 8).withOpacity(0.5),
            ),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Maps(),
                  ));
            },
          ),
          const Spacer(),
          Icon(
            Icons.account_box,
            size: 40,
            color: const Color.fromARGB(255, 8, 8, 8).withOpacity(0.5),
          ),
        ],
      ),
    );
  }
}
