import 'package:bamtol_market_app/src/controllers/search_controller.dart'
    as search;
import 'package:bamtol_market_app/src/widgets/product_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchPage extends GetView<search.SearchController> {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Obx(
        () => controller.isSearching.value
            ? _buildSearchResults()
            : _buildRecentSearches(),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Get.back(),
      ),
      title: TextField(
        autofocus: true,
        onChanged: controller.onSearchQueryChanged,
        onSubmitted: controller.performSearch,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: '검색어를 입력하세요',
          hintStyle: const TextStyle(color: Color(0xff868B94)),
          border: InputBorder.none,
          suffixIcon: Obx(
            () => controller.searchQuery.value.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear, color: Color(0xff868B94)),
                    onPressed: controller.clearSearch,
                  )
                : const SizedBox.shrink(),
          ),
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.search, color: Colors.white),
          onPressed: () {
            if (controller.searchQuery.value.isNotEmpty) {
              controller.performSearch(controller.searchQuery.value);
            }
          },
        ),
      ],
    );
  }

  Widget _buildRecentSearches() {
    return Obx(
      () => controller.recentSearches.isEmpty
          ? const Center(
              child: Text(
                '최근 검색어가 없습니다',
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xff868B94),
                ),
              ),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        '최근 검색어',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      TextButton(
                        onPressed: controller.clearAllRecentSearches,
                        child: const Text(
                          '전체 삭제',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xff868B94),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: controller.recentSearches.length,
                    itemBuilder: (context, index) {
                      final query = controller.recentSearches[index];
                      return ListTile(
                        leading: const Icon(
                          Icons.history,
                          color: Color(0xff868B94),
                        ),
                        title: Text(
                          query,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                        trailing: IconButton(
                          icon: const Icon(
                            Icons.close,
                            color: Color(0xff868B94),
                          ),
                          onPressed: () => controller.removeRecentSearch(query),
                        ),
                        onTap: () => controller.performSearch(query),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildSearchResults() {
    return Column(
      children: [
        _buildSortOptions(),
        const Divider(height: 1, thickness: 1, color: Color(0xff2F3135)),
        Expanded(
          child: Obx(
            () => controller.searchResults.isEmpty
                ? const Center(
                    child: Text(
                      '검색 결과가 없습니다',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xff868B94),
                      ),
                    ),
                  )
                : ListView.separated(
                    itemCount: controller.searchResults.length,
                    separatorBuilder: (context, index) => const Divider(
                      height: 1,
                      thickness: 1,
                      color: Color(0xff2F3135),
                    ),
                    itemBuilder: (context, index) {
                      final product = controller.searchResults[index];
                      return ProductCard(product: product);
                    },
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildSortOptions() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Obx(
            () => Text(
              '검색결과 ${controller.searchResults.length}개',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.white,
              ),
            ),
          ),
          const Spacer(),
          Obx(
            () => PopupMenuButton<search.SortType>(
              color: const Color(0xff2F3135),
              onSelected: controller.changeSortType,
              child: Row(
                children: [
                  Text(
                    controller.getSortTypeLabel(controller.currentSort.value),
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(
                    Icons.arrow_drop_down,
                    color: Colors.white,
                  ),
                ],
              ),
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: search.SortType.latest,
                  child: Text(
                    controller.getSortTypeLabel(search.SortType.latest),
                    style: TextStyle(
                      color: controller.currentSort.value == search.SortType.latest
                          ? const Color(0xffFF6F0F)
                          : Colors.white,
                    ),
                  ),
                ),
                PopupMenuItem(
                  value: search.SortType.lowPrice,
                  child: Text(
                    controller.getSortTypeLabel(search.SortType.lowPrice),
                    style: TextStyle(
                      color: controller.currentSort.value == search.SortType.lowPrice
                          ? const Color(0xffFF6F0F)
                          : Colors.white,
                    ),
                  ),
                ),
                PopupMenuItem(
                  value: search.SortType.highPrice,
                  child: Text(
                    controller.getSortTypeLabel(search.SortType.highPrice),
                    style: TextStyle(
                      color: controller.currentSort.value == search.SortType.highPrice
                          ? const Color(0xffFF6F0F)
                          : Colors.white,
                    ),
                  ),
                ),
                PopupMenuItem(
                  value: search.SortType.popular,
                  child: Text(
                    controller.getSortTypeLabel(search.SortType.popular),
                    style: TextStyle(
                      color: controller.currentSort.value == search.SortType.popular
                          ? const Color(0xffFF6F0F)
                          : Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
