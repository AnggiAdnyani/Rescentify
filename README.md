# Rescentify 
## Deskripsi Singkat
Rescentify merupakan aplikasi yang dirancang untuk membantu user yang ingin belanja lilin aromaterapi menjadi lebih cepat dan praktis. Aplikasi ini memiliki antar muka yang gampang dipakai dan fitur lengkap yang membantu user dalam memilih, membeli, dan menikmati lilin dengan aroma yang sesuai dengan selera mereka. 

## Design Figma 
![welcome page, login, signup](https://github.com/AnggiAdnyani/Rescentify/blob/main/assets/gambar/figma%201.png?raw=true)

![home page, cart page, product description](https://github.com/AnggiAdnyani/Rescentify/blob/main/assets/gambar/figma%202.png?raw=true)

## Pembahasan 

 - Pada awalan page terdapat welcome page yang terdiri dari 2 button yaitu explore more dan login  

![enter image description here](https://github.com/AnggiAdnyani/Rescentify/blob/main/assets/gambar/welcome%20page.jpg?raw=true)

Berikut kode untuk memindahkan welcome page  ke login page dengan klik button login:

    onPressed: () { 
	    Navigator.push(context,
		    MaterialPageRoute(builder: (context) =>  LoginPage()));
    },

 - Pada page kedua terdapat login page yang berisikan 2 button yaitu login dan signup, jika user sudah memiliki akun yang tersimpan di dalam firebase maka bisa langsung klik button login yang dimana akan menuju home page 
 - namun jika user belum memiliki akun maka user perlu membuat akun dengan klik button sign up yang dimana akan pindah ke page sign up

![enter image description here](https://github.com/AnggiAdnyani/Rescentify/blob/main/assets/gambar/login%20page.jpg?raw=true)

Berikut kode login page ke aplikasi : 

 

     Future<void> signUserIn(BuildContext context) async {
    try {
      if (emailController.text.isEmpty || passwordController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please fill in both fields')),
        );
        return;
      }

      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } on FirebaseAuthException catch (e) {
      String message;
      if (e.code == 'user-not-found') {
        message = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        message = 'Wrong password provided.';
      } else {
        message = 'An error occurred. Please try again.';
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }}
   
- Pada page sign up digunakan untuk membuat akun yang dimana data yang di isi akan di simpan dalam firebase

![enter image description here](https://github.com/AnggiAdnyani/Rescentify/blob/main/assets/gambar/sign%20up%20page.jpg?raw=true)

Berikut kode untuk menyimpan data user ke firebase :

      Future<void> signUserUp(BuildContext context) async {
      try {
      if (emailController.text.isEmpty ||
          passwordController.text.isEmpty ||
          confirmpasswordController.text.isEmpty ||
          usernameController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please fill in all fields')),
        );
        return;
      }
      if (passwordController.text == confirmpasswordController.text) {
        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );
        // Save user data to Firestore
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user?.uid)
            .set({
          'username': usernameController.text,
          'email': emailController.text,
        });
        // Navigate to homepage if sign-up is successful
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      } else {
        // Show error message if passwords don't match
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Passwords do not match')),
        );
      }
      } on FirebaseAuthException catch (e) {
      // Show an error message if sign-up fails
      String message;
      if (e.code == 'email-already-in-use') {
        message = 'The email address is already in use by another account.';
      } else if (e.code == 'weak-password') {
        message = 'The password provided is too weak.';
      } else {
        message = 'An error occurred. Please try again.';
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
      }
      }

 
- Pada home page terdapat bagian menu dari lilin aromaterapi, pada page ini terdapat fitur seperti map dan tambah orderan.
![enter image description here](https://github.com/AnggiAdnyani/Rescentify/blob/main/assets/gambar/home%20page.jpg?raw=true)

Berikut kode untuk menampilkan data all product yang diambil dari firebase:

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


Berikut kode untuk menampilkan data most liked yang diambil dari firebase:  

        return StreamBuilder(
      // Query untuk mengambil data dari Firestore yang memiliki field mostliked == true
      stream: FirebaseFirestore.instance
          .collection('products')
          .where('mostliked', isEqualTo: true)
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Text('No most liked products found');
        }

        final products = snapshot.data!.docs;

        return GridView.count(
          crossAxisCount: 2,
          childAspectRatio: 0.65,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          children: products.map((productDoc) {
            final product = productDoc.data() as Map<String, dynamic>;
            final price = product['price'];
            final formattedPrice = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp').format(price);

            return Container(
              padding: const EdgeInsets.only(left: 10, right: 10, top: 5),
              margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 7),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 214, 197, 163),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 237, 251, 252),
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      const Icon(
                        Icons.favorite,
                        color: Colors.red,
                      ),
                    ],
                  ),
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
                        borderRadius: BorderRadius.circular(20),
                        child: Image.network(
                          product['image'],
                          height: 120,
                          width: 200,
                          fit: BoxFit.cover,
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
                    padding: const EdgeInsets.symmetric(vertical: 3),
                    child: ElevatedButton(
                      onPressed: () {
                        addToCart(product);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 250, 251, 242),
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
                  ),
                ],
              ),
            );
          }).toList(),
        );
      },
    );
