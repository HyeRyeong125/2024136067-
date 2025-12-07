import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';
import 'package:geolocator/geolocator.dart';

// 커스텀 파일들
import '../services/firestore_service.dart';
import '../services/storage_service.dart';
import '../models/product.dart';

// 사용되지 않는 임포트 제거 목록:
// - dart:io
// - dart:typed_data
// - package:flutter/foundation.dart
// - ../utils/location_helper.dart
// - package:cloud_firestore/cloud_firestore.dart

class UploadScreen extends StatefulWidget {
  const UploadScreen({super.key}); // const 생성자 추가 권장

  @override
  _UploadScreenState createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _priceController = TextEditingController();

  List<XFile> _images = [];
  bool _isUploading = false;
  double? latitude;
  double? longitude;

  Future<void> _pickImages() async {
    final ImagePicker picker = ImagePicker();
    final images = await picker.pickMultiImage();
    if (images.isNotEmpty) {
      setState(() {
        _images = images;
      });
    }
  }

  Future<void> _getLocation() async {
    try {
      // Geolocator 패키지를 직접 사용하므로 location_helper.dart 임포트는 불필요했습니다.
      Position pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        latitude = pos.latitude;
        longitude = pos.longitude;
      });
    } catch (e) {
      print("위치 정보를 가져오는 데 실패했습니다: $e");
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate() || _images.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("모든 항목을 입력하고 이미지를 추가하세요.")));
      return;
    }

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print("🔥 로그인된 사용자가 없습니다.");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("로그인 후 다시 시도하세요.")));
      setState(() => _isUploading = false);
      return;
    }

    setState(() => _isUploading = true);

    // 이미지 업로드
    List<String> imageUrls = [];
    for (var img in _images) {
      final url = await StorageService().uploadImage(img);
      if (url != null) {
        imageUrls.add(url);
      }
    }

    if (imageUrls.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("이미지 업로드에 실패했습니다.")));
      setState(() => _isUploading = false);
      return;
    }

    final id = const Uuid().v4();
    final product = Product(
      id: id,
      title: _titleController.text.trim(),
      description: _descController.text.trim(),
      price: int.parse(_priceController.text.trim()),
      imageUrl: imageUrls.first,
      createdAt: DateTime.now(),
      userId: user.uid,
      latitude: latitude,
      longitude: longitude,
    );

    // FirestoreService 내부에서 처리를 담당하므로 cloud_firestore 임포트는 불필요했습니다.
    await FirestoreService().uploadProduct(product);

    setState(() => _isUploading = false);
    if (mounted) {
      // 비동기 작업 후 context 사용 시 mounted 체크 권장
      Navigator.pop(context);
    }
  }

  @override
  void initState() {
    super.initState();
    _getLocation();
  }

  @override
  void dispose() {
    // 컨트롤러 해제 (메모리 누수 방지)
    _titleController.dispose();
    _descController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("상품 등록")),
      body:
          _isUploading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      ElevatedButton(
                        onPressed: _pickImages,
                        child: Text("이미지 선택 (${_images.length}장)"),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _titleController,
                        decoration: const InputDecoration(labelText: "제목"),
                        validator:
                            (v) => v == null || v.isEmpty ? '제목을 입력하세요' : null,
                      ),
                      TextFormField(
                        controller: _descController,
                        decoration: const InputDecoration(labelText: "설명"),
                        maxLines: 3,
                        validator:
                            (v) => v == null || v.isEmpty ? '설명을 입력하세요' : null,
                      ),
                      TextFormField(
                        controller: _priceController,
                        decoration: const InputDecoration(labelText: "가격"),
                        keyboardType: TextInputType.number,
                        validator:
                            (v) => v == null || v.isEmpty ? '가격을 입력하세요' : null,
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _submit,
                        child: const Text("상품 등록"),
                      ),
                    ],
                  ),
                ),
              ),
    );
  }
}
