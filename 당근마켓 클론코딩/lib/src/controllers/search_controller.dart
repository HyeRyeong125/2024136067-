import 'package:bamtol_market_app/src/models/product.dart';
import 'package:bamtol_market_app/src/controllers/product_list_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum SortType { latest, lowPrice, highPrice, popular }

class SearchController extends GetxController {
  final RxString searchQuery = ''.obs;
  final RxList<Product> searchResults = <Product>[].obs;
  final RxList<String> recentSearches = <String>[].obs;
  final Rx<SortType> currentSort = SortType.latest.obs;
  final RxBool isSearching = false.obs;

  final ProductListController _productListController = Get.find();

  @override
  void onInit() {
    super.onInit();
    _loadRecentSearches();
  }

  void _loadRecentSearches() {
    // 실제로는 SharedPreferences 등에서 불러옴
    recentSearches.value = [
      '아이폰',
      '인형',
      '코트',
      '아이패드',
    ];
  }

  void onSearchQueryChanged(String query) {
    searchQuery.value = query;
  }

  void performSearch(String query) {
    if (query.trim().isEmpty) return;

    isSearching.value = true;
    searchQuery.value = query;

    // 최근 검색어에 추가
    if (!recentSearches.contains(query)) {
      recentSearches.insert(0, query);
      if (recentSearches.length > 10) {
        recentSearches.removeLast();
      }
    }

    // 검색 수행
    searchResults.value = _productListController.productList
        .where((product) =>
            product.title.toLowerCase().contains(query.toLowerCase()))
        .toList();

    // 정렬 적용
    _applySorting();
  }

  void clearSearch() {
    searchQuery.value = '';
    searchResults.clear();
    isSearching.value = false;
  }

  void removeRecentSearch(String query) {
    recentSearches.remove(query);
  }

  void clearAllRecentSearches() {
    Get.dialog(
      AlertDialog(
        backgroundColor: const Color(0xff2F3135),
        title: const Text(
          '최근 검색어 전체 삭제',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          '최근 검색어를 모두 삭제하시겠습니까?',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () {
              recentSearches.clear();
              Get.back();
            },
            child: const Text('확인'),
          ),
        ],
      ),
    );
  }

  void changeSortType(SortType type) {
    currentSort.value = type;
    _applySorting();
  }

  void _applySorting() {
    switch (currentSort.value) {
      case SortType.latest:
        // 최신순 (기본 순서)
        break;
      case SortType.lowPrice:
        searchResults.sort((a, b) {
          final priceA = _extractPrice(a.price);
          final priceB = _extractPrice(b.price);
          return priceA.compareTo(priceB);
        });
        break;
      case SortType.highPrice:
        searchResults.sort((a, b) {
          final priceA = _extractPrice(a.price);
          final priceB = _extractPrice(b.price);
          return priceB.compareTo(priceA);
        });
        break;
      case SortType.popular:
        searchResults.sort((a, b) {
          return (b.likeCount + b.chatCount)
              .compareTo(a.likeCount + a.chatCount);
        });
        break;
    }
    searchResults.refresh();
  }

  int _extractPrice(String priceString) {
    // "1,200,000원" -> 1200000
    final numbers = priceString.replaceAll(RegExp(r'[^0-9]'), '');
    return int.tryParse(numbers) ?? 0;
  }

  String getSortTypeLabel(SortType type) {
    switch (type) {
      case SortType.latest:
        return '최신순';
      case SortType.lowPrice:
        return '낮은 가격순';
      case SortType.highPrice:
        return '높은 가격순';
      case SortType.popular:
        return '인기순';
    }
  }
}
