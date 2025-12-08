import 'package:bamtol_market_app/src/models/product.dart';
import 'package:get/get.dart';

enum ProductSortType { latest, lowPrice, highPrice, popular }

class ProductListController extends GetxController {
  final RxList<Product> productList = <Product>[].obs;
  final RxList<Product> _originalProductList = <Product>[].obs;
  final Rx<ProductSortType> currentSort = ProductSortType.latest.obs;

  @override
  void onInit() {
    super.onInit();
    _loadProducts();
  }

  void _loadProducts() {
    final products = [
      const Product(
        id: '1',
        title: '블레이저 판매합니다.',
        price: '36,000원',
        location: '서울 송파구',
        timeAgo: '1분 전',
        imagePath: 'assets/images/Blazer.png',
        likeCount: 1,
        chatCount: 0,
      ),
      const Product(
        id: '2',
        title: 'MTB 자전거 급처합니다.',
        price: '200,000원',
        location: '경기 성남시',
        timeAgo: '5분 전',
        imagePath: 'assets/images/MTB_Bike.png',
        likeCount: 8,
        chatCount: 2,
      ),
      const Product(
        id: '3',
        title: '해외 직구로 산 하이큐 인형 판매합니다',
        price: '20,000원',
        location: '서울 강동구',
        timeAgo: '16분 전',
        imagePath: 'assets/images/Haikyu.jpg',
        likeCount: 25,
        chatCount: 1,
      ),
      const Product(
        id: '4',
        title: '프렌치 코트 판매합니다.',
        price: '250,000원',
        location: '경기 수원시',
        timeAgo: '30분 전',
        imagePath: 'assets/images/French_Coat.jpg',
        likeCount: 8,
        chatCount: 5,
      ),
      const Product(
        id: '5',
        title: '아이패드 5세대 판매글입니다.',
        price: '150,000원',
        location: '서울 마포구',
        timeAgo: '30분 전',
        imagePath: 'assets/images/Ipad5.png',
        likeCount: 15,
        chatCount: 10,
      ),
      const Product(
        id: '6',
        title: '아이폰 13 프로 맥스 256GB',
        price: '300,000원',
        location: '서울 용산구',
        timeAgo: '1시간 전',
        imagePath: 'assets/images/Iphone.png',
        likeCount: 21,
        chatCount: 3,
      ),
    ];
    _originalProductList.value = products;
    productList.value = products;
  }

  void changeSortType(ProductSortType type) {
    currentSort.value = type;
    _applySorting();
  }

  void _applySorting() {
    final sortedList = List<Product>.from(_originalProductList);

    switch (currentSort.value) {
      case ProductSortType.latest:
        // 최신순 (기본 순서)
        break;
      case ProductSortType.lowPrice:
        sortedList.sort((a, b) {
          final priceA = _extractPrice(a.price);
          final priceB = _extractPrice(b.price);
          return priceA.compareTo(priceB);
        });
        break;
      case ProductSortType.highPrice:
        sortedList.sort((a, b) {
          final priceA = _extractPrice(a.price);
          final priceB = _extractPrice(b.price);
          return priceB.compareTo(priceA);
        });
        break;
      case ProductSortType.popular:
        sortedList.sort((a, b) {
          return (b.likeCount + b.chatCount)
              .compareTo(a.likeCount + a.chatCount);
        });
        break;
    }

    productList.value = sortedList;
  }

  int _extractPrice(String priceString) {
    final numbers = priceString.replaceAll(RegExp(r'[^0-9]'), '');
    return int.tryParse(numbers) ?? 0;
  }

  String getSortTypeLabel(ProductSortType type) {
    switch (type) {
      case ProductSortType.latest:
        return '최신순';
      case ProductSortType.lowPrice:
        return '낮은 가격순';
      case ProductSortType.highPrice:
        return '높은 가격순';
      case ProductSortType.popular:
        return '인기순';
    }
  }
}
