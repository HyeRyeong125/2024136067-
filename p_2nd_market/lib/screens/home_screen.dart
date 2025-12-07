import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import '../models/product.dart';
import '../widgets/product_card.dart';

class HomeScreen extends StatefulWidget {
  // 수정 1: const 생성자 및 key 파라미터 추가
  const HomeScreen({super.key});

  @override
  // 수정 2: 반환 타입을 private(_HomeScreenState)이 아닌 public(State<HomeScreen>)으로 변경
  State<HomeScreen> createState() => _HomeScreenState();
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
      // 수정 3: print -> debugPrint
      debugPrint('🛰️ 현재 위치 좌표: ${position.latitude}, ${position.longitude}');
      
      final locationName = await _getLocationName(position);
      final products = await _fetchNearbyProducts(position);

      // 수정 4: 비동기 작업 후 화면이 살아있는지 확인 (mounted 체크)
      if (!mounted) return;

      setState(() {
        _locationName = locationName;
        _products = products;
        _loading = false;
      });
    } catch (e) {
      debugPrint("🔥 위치 또는 상품 불러오기 실패: $e");
      if (!mounted) return;
      
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
        debugPrint('⚠ placemarks 비어 있음');
        return '${position.latitude.toStringAsFixed(4)}, ${position.longitude.toStringAsFixed(4)}';
      }

      final p = placemarks.first;
      debugPrint('📍 Placemark 전체: $p');

      final area = p.administrativeArea ?? '';
      final locality = p.locality ?? '';
      final subLocality = p.subLocality ?? '';
      final fallback = p.name ?? p.street ?? p.thoroughfare ?? '';

      final composed = '$area $locality $subLocality'.trim();

      if (composed.isNotEmpty) return composed;
      if (fallback.isNotEmpty) return fallback;

      return '${position.latitude.toStringAsFixed(4)}, ${position.longitude.toStringAsFixed(4)}';
    } catch (e) {
      debugPrint("❗ 주소 변환 실패: $e");
      return '${position.latitude.toStringAsFixed(4)}, ${position.longitude.toStringAsFixed(4)}';
    }
  }

  Future<List<Product>> _fetchNearbyProducts(Position userPos) async {
    // 참고: 데이터가 많아지면 클라이언트 필터링보다 GeoFlutterFire 같은 서버 사이드 필터링 권장
    final snapshot = await FirebaseFirestore.instance.collection('products').get();

    return snapshot.docs.where((doc) {
      final data = doc.data();
      if (data['latitude'] == null || data['longitude'] == null) return false;

      // 데이터 타입 안전성 확보 (double 변환)
      final double lat = (data['latitude'] is int) 
          ? (data['latitude'] as int).toDouble() 
          : data['latitude'];
      final double lng = (data['longitude'] is int) 
          ? (data['longitude'] as int).toDouble() 
          : data['longitude'];

      double distance = Geolocator.distanceBetween(
        userPos.latitude,
        userPos.longitude,
        lat,
        lng,
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
                style: const TextStyle(color: Colors.black),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const Icon(Icons.keyboard_arrow_down, color: Colors.black),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      const Text("거리: ", style: TextStyle(fontSize: 16)),
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
                            
                            // 위치 정보 갱신 및 상품 다시 불러오기
                            try {
                              final pos = await _getCurrentPosition();
                              final products = await _fetchNearbyProducts(pos);
                              
                              if (!mounted) return;
                              setState(() {
                                _products = products;
                                _loading = false;
                              });
                            } catch (e) {
                              if (!mounted) return;
                              setState(() => _loading = false);
                            }
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
                              '반경 ${(_selectedDistance / 1000).toStringAsFixed(0)}km 이내 상품이 없습니다.'))
                      : ListView.builder(
                          padding: const EdgeInsets.only(bottom: 80),
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