Berikut kode untuk menambahkan produk yang dipilih kedalam koleksi cart pada firebase: 

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

- Page map dibawah ini digunakan untuk menampilkan lokasi perangkat user dan mencari alamat yang akan dituju serta meminta persetujuan user untuk mengakses lokasi

![enter image description here](https://github.com/AnggiAdnyani/Rescentify/blob/main/assets/gambar/map%20page.jpg?raw=true)

Berikut kode untuk meminta akses fitur gps kepada user: 

     // Memeriksa status izin lokasi
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Location permissions are denied')),
        );
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                'Location permissions are permanently denied, we cannot request permissions')),
      );
      return;
    }

jelasin 

     Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    _center = LatLng(position.latitude, position.longitude);


- Page product detail menampilkan detail produk seperti gambar, judul, harga, dan deskripsi yang dimana di dapatkan melalui firebase (get). Selain itu terdapat fitur button order now yang akan digunakan untuk menambahkan item ke page cart. Serta terdapat fitur kamera untuk user menambahkan review produk.

![enter image description here](https://github.com/AnggiAdnyani/Rescentify/blob/main/assets/gambar/description%20page.jpg?raw=true)


Berikut kode untuk menampilkan detail produk berupa gambar, nama produk, deskripsi, dan harga: 

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


- Pada page ini menampilkan fittur kamera

![enter image description here](https://github.com/AnggiAdnyani/Rescentify/blob/main/assets/gambar/camera%20page.jpg?raw=true)

Berikut kode untuk menginisialisasikan kamera yang tersedia pada device 

      Future<void> _initializeCamera() async {
    cameras = await availableCameras();
    final firstCamera = cameras.first;

    _controller = CameraController(
      firstCamera,
      ResolutionPreset.high,
    );

    _initializeControllerFuture = _controller!.initialize();
    setState(() {});  
    }
Berikut kode untuk mengambil foto dan menyimpannya pada device:

      Future<void> _takePicture() async {
    try {
      await _initializeControllerFuture;
      final directory = await getApplicationDocumentsDirectory();
      final imagePath = '${directory.path}/${DateTime.now()}.png';
      final image = await _controller?.takePicture();

      if (image != null) {
        final File imageFile = File(image.path);
        await imageFile.copy(imagePath);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Picture saved to $imagePath')),
        );
      }
    } catch (e) {
      print(e);
    }
    }


- Page selanjutnya yaitu page cart yang dimana fitur pada page cart ini terdapat tampilan  produk yang telah di tambahkan, dan di page ini produk yang telah di tambahkan dapat juga di kurangi 

![enter image description here](https://github.com/AnggiAdnyani/Rescentify/blob/main/assets/gambar/cart%20page.jpg?raw=true)

Berikut kode untuk mengurangi kuantitas dari produk yang ada pada cart:

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
Berikut kode untuk menambahkan kuantitas dari produk yang ada pada cart:

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
   
   Berikut kode untuk menampilkan produk yang ada pada cart yang diambil pada firebase:
   

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



## Instalasi Guide 

 1. Buatlah sebuah folder dengan nama sesuai keinginan Anda.
 2. Buka aplikasi Visual Studio Code.
 3. Buka folder yang baru saja Anda buat di dalam Visual Studio Code.
 4. Jalankan terminal.
 5. Di terminal, ketik perintah berikut dan tekan enter: `git clone https://github.com/AnggiAdnyani/Rescentify.git`.
 6. Sekarang, buka folder hasil clone (healthCare). Folder ini seharusnya berada di dalam folder yang Anda buat di langkah pertama.
 7. Setelah folder hasil clone terbuka, jalankan terminal kembali dan ketik `flutter pub get`.
 8. Selesai, aplikasi sekarang siap dijalankan melalui file `main.dart`.

## Link Youtube
https://youtu.be/Tz_6fsEhspk?si=jIdH-DdAgxZo7ayJ


