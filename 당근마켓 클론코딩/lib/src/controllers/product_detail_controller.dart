import 'package:bamtol_market_app/src/models/product.dart';
import 'package:get/get.dart';

class ProductDetailController extends GetxController {
  final Rx<Product?> product = Rx<Product?>(null);
  final RxBool isLiked = false.obs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args != null && args is Product) {
      product.value = args;
    }
  }

  void toggleLike() {
    isLiked.value = !isLiked.value;
  }

  void shareProduct() {
    Get.snackbar('공유', '상품을 공유합니다');
  }

  void reportProduct() {
    Get.snackbar('신고', '상품을 신고합니다');
  }

  void startChat() {
    Get.toNamed('/chat-room', arguments: {
      'productId': product.value?.id,
      'sellerName': '판매자',
    });
  }
}
