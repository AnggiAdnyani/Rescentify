import 'package:flutter/material.dart'; // Import pustaka Material untuk widget dasar
import 'package:uts/screens/cartpage.dart';
import 'package:uts/widgets/AllProduct.dart'; // Import widget AllProduct
import 'package:uts/widgets/ItemsWidget.dart'; // Import widget ItemsWidget
import '../widgets/HomeAppBar.dart'; // Import widget HomeAppBar

class HomePage extends StatelessWidget {
  const HomePage({super.key});

@override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          const HomeAppBar(),
          Container(
            padding: const EdgeInsets.only(top: 15),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25),
                topRight: Radius.circular(25),
              ),
            ),
            child: Column(
              children: [
                const SizedBox(height: 20),
                const Text(
                  "Most Liked",
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 184, 133, 71),
                  ),
                ),
                ItemsWidget(),
                const SizedBox(height: 20),
                const Text(
                  "All Product",
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 184, 133, 71),
                  ),
                ),
                const AllProduct(),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color.fromARGB(255, 184, 133, 71),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          if (index == 1) { // Navigasi ke CartPage saat indeks 1 (Cart) dipilih
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CartPage()),
            );
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notifications',
          ),
        ],
      ),
    );
  }
}
