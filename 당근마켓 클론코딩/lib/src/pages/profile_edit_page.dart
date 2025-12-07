import 'dart:io';
import 'package:bamtol_market_app/src/models/user.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ProfileEditPage extends StatefulWidget {
  const ProfileEditPage({super.key});

  @override
  State<ProfileEditPage> createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  late TextEditingController _nameController;
  late TextEditingController _locationController;
  XFile? _profileImage;
  final ImagePicker _picker = ImagePicker();
  User? _user;

  @override
  void initState() {
    super.initState();
    _user = Get.arguments as User?;
    _nameController = TextEditingController(text: _user?.name ?? '');
    _locationController = TextEditingController(text: _user?.location ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          _profileImage = image;
        });
      }
    } catch (e) {
      Get.snackbar('오류', '이미지를 선택하는 중 오류가 발생했습니다.');
    }
  }

  void _saveProfile() {
    if (_nameController.text.trim().isEmpty) {
      Get.snackbar('알림', '이름을 입력해주세요.');
      return;
    }

    if (_locationController.text.trim().isEmpty) {
      Get.snackbar('알림', '지역을 입력해주세요.');
      return;
    }

    final updatedUser = _user!.copyWith(
      name: _nameController.text.trim(),
      location: _locationController.text.trim(),
      profileImagePath: _profileImage?.path ?? _user!.profileImagePath,
    );

    Get.back(result: updatedUser);
    Get.snackbar('성공', '프로필이 수정되었습니다.');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              _buildProfileImage(),
              const SizedBox(height: 30),
              _buildNameField(),
              const SizedBox(height: 16),
              _buildLocationField(),
              const SizedBox(height: 30),
              _buildSaveButton(),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Get.back(),
      ),
      title: const Text(
        '프로필 수정',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildProfileImage() {
    return GestureDetector(
      onTap: _pickImage,
      child: Stack(
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xff2F3135),
            ),
            child: _profileImage != null
                ? ClipOval(
                    child: Image.file(
                      File(_profileImage!.path),
                      fit: BoxFit.cover,
                      width: 120,
                      height: 120,
                    ),
                  )
                : (_user?.profileImagePath.isNotEmpty ?? false)
                    ? ClipOval(
                        child: Image.asset(
                          _user!.profileImagePath,
                          fit: BoxFit.cover,
                          width: 120,
                          height: 120,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(
                              Icons.person,
                              color: Color(0xff868B94),
                              size: 60,
                            );
                          },
                        ),
                      )
                    : const Icon(
                        Icons.person,
                        color: Color(0xff868B94),
                        size: 60,
                      ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              width: 36,
              height: 36,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xffFF6F0F),
              ),
              child: const Icon(
                Icons.camera_alt,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNameField() {
    return TextField(
      controller: _nameController,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: '이름',
        labelStyle: const TextStyle(color: Color(0xff868B94)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xff2F3135)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xffFF6F0F)),
        ),
        filled: true,
        fillColor: const Color(0xff2F3135),
      ),
    );
  }

  Widget _buildLocationField() {
    return TextField(
      controller: _locationController,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: '지역',
        labelStyle: const TextStyle(color: Color(0xff868B94)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xff2F3135)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xffFF6F0F)),
        ),
        filled: true,
        fillColor: const Color(0xff2F3135),
      ),
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _saveProfile,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xffFF6F0F),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: const Text(
          '저장',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
