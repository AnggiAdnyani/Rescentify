import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uts/screens/product_detail.dart';

class AllProduct extends StatelessWidget {
  const AllProduct({Key? key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('products').snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Text('No products found');
        }

        final products = snapshot.data!.docs;

        return GridView.count(
          crossAxisCount: 2,
          childAspectRatio: 0.68,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          children: products.map((productDoc) {
            final product = productDoc.data() as Map<String, dynamic>;
            final price = product['price'];
            final formattedPrice =
                NumberFormat.currency(locale: 'id_ID', symbol: 'Rp')
                    .format(price);

            return Container(
              padding: const EdgeInsets.only(left: 15, right: 15, top: 10),
              margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 7),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 214, 197, 163),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductDetail(product: product),
                        ),
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.all(2),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(
                            10),
                        child: Image.network(
                          product['image'],
                          height: 120,
                          width: 200,
                          fit: BoxFit
                              .cover,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(bottom: 8),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      product['name'],
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.brown,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      formattedPrice,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.brown,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: ElevatedButton(
                      onPressed: () {
                        addToCart(product);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(255, 250, 251, 242),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text(
                        "+ Order Now",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.brown,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            );
          }).toList(),
        );
      },
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
        existingDoc.reference
            .update({'quantity': currentQuantity + 1}).then((_) {
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
