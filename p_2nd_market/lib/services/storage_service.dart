import 'dart:typed_data';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String?> uploadImage(XFile xfile) async {
    try {
      final fileName = const Uuid().v4();
      final ref = _storage.ref().child('product_images/$fileName.jpg');

      UploadTask uploadTask;

      print("[📦 Storage] 업로드 시작: $fileName");

      if (kIsWeb) {
        Uint8List data = await xfile.readAsBytes();
        uploadTask = ref.putData(data);
      } else {
        final file = File(xfile.path);
        uploadTask = ref.putFile(file);
      }

      TaskSnapshot snapshot = await uploadTask;

      print("[✅] 업로드 완료");

      // 수정 1: snapshot.ref는 절대 null이 아니므로 null 체크 제거함
      final storageRef = snapshot.ref;

      final url = await storageRef.getDownloadURL();

      // 수정 2: url은 String 타입이므로 null이 될 수 없음. 빈 문자열인지만 체크
      if (url.isEmpty) {
        print("🔥 getDownloadURL이 빈 문자열입니다.");
        return null;
      }

      print("[🔗] 다운로드 URL: $url");
      return url;
    } catch (e, stack) {
      print('이미지 업로드 실패: $e');
      print(stack);
      return null;
    }
  }

  Future<void> deleteImage(String imageUrl) async {
    try {
      final ref = _storage.refFromURL(imageUrl);
      await ref.delete();
      print("[🗑️] 이미지 삭제 완료: $imageUrl");
    } catch (e) {
      print('이미지 삭제 실패: $e');
    }
  }
}
