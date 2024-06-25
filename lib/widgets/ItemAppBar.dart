import 'package:flutter/material.dart';

class ItemAppBar extends StatelessWidget {
  const ItemAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white, // Set warna latar belakang kontainer
      padding:
          const EdgeInsets.all(25), // Beri padding sebesar 25 untuk kontainer
      child: Row(
        children: [
          // Tombol kembali
          InkWell(
            onTap: () {
              Navigator.pop(
                  context); // Aksi untuk kembali ke halaman sebelumnya
            },
            child: const Icon(Icons.arrow_back,
                size: 30, color: Colors.brown), // Icon untuk kembali
          ),
          const Padding(
            padding: EdgeInsets.only(
                left: 20), // Beri padding kiri sebesar 20 untuk judul produk
            child: Text(
              "Product", // Judul halaman produk
              style: TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.bold,
                color: Colors.brown, // Warna teks judul produk
              ),
            ),
          ),
          const Spacer(), // Spacer untuk menempatkan ikon favorit ke ujung kanan
        ],
      ),
    );
  }
}
