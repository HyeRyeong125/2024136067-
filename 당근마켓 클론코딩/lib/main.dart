import 'package:bamtol_market_app/src/app.dart';
import 'package:bamtol_market_app/src/controllers/product_detail_controller.dart';
import 'package:bamtol_market_app/src/controllers/write_controller.dart';
import 'package:bamtol_market_app/src/controllers/my_page_controller.dart';
import 'package:bamtol_market_app/src/controllers/search_controller.dart'
    as search;
import 'package:bamtol_market_app/src/pages/product_detail_page.dart';
import 'package:bamtol_market_app/src/pages/chat_list_page.dart';
import 'package:bamtol_market_app/src/pages/chat_room_page.dart';
import 'package:bamtol_market_app/src/pages/write_page.dart';
import 'package:bamtol_market_app/src/pages/category_page.dart';
import 'package:bamtol_market_app/src/pages/my_page.dart';
import 'package:bamtol_market_app/src/pages/profile_edit_page.dart';
import 'package:bamtol_market_app/src/pages/search_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('ko_KR', null);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: '당근마켓 클론코딩',
      initialRoute: '/',
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          elevation: 0,
          color: Color(0xff212123),
          titleTextStyle: TextStyle(
            color: Colors.white,
          ),
        ),
        scaffoldBackgroundColor: const Color(0xff212123),
      ),
      getPages: [
        GetPage(name: '/', page: () => const App()),
        GetPage(
          name: '/product-detail',
          page: () => const ProductDetailPage(),
          binding: BindingsBuilder(() {
            Get.lazyPut(() => ProductDetailController());
          }),
        ),
        GetPage(name: '/chat-list', page: () => const ChatListPage()),
        GetPage(name: '/chat-room', page: () => const ChatRoomPage()),
        GetPage(
          name: '/write',
          page: () => const WritePage(),
          binding: BindingsBuilder(() {
            Get.lazyPut(() => WriteController());
          }),
        ),
        GetPage(name: '/category', page: () => const CategoryPage()),
        GetPage(
          name: '/my-page',
          page: () => const MyPage(),
          binding: BindingsBuilder(() {
            Get.lazyPut(() => MyPageController());
          }),
        ),
        GetPage(name: '/profile-edit', page: () => const ProfileEditPage()),
        GetPage(
          name: '/search',
          page: () => const SearchPage(),
          binding: BindingsBuilder(() {
            Get.lazyPut(() => search.SearchController());
          }),
        ),
      ],
    );
  }
}
