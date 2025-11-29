import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import '../models/product.dart';
import '../widgets/product_card.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Product> _products = [];
  bool _loading = true;
  double _selectedDistance = 5000;
  final List<double> _distanceOptions = [1000, 3000, 5000, 10000];
  String _locationName = '내 위치';

  @override
  void initState() {
    super.initState();
    _initializeHomeScreen();
  }

  Future<void> _initializeHomeScreen() async {
    setState(() => _loading = true);
    try {
      final position = await _getCurrentPosition();
      print('🛰️ 현재 위치 좌표: ${position.latitude}, ${position.longitude}');
      final locationName = await _getLocationName(position);
      final products = await _fetchNearbyProducts(position);

      setState(() {
        _locationName = locationName;
        _products = products;
        _loading = false;
      });
    } catch (e) {
      print("🔥 위치 또는 상품 불러오기 실패: $e");
      setState(() {
        _locationName = '위치 불러오기 실패';
        _loading = false;
      });
    }
  }

  Future<Position> _getCurrentPosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception("위치 서비스가 꺼져 있습니다.");
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        throw Exception("위치 권한이 영구적으로 거부되었습니다.");
      }
    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  Future<String> _getLocationName(Position position) async {
    try {
      final placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isEmpty) {
        print('⚠ placemarks 비어 있음');
        return '${position.latitude.toStringAsFixed(4)}, ${position.longitude.toStringAsFixed(4)}';
      }

      final p = placemarks.first;
      print('📍 Placemark 전체: $p');

      final area = p.administrativeArea ?? '';
      final locality = p.locality ?? '';
      final subLocality = p.subLocality ?? '';
      final fallback = p.name ?? p.street ?? p.thoroughfare ?? '';

      final composed = '$area $locality $subLocality'.trim();

      if (composed.isNotEmpty) return composed;
      if (fallback.isNotEmpty) return fallback;

      return '${position.latitude.toStringAsFixed(4)}, ${position.longitude.toStringAsFixed(4)}';
    } catch (e) {
      print("❗ 주소 변환 실패: $e");
      return '${position.latitude.toStringAsFixed(4)}, ${position.longitude.toStringAsFixed(4)}';
    }
  }

  Future<List<Product>> _fetchNearbyProducts(Position userPos) async {
    final snapshot = await FirebaseFirestore.instance.collection('products').get();

    return snapshot.docs.where((doc) {
      final data = doc.data();
      if (data['latitude'] == null || data['longitude'] == null) return false;

      double distance = Geolocator.distanceBetween(
        userPos.latitude,
        userPos.longitude,
        data['latitude'],
        data['longitude'],
      );

      return distance <= _selectedDistance;
    }).map((doc) => Product.fromMap(doc.id, doc.data())).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: Row(
          children: [
            Expanded(
              child: Text(
                _locationName,
                style: TextStyle(color: Colors.black),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Icon(Icons.keyboard_arrow_down, color: Colors.black),
          ],
        ),
        actions: [
          IconButton(icon: Icon(Icons.search, color: Colors.black), onPressed: () {}),
          IconButton(icon: Icon(Icons.notifications_none, color: Colors.black), onPressed: () {}),
        ],
      ),
      body: _loading
          ? Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Text("거리: ", style: TextStyle(fontSize: 16)),
                DropdownButton<double>(
                  value: _selectedDistance,
                  items: _distanceOptions.map((d) {
                    return DropdownMenuItem(
                      value: d,
                      child: Text("${(d / 1000).toStringAsFixed(0)}km"),
                    );
                  }).toList(),
                  onChanged: (value) async {
                    if (value != null) {
                      setState(() {
                        _selectedDistance = value;
                        _loading = true;
                      });
                      final pos = await _getCurrentPosition();
                      final products = await _fetchNearbyProducts(pos);
                      setState(() {
                        _products = products;
                        _loading = false;
                      });
                    }
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: _products.isEmpty
                ? Center(
                child: Text(
                    '반경 ${( _selectedDistance / 1000 ).toStringAsFixed(0)}km 이내 상품이 없습니다.'))
                : ListView.builder(
              padding: EdgeInsets.only(bottom: 80),
              itemCount: _products.length,
              itemBuilder: (context, index) {
                return ProductCard(product: _products[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}
