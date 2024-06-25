import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class Maps extends StatefulWidget {
  const Maps({super.key});

  @override
  _MapsState createState() => _MapsState();
}

class _MapsState extends State<Maps> {
  final MapController _mapController = MapController();
  LatLng _center = const LatLng(-8.409518, 115.188919); // Lokasi awal (Bali)
  final TextEditingController _searchController = TextEditingController();
  final List<Marker> _markers = []; // List untuk menyimpan marker

  // Method untuk meluncurkan URL
  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      throw 'Could not launch $url';
    }
  }

  // Method untuk mencari lokasi dari alamat
  Future<void> _searchLocation() async {
    final query =
        _searchController.text.trim(); // Menghilangkan spasi di awal dan akhir
    if (query.isEmpty) {
      return; // Menghindari pencarian jika input kosong
    }

    try {
      List<Location> locations = await locationFromAddress(query);
      if (locations.isNotEmpty) {
        final location = locations.first;
        _center = LatLng(location.latitude, location.longitude);
        _mapController.move(
            _center, 17.0); // Pindah dan zoom ke lokasi yang dicari

        // Tambahkan marker ke lokasi yang dicari
        setState(() {
          _markers.clear();
          _markers.add(
            Marker(
              child: const Icon(
                Icons.location_pin,
                color: Colors.red,
                size: 40.0,
              ),
              width: 80.0,
              height: 80.0,
              point: _center,
            ),
          );
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not find location for: $query')),
        );
      }
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error finding location: $e')),
      );
    }
  }

  // Method untuk mendapatkan lokasi terkini
  Future<void> _getCurrentLocation() async {
    print("Getting current location...");
    bool serviceEnabled;
    LocationPermission permission;

    // Memeriksa apakah layanan lokasi diaktifkan
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: const Text(
                'Location services are disabled. Please enable the services')),
      );
      return;
    }

    // Memeriksa status izin lokasi
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location permissions are denied')),
        );
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
                'Location permissions are permanently denied, we cannot request permissions')),
      );
      return;
    }

    // Mendapatkan lokasi terkini
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    _center = LatLng(position.latitude, position.longitude);

    // Pindah dan zoom ke lokasi terkini
    _mapController.move(_center, 17.0);

    // Tambahkan marker ke lokasi terkini
    setState(() {
      _markers.clear();
      _markers.add(
        Marker(
          child: const Icon(
            Icons.location_pin,
            color: Colors.blue,
            size: 40.0,
          ),
          width: 80.0,
          height: 80.0,
          point: _center,
        ),
      );
    });

    print("Current location: $_center");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Maps",
          style: TextStyle(color: Colors.brown),
        ),
        backgroundColor: Color.fromARGB(255, 253, 253, 253),
        iconTheme: const IconThemeData(color: Colors.brown),
        actions: [
          IconButton(
            icon: const Icon(Icons.my_location),
            onPressed: _getCurrentLocation,
          ),
        ],
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _center,
              initialZoom: 9.2,
              minZoom: 2.0, // Contoh nilai minimum zoom
              maxZoom: 18.0, // Contoh nilai maksimum zoom
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.app',
              ),
              MarkerLayer(
                markers: _markers,
              ),
            ],
          ),
          Positioned(
            bottom: 10,
            right: 10,
            child: GestureDetector(
              onTap: () => _launchURL('https://openstreetmap.org/copyright'),
              child: Container(
                color: Colors.white.withOpacity(0.7),
                padding: const EdgeInsets.all(5),
                child: const Text('OpenStreetMap contributors'),
              ),
            ),
          ),
          Positioned(
            top: 10,
            left: 10,
            right: 10,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search location...',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 0, horizontal: 16),
                    ),
                    onSubmitted: (value) => _searchLocation(),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.search),
                  color: Colors.brown,
                  onPressed: _searchLocation,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
