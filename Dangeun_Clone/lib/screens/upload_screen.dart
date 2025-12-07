import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';
import '../services/firestore_service.dart';
import '../services/storage_service.dart';
import '../utils/location_helper.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product.dart';

class UploadScreen extends StatefulWidget {
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("모든 항목을 입력하고 이미지를 추가하세요.")),
      );
      return;
    }

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print("🔥 로그인된 사용자가 없습니다.");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("로그인 후 다시 시도하세요.")),
      );
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("이미지 업로드에 실패했습니다.")),
      );
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

    await FirestoreService().uploadProduct(product);

    setState(() => _isUploading = false);
    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();
    _getLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("상품 등록")),
      body: _isUploading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              ElevatedButton(
                onPressed: _pickImages,
                child: Text("이미지 선택 (${_images.length}장)"),
              ),
              SizedBox(height: 12),
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(labelText: "제목"),
                validator: (v) =>
                v == null || v.isEmpty ? '제목을 입력하세요' : null,
              ),
              TextFormField(
                controller: _descController,
                decoration: InputDecoration(labelText: "설명"),
                maxLines: 3,
                validator: (v) =>
                v == null || v.isEmpty ? '설명을 입력하세요' : null,
              ),
              TextFormField(
                controller: _priceController,
                decoration: InputDecoration(labelText: "가격"),
                keyboardType: TextInputType.number,
                validator: (v) =>
                v == null || v.isEmpty ? '가격을 입력하세요' : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submit,
                child: Text("상품 등록"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
