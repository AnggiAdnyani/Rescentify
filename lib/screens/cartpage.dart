import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uts/screens/Homepage.dart';
import 'package:uts/widgets/HomeAppBar.dart';

class Product {
  final String name;
  final double price;
  int quantity;

  Product({required this.name, required this.price, this.quantity = 1});
}

class Cart {
  final CollectionReference cartRef =
      FirebaseFirestore.instance.collection('cart');
  List<Product> products = [];

  Future<void> addProduct(Product product) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print('User is not logged in');
      return;
    }
    final userId = user.uid;

    QuerySnapshot<Object?> querySnapshot = await cartRef
        .where('name', isEqualTo: product.name)
        .where('userId', isEqualTo: userId)
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      QueryDocumentSnapshot<Object?> doc = querySnapshot.docs.first;
      int currentQuantity = doc.get('quantity') ?? 0;
      await doc.reference.update({'quantity': currentQuantity + 1});
    } else {
      await cartRef.add({
        'name': product.name,
        'price': product.price,
        'quantity': 1,
        'userId': userId
      });
      products.add(product);
    }
  }

  Future<void> increaseQuantity(Product product) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print('User is not logged in');
      return;
    }
    final userId = user.uid;

    QuerySnapshot<Object?> querySnapshot = await cartRef
        .where('name', isEqualTo: product.name)
        .where('userId', isEqualTo: userId)
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      QueryDocumentSnapshot<Object?> doc = querySnapshot.docs.first;
      int currentQuantity = doc.get('quantity') ?? 0;
      await doc.reference.update({'quantity': currentQuantity + 1});
    }
  }

  Future<void> decreaseQuantity(Product product) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print('User is not logged in');
      return;
    }
    final userId = user.uid;

    QuerySnapshot<Object?> querySnapshot = await cartRef
        .where('name', isEqualTo: product.name)
        .where('userId', isEqualTo: userId)
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      QueryDocumentSnapshot<Object?> doc = querySnapshot.docs.first;
      int currentQuantity = doc.get('quantity') ?? 0;
      if (currentQuantity > 1) {
        await doc.reference.update({'quantity': currentQuantity - 1});
      } else {
        await doc.reference.delete();
        products.remove(product);
      }
    }
  }

  Future<double> getTotalPrice() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print('User is not logged in');
      return 0.0;
    }
    final userId = user.uid;

    double total = 0.0;
    QuerySnapshot snapshot =
        await cartRef.where('userId', isEqualTo: userId).get();
    for (var document in snapshot.docs) {
      Map<String, dynamic> data = document.data() as Map<String, dynamic>;
      total += data['price'] * data['quantity'];
    }
    return total;
  }
}

class CartPage extends StatelessWidget {
  final Cart cart = Cart();
  final NumberFormat currencyFormatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const HomeAppBar(),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Text(
                      "Order",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25.0,
                        color: Color.fromARGB(255, 184, 133, 71),
                      ),
                    ),
                    const SizedBox(height: 18.0),
                    StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('cart')
                          .where(
                            'userId',
                            isEqualTo: FirebaseAuth.instance.currentUser?.uid,
                          )
                          .snapshots(),
                      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (!snapshot.hasData) {
                          return const CircularProgressIndicator();
                        }
                        return Column(
                          children: snapshot.data!.docs.map((DocumentSnapshot document) {
                            Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                            int quantity = data['quantity'] ?? 0;
                            Product product = Product(
                              name: data['name'],
                              price: data['price'].toDouble(),
                              quantity: quantity,
                            );
                            return CartItem(
                              product: product,
                              cart: cart,
                              currencyFormatter: currencyFormatter,
                            );
                          }).toList(),
                        );
                      },
                    ),
                    const SizedBox(height: 16.0),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      persistentFooterButtons: [
        StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('cart')
              .where(
                'userId',
                isEqualTo: FirebaseAuth.instance.currentUser?.uid,
              )
              .snapshots(),
          builder: (
            BuildContext context,
            AsyncSnapshot<QuerySnapshot> snapshot,
          ) {
            if (!snapshot.hasData) {
              return const CircularProgressIndicator();
            }

            double total = 0.0;
            for (var document in snapshot.data!.docs) {
              Map<String, dynamic> data = document.data() as Map<String, dynamic>;
              total += data['price'] * data['quantity'];
            }

            return Container(
              color: Colors.white,
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      const Text(
                        "Total",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                      ),
                      Text(
                        currencyFormatter.format(total),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                      ),
                    ],
                  ),
                  const Divider(),
                  MaterialButton(
                    onPressed: () {},
                    color: const Color.fromARGB(255, 184, 133, 71),
                    height: 60.0,
                    minWidth: double.infinity,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: const Text(
                      "Pay Now",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color.fromARGB(255, 184, 133, 71),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          if (index == 0) { // Navigasi ke HomePage saat indeks 0 (Home) dipilih
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
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

class CartItem extends StatelessWidget {
  final Product product;
  final Cart cart;
  final NumberFormat currencyFormatter;
  const CartItem(
      {Key? key,
      required this.product,
      required this.cart,
      required this.currencyFormatter})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Container(
            width: 80.0,
            height: 80.0,
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 184, 133, 71),
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Center(
              child: Container(
                width: 60.0,
                height: 60.0,
                decoration: BoxDecoration(
                  image: const DecorationImage(
                    fit: BoxFit.scaleDown,
                    image: NetworkImage(
                        "https://pebblely.com/ideas/candle/colored-background.jpg"),
                  ),
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  width: 100.0,
                  child: Text(
                    product.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 8.0),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        cart.increaseQuantity(product);
                      },
                      child: Container(
                        width: 20.0,
                        height: 20.0,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 184, 133, 71),
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        child: const Icon(Icons.add,
                            color: Colors.black, size: 15.0),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        "${product.quantity}",
                        style: const TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.bold),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        cart.decreaseQuantity(product);
                      },
                      child: Container(
                        width: 20.0,
                        height: 20.0,
                        decoration: BoxDecoration(
                          color: const Color.fromRGBO(243, 231, 219, 1),
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        child: const Icon(Icons.remove,
                            color: Colors.black, size: 15.0),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      currencyFormatter
                          .format(product.price * product.quantity),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
