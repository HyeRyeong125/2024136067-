import 'package:bamtol_market_app/src/controllers/product_detail_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class ProductDetailPage extends GetView<ProductDetailController> {
  const ProductDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Obx(() {
        final product = controller.product.value;
        if (product == null) {
          return const Center(
            child: Text(
              '상품 정보를 불러올 수 없습니다',
              style: TextStyle(color: Colors.white),
            ),
          );
        }

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProductImage(product.imagePath),
              _buildSellerInfo(),
              const Divider(height: 1, thickness: 1, color: Color(0xff2F3135)),
              _buildProductInfo(product),
              const Divider(height: 1, thickness: 1, color: Color(0xff2F3135)),
              _buildProductDescription(),
            ],
          ),
        );
      }),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Get.back(),
      ),
      actions: [
        IconButton(
          icon: SvgPicture.asset(
            'assets/svg/icons/share.svg',
            width: 24,
            height: 24,
          ),
          onPressed: controller.shareProduct,
        ),
        IconButton(
          icon: SvgPicture.asset(
            'assets/svg/icons/more_vertical.svg',
            width: 24,
            height: 24,
          ),
          onPressed: () {
            Get.bottomSheet(
              Container(
                decoration: const BoxDecoration(
                  color: Color(0xff2F3135),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                child: SafeArea(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        title: const Text(
                          '이 게시글 신고하기',
                          style: TextStyle(color: Colors.white),
                        ),
                        onTap: () {
                          Get.back();
                          controller.reportProduct();
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildProductImage(String imagePath) {
    return Container(
      width: double.infinity,
      height: 300,
      color: const Color(0xff2F3135),
      child: Image.asset(
        imagePath,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return const Center(
            child: Icon(
              Icons.image,
              color: Color(0xff868B94),
              size: 80,
            ),
          );
        },
      ),
    );
  }

  Widget _buildSellerInfo() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xff2F3135),
            ),
            child: const Icon(
              Icons.person,
              color: Color(0xff868B94),
              size: 30,
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '판매자닉네임',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  '서울 강남구',
                  style: TextStyle(
                    fontSize: 13,
                    color: Color(0xff868B94),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xff868B94)),
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Text(
              '매너온도 36.5°C',
              style: TextStyle(
                fontSize: 13,
                color: Color(0xff868B94),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductInfo(product) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            product.title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '디지털/가전 · ${product.timeAgo}',
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xff868B94),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            product.price,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Icon(
                Icons.remove_red_eye_outlined,
                size: 16,
                color: Color(0xff868B94),
              ),
              const SizedBox(width: 4),
              const Text(
                '124',
                style: TextStyle(
                  fontSize: 13,
                  color: Color(0xff868B94),
                ),
              ),
              const SizedBox(width: 12),
              SvgPicture.asset(
                'assets/svg/icons/chat.svg',
                width: 16,
                height: 16,
              ),
              const SizedBox(width: 4),
              Text(
                '${product.chatCount}',
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xff868B94),
                ),
              ),
              const SizedBox(width: 12),
              SvgPicture.asset(
                'assets/svg/icons/heart.svg',
                width: 16,
                height: 16,
              ),
              const SizedBox(width: 4),
              Text(
                '${product.likeCount}',
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xff868B94),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProductDescription() {
    return const Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '상품 설명',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 12),
          Text(
            '깨끗하게 사용한 제품입니다.\n직거래, 택배 거래 가능합니다.',
            style: TextStyle(
              fontSize: 15,
              color: Colors.white,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xff212123),
        border: Border(
          top: BorderSide(color: Color(0xff2F3135), width: 1),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Obx(() => IconButton(
                    icon: Icon(
                      controller.isLiked.value
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color:
                          controller.isLiked.value ? Colors.red : Colors.white,
                      size: 28,
                    ),
                    onPressed: controller.toggleLike,
                  )),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton(
                  onPressed: controller.startChat,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xffFF6F0F),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    '채팅하기',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
