import 'package:bamtol_market_app/src/models/user.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyPageController extends GetxController {
  final Rx<User> user = const User(
    id: '1',
    name: '당근이',
    profileImagePath: '',
    location: '서울 강남구',
    mannerTemperature: 36.5,
    sellCount: 12,
    buyCount: 8,
  ).obs;

  void navigateToProfileEdit() {
    Get.toNamed('/profile-edit', arguments: user.value);
  }

  void updateUserProfile(User updatedUser) {
    user.value = updatedUser;
  }

  void logout() {
    Get.dialog(
      AlertDialog(
        backgroundColor: const Color(0xff2F3135),
        title: const Text(
          '로그아웃',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          '로그아웃 하시겠습니까?',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              Get.snackbar('로그아웃', '로그아웃 되었습니다.');
            },
            child: const Text('확인'),
          ),
        ],
      ),
    );
  }
}
