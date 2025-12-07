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
        title: '애플워치 7세대 팝니다',
        price: '350,000원',
        location: '서울 강남구',
        timeAgo: '1분 전',
        imagePath: 'assets/images/sample_product_1.jpg',
        likeCount: 5,
        chatCount: 3,
      ),
      const Product(
        id: '2',
        title: '아이폰 14 프로 256GB',
        price: '1,200,000원',
        location: '서울 서초구',
        timeAgo: '5분 전',
        imagePath: 'assets/images/sample_product_2.jpg',
        likeCount: 12,
        chatCount: 8,
      ),
      const Product(
        id: '3',
        title: '맥북 프로 16인치 M1',
        price: '2,500,000원',
        location: '서울 송파구',
        timeAgo: '10분 전',
        imagePath: 'assets/images/sample_product_3.jpg',
        likeCount: 20,
        chatCount: 15,
      ),
      const Product(
        id: '4',
        title: '에어팟 프로 2세대',
        price: '200,000원',
        location: '서울 강동구',
        timeAgo: '15분 전',
        imagePath: 'assets/images/sample_product_4.jpg',
        likeCount: 8,
        chatCount: 5,
      ),
      const Product(
        id: '5',
        title: '아이패드 프로 11인치',
        price: '800,000원',
        location: '서울 마포구',
        timeAgo: '30분 전',
        imagePath: 'assets/images/sample_product_5.jpg',
        likeCount: 15,
        chatCount: 10,
      ),
      const Product(
        id: '6',
        title: '삼성 갤럭시 탭 S8',
        price: '650,000원',
        location: '서울 용산구',
        timeAgo: '1시간 전',
        imagePath: 'assets/images/sample_product_6.jpg',
        likeCount: 7,
        chatCount: 4,
      ),
      const Product(
        id: '7',
        title: 'LG 그램 노트북 17인치',
        price: '1,100,000원',
        location: '서울 성동구',
        timeAgo: '2시간 전',
        imagePath: 'assets/images/sample_product_7.jpg',
        likeCount: 10,
        chatCount: 6,
      ),
      const Product(
        id: '8',
        title: '소니 헤드폰 WH-1000XM5',
        price: '350,000원',
        location: '서울 광진구',
        timeAgo: '3시간 전',
        imagePath: 'assets/images/sample_product_8.jpg',
        likeCount: 9,
        chatCount: 7,
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
