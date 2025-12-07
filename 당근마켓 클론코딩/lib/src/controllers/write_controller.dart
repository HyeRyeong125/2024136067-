import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class WriteController extends GetxController {
  final RxList<XFile> imageFiles = <XFile>[].obs;
  final RxString title = ''.obs;
  final RxString category = ''.obs;
  final RxString price = ''.obs;
  final RxString description = ''.obs;
  final ImagePicker _picker = ImagePicker();

  void onTitleChanged(String value) {
    title.value = value;
  }

  void onPriceChanged(String value) {
    price.value = value;
  }

  void onDescriptionChanged(String value) {
    description.value = value;
  }

  void selectCategory() async {
    final result = await Get.toNamed('/category');
    if (result != null && result is String) {
      category.value = result;
    }
  }

  Future<void> pickImages() async {
    if (imageFiles.length >= 10) {
      Get.snackbar('알림', '이미지는 최대 10장까지 선택할 수 있습니다.');
      return;
    }

    try {
      final List<XFile> selectedImages = await _picker.pickMultiImage();
      final remainingSlots = 10 - imageFiles.length;

      if (selectedImages.length > remainingSlots) {
        Get.snackbar('알림', '이미지는 최대 10장까지 선택할 수 있습니다.');
        imageFiles.addAll(selectedImages.take(remainingSlots));
      } else {
        imageFiles.addAll(selectedImages);
      }
    } catch (e) {
      Get.snackbar('오류', '이미지를 선택하는 중 오류가 발생했습니다.');
    }
  }

  void removeImage(int index) {
    imageFiles.removeAt(index);
  }

  bool canSubmit() {
    return imageFiles.isNotEmpty &&
        title.value.trim().isNotEmpty &&
        category.value.isNotEmpty &&
        price.value.trim().isNotEmpty &&
        description.value.trim().isNotEmpty;
  }

  void submit() {
    if (!canSubmit()) {
      Get.snackbar('알림', '모든 항목을 입력해주세요.');
      return;
    }

    // 상품 등록 로직 (실제로는 Firebase 등에 저장)
    Get.snackbar('성공', '상품이 등록되었습니다.');
    Get.back();
  }
}
