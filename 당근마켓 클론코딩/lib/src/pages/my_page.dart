import 'package:bamtol_market_app/src/controllers/my_page_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyPage extends GetView<MyPageController> {
  const MyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildProfileSection(),
            const Divider(height: 1, thickness: 8, color: Color(0xff2F3135)),
            _buildMyActivitySection(),
            const Divider(height: 1, thickness: 8, color: Color(0xff2F3135)),
            _buildSettingsSection(),
          ],
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
        '나의 당근',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.settings, color: Colors.white),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildProfileSection() {
    return Obx(
      () => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xff2F3135),
                  ),
                  child: controller.user.value.profileImagePath.isEmpty
                      ? const Icon(
                          Icons.person,
                          color: Color(0xff868B94),
                          size: 40,
                        )
                      : ClipOval(
                          child: Image.asset(
                            controller.user.value.profileImagePath,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(
                                Icons.person,
                                color: Color(0xff868B94),
                                size: 40,
                              );
                            },
                          ),
                        ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        controller.user.value.name,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        controller.user.value.location,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xff868B94),
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.arrow_forward_ios,
                    color: Color(0xff868B94),
                    size: 20,
                  ),
                  onPressed: controller.navigateToProfileEdit,
                ),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xff2F3135),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      Text(
                        '${controller.user.value.mannerTemperature}°C',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xffFF6F0F),
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        '매너온도',
                        style: TextStyle(
                          fontSize: 13,
                          color: Color(0xff868B94),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: 1,
                    height: 40,
                    color: const Color(0xff3A3D44),
                  ),
                  Column(
                    children: [
                      Text(
                        '${controller.user.value.sellCount}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        '판매',
                        style: TextStyle(
                          fontSize: 13,
                          color: Color(0xff868B94),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: 1,
                    height: 40,
                    color: const Color(0xff3A3D44),
                  ),
                  Column(
                    children: [
                      Text(
                        '${controller.user.value.buyCount}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        '구매',
                        style: TextStyle(
                          fontSize: 13,
                          color: Color(0xff868B94),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMyActivitySection() {
    return Column(
      children: [
        _buildMenuItem(
          icon: Icons.receipt_long,
          title: '판매내역',
          onTap: () {},
        ),
        _buildMenuItem(
          icon: Icons.shopping_bag,
          title: '구매내역',
          onTap: () {},
        ),
        _buildMenuItem(
          icon: Icons.favorite_border,
          title: '관심목록',
          onTap: () {},
        ),
      ],
    );
  }

  Widget _buildSettingsSection() {
    return Column(
      children: [
        _buildMenuItem(
          icon: Icons.notifications_outlined,
          title: '알림설정',
          onTap: () {},
        ),
        _buildMenuItem(
          icon: Icons.help_outline,
          title: '고객센터',
          onTap: () {},
        ),
        _buildMenuItem(
          icon: Icons.info_outline,
          title: '앱 정보',
          onTap: () {},
        ),
        _buildMenuItem(
          icon: Icons.logout,
          title: '로그아웃',
          onTap: controller.logout,
          showDivider: false,
        ),
      ],
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool showDivider = true,
  }) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: Colors.white,
                  size: 24,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios,
                  color: Color(0xff868B94),
                  size: 16,
                ),
              ],
            ),
          ),
          if (showDivider)
            const Divider(
              height: 1,
              thickness: 1,
              color: Color(0xff2F3135),
              indent: 56,
            ),
        ],
      ),
    );
  }
}
