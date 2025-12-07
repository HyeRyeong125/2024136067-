import 'package:bamtol_market_app/src/controllers/product_list_controller.dart';
import 'package:bamtol_market_app/src/widgets/product_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class ProductListPage extends GetView<ProductListController> {
  const ProductListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Column(
        children: [
          // 정렬 필터
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: const BoxDecoration(
              color: Color(0xff212123),
              border: Border(
                bottom: BorderSide(
                  color: Color(0xff2F3135),
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                const Spacer(),
                Obx(() => PopupMenuButton<ProductSortType>(
                      icon: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            controller.getSortTypeLabel(controller.currentSort.value),
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 4),
                          SvgPicture.asset(
                            'assets/svg/icons/arrow_down.svg',
                            width: 16,
                            height: 16,
                          ),
                        ],
                      ),
                      color: const Color(0xff2F3135),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: ProductSortType.latest,
                          child: Text(
                            '최신순',
                            style: TextStyle(
                              color: controller.currentSort.value == ProductSortType.latest
                                  ? const Color(0xffFF6F0F)
                                  : Colors.white,
                            ),
                          ),
                        ),
                        PopupMenuItem(
                          value: ProductSortType.lowPrice,
                          child: Text(
                            '낮은 가격순',
                            style: TextStyle(
                              color: controller.currentSort.value == ProductSortType.lowPrice
                                  ? const Color(0xffFF6F0F)
                                  : Colors.white,
                            ),
                          ),
                        ),
                        PopupMenuItem(
                          value: ProductSortType.highPrice,
                          child: Text(
                            '높은 가격순',
                            style: TextStyle(
                              color: controller.currentSort.value == ProductSortType.highPrice
                                  ? const Color(0xffFF6F0F)
                                  : Colors.white,
                            ),
                          ),
                        ),
                        PopupMenuItem(
                          value: ProductSortType.popular,
                          child: Text(
                            '인기순',
                            style: TextStyle(
                              color: controller.currentSort.value == ProductSortType.popular
                                  ? const Color(0xffFF6F0F)
                                  : Colors.white,
                            ),
                          ),
                        ),
                      ],
                      onSelected: (ProductSortType type) {
                        controller.changeSortType(type);
                      },
                    )),
              ],
            ),
          ),
          // 상품 목록
          Expanded(
            child: Obx(
              () => ListView.separated(
                itemCount: controller.productList.length,
                separatorBuilder: (context, index) => const Divider(
                  height: 1,
                  thickness: 1,
                  color: Color(0xff2F3135),
                ),
                itemBuilder: (context, index) {
                  final product = controller.productList[index];
                  return ProductCard(product: product);
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.toNamed('/write');
        },
        backgroundColor: const Color(0xffFF6F0F),
        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 28,
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Row(
        children: [
          const Text(
            '내 동네',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 4),
          SvgPicture.asset(
            'assets/svg/icons/arrow_down.svg',
            width: 16,
            height: 16,
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: SvgPicture.asset(
            'assets/svg/icons/search.svg',
            width: 24,
            height: 24,
          ),
          onPressed: () {
            Get.toNamed('/search');
          },
        ),
        IconButton(
          icon: SvgPicture.asset(
            'assets/svg/icons/menu.svg',
            width: 24,
            height: 24,
          ),
          onPressed: () {},
        ),
        IconButton(
          icon: SvgPicture.asset(
            'assets/svg/icons/notification.svg',
            width: 24,
            height: 24,
          ),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Color(0xff2F3135),
            width: 1,
          ),
        ),
      ),
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xff212123),
        selectedItemColor: Colors.white,
        unselectedItemColor: const Color(0xff868B94),
        selectedLabelStyle: const TextStyle(fontSize: 12),
        unselectedLabelStyle: const TextStyle(fontSize: 12),
        currentIndex: 0,
        onTap: (index) {
          if (index == 3) {
            // 채팅 탭
            Get.toNamed('/chat-list');
          } else if (index == 4) {
            // 나의 당근 탭
            Get.toNamed('/my-page');
          }
        },
        items: [
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/svg/icons/home_on.svg',
              width: 24,
              height: 24,
            ),
            label: '홈',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/svg/icons/notes.svg',
              width: 24,
              height: 24,
            ),
            label: '동네생활',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/svg/icons/location.svg',
              width: 24,
              height: 24,
            ),
            label: '내 근처',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/svg/icons/chat.svg',
              width: 24,
              height: 24,
            ),
            label: '채팅',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/svg/icons/user.svg',
              width: 24,
              height: 24,
            ),
            label: '나의 당근',
          ),
        ],
      ),
    );
  }
}
