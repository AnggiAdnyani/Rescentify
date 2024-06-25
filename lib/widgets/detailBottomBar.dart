import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:uts/screens/cartpage.dart';

class detailBottomBar extends StatelessWidget {
  final Map<String, dynamic> product;

  const detailBottomBar({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final formattedPrice = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp').format(product['price']);

    return BottomAppBar(
      color: const Color.fromARGB(255, 223, 215, 206),
      child: SizedBox(
        width: double.infinity,
        height: 70,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Harga produk
            Text(
              formattedPrice,
              style: const TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            // Tombol untuk memesan produk
            ElevatedButton.icon(
              onPressed: () {
                addToCart(product);
                Navigator.push(context, MaterialPageRoute(builder: (context) => CartPage()));
              },
              icon: const Icon(CupertinoIcons.cart_badge_plus, color: Colors.white),
              label: const Text(
                "Order Now",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.brown),
                padding: MaterialStateProperty.all(
                    const EdgeInsetsDirectional.symmetric(vertical: 13, horizontal: 15)),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void addToCart(Map<String, dynamic> product) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print('User is not logged in');
      return;
    }

    final cartRef = FirebaseFirestore.instance.collection('cart');
    
    final userId = user.uid;
    
    cartRef
        .where('userId', isEqualTo: userId)
        .where('name', isEqualTo: product['name'])
        .get()
        .then((QuerySnapshot querySnapshot) {
      if (querySnapshot.docs.isEmpty) {
        cartRef.add({
          'userId': userId,
          'name': product['name'],
          'price': product['price'],
          'image': product['image'],
          'quantity': 1,
        }).then((_) {
          print('Product added to cart successfully!');
        }).catchError((error) {
          print('Failed to add product to cart: $error');
        });
      } else {
        final existingDoc = querySnapshot.docs.first;
        final currentQuantity = existingDoc['quantity'] ?? 0;
        existingDoc.reference.update({'quantity': currentQuantity + 1})
            .then((_) {
          print('Product quantity updated successfully!');
        }).catchError((error) {
          print('Failed to update product quantity: $error');
        });
      }
    }).catchError((error) {
      print('Failed to check existing product in cart: $error');
    });
  }
}
