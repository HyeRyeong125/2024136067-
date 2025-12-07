import 'package:bamtol_market_app/src/models/product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.toNamed('/product-detail', arguments: product);
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProductImage(),
            const SizedBox(width: 16),
            Expanded(
              child: _buildProductInfo(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductImage() {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: const Color(0xff2F3135),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.asset(
          product.imagePath,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return const Center(
              child: Icon(
                Icons.image,
                color: Color(0xff868B94),
                size: 40,
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildProductInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          product.title,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        Text(
          '${product.location} · ${product.timeAgo}',
          style: const TextStyle(
            fontSize: 13,
            color: Color(0xff868B94),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          product.price,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            if (product.chatCount > 0) ...[
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
              const SizedBox(width: 8),
            ],
            if (product.likeCount > 0) ...[
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
          ],
        ),
      ],
    );
  }
}
