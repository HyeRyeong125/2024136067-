import 'dart:io';
import 'package:bamtol_market_app/src/controllers/write_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class WritePage extends GetView<WriteController> {
  const WritePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImageSection(),
            const Divider(height: 1, thickness: 1, color: Color(0xff2F3135)),
            _buildTitleSection(),
            const Divider(height: 1, thickness: 1, color: Color(0xff2F3135)),
            _buildCategorySection(),
            const Divider(height: 1, thickness: 1, color: Color(0xff2F3135)),
            _buildPriceSection(),
            const Divider(height: 1, thickness: 1, color: Color(0xff2F3135)),
            _buildDescriptionSection(),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.close, color: Colors.white),
        onPressed: () => Get.back(),
      ),
      title: const Text(
        '중고거래 글쓰기',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      actions: [
        Obx(
          () => TextButton(
            onPressed: controller.canSubmit() ? controller.submit : null,
            child: Text(
              '완료',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: controller.canSubmit()
                    ? const Color(0xffFF6F0F)
                    : const Color(0xff868B94),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildImageSection() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Obx(
            () => SizedBox(
              height: 100,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _buildImageAddButton(),
                  ...controller.imageFiles.asMap().entries.map((entry) {
                    return _buildImageItem(entry.value, entry.key);
                  }),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          Obx(
            () => Text(
              '${controller.imageFiles.length}/10',
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xff868B94),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageAddButton() {
    return GestureDetector(
      onTap: controller.pickImages,
      child: Container(
        width: 100,
        height: 100,
        margin: const EdgeInsets.only(right: 8),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xff868B94)),
          borderRadius: BorderRadius.circular(8),
          color: const Color(0xff2F3135),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/svg/icons/photo_small.svg',
              width: 30,
              height: 30,
            ),
            const SizedBox(height: 4),
            const Text(
              '사진 추가',
              style: TextStyle(
                fontSize: 12,
                color: Color(0xff868B94),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageItem(XFile imageFile, int index) {
    return Container(
      width: 100,
      height: 100,
      margin: const EdgeInsets.only(right: 8),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.file(
              File(imageFile.path),
              width: 100,
              height: 100,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            top: 4,
            right: 4,
            child: GestureDetector(
              onTap: () => controller.removeImage(index),
              child: Container(
                width: 24,
                height: 24,
                decoration: const BoxDecoration(
                  color: Colors.black54,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 16,
                ),
              ),
            ),
          ),
          if (index == 0)
            Positioned(
              bottom: 4,
              left: 4,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xffFF6F0F),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  '대표',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTitleSection() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: TextField(
        onChanged: controller.onTitleChanged,
        style: const TextStyle(color: Colors.white, fontSize: 16),
        decoration: const InputDecoration(
          hintText: '글 제목',
          hintStyle: TextStyle(color: Color(0xff868B94)),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildCategorySection() {
    return InkWell(
      onTap: controller.selectCategory,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Obx(
              () => Text(
                controller.category.value.isEmpty
                    ? '카테고리 선택'
                    : controller.category.value,
                style: TextStyle(
                  fontSize: 16,
                  color: controller.category.value.isEmpty
                      ? const Color(0xff868B94)
                      : Colors.white,
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
    );
  }

  Widget _buildPriceSection() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: TextField(
        onChanged: controller.onPriceChanged,
        keyboardType: TextInputType.number,
        style: const TextStyle(color: Colors.white, fontSize: 16),
        decoration: const InputDecoration(
          hintText: '₩ 가격 (선택사항)',
          hintStyle: TextStyle(color: Color(0xff868B94)),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildDescriptionSection() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: TextField(
        onChanged: controller.onDescriptionChanged,
        maxLines: 10,
        style: const TextStyle(color: Colors.white, fontSize: 16),
        decoration: const InputDecoration(
          hintText:
              '올릴 게시글 내용을 작성해주세요.\n(가품 및 판매금지품목은 게시가 제한될 수 있어요.)',
          hintStyle: TextStyle(color: Color(0xff868B94)),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
