import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:uts/screens/camera.dart';
import 'package:uts/widgets/detailBottomBar.dart';
import 'package:uts/widgets/itemAppBar.dart';

class ProductDetail extends StatelessWidget {
  final Map<String, dynamic> product;

  const ProductDetail({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final formattedPrice = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp')
        .format(product['price']);

    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 223, 215, 206),
        body: ListView(
          children: [
            const ItemAppBar(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.only(
                    top: 10,
                    bottom: 1,
                    left: 10,
                    right: 10,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Detail",
                        style: TextStyle(
                          fontSize: 25,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: Image.network(product['image'], height: 300),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 1, bottom: 5, left: 10),
              child: Row(
                children: [
                  Text(
                    product['name'],
                    style: const TextStyle(
                      fontSize: 28,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 1, bottom: 5, left: 10),
              child: Row(
                children: [
                  Text(
                    formattedPrice,
                    style: const TextStyle(
                      fontSize: 24,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 5, bottom: 1, left: 10),
              child: Row(
                children: [
                  Text(
                    "Description",
                    style: TextStyle(
                        fontSize: 22,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: Container(
                padding: const EdgeInsets.only(top: 0.1),
                child: Text(
                  product['description'] ?? 'No description available',
                  textAlign: TextAlign.justify,
                  style: const TextStyle(
                    fontSize: 17,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 1, bottom: 20, left: 5),
              child: Row(
                children: [
                  RatingBar.builder(
                    initialRating: 4,
                    minRating: 1,
                    direction: Axis.horizontal,
                    itemCount: 5,
                    itemSize: 20,
                    itemPadding: const EdgeInsets.symmetric(horizontal: 4),
                    itemBuilder: (context, _) => const Icon(
                      Icons.star,
                      color: Colors.yellow,
                    ),
                    onRatingUpdate: (index) {},
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.add_a_photo,
                      color: Colors.brown,
                    ),
                    onPressed: () {
                       Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CameraPage()),
                        );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
        bottomNavigationBar: detailBottomBar(product: product));
  }
}
