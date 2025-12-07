import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'firebase_options.dart';

// 화면 파일들
import 'screens/home_screen.dart';
import 'screens/chat_screen.dart';
import 'screens/upload_screen.dart';
import 'screens/my_page_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // 수정: MyApp에 const 추가
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  // 수정 1: key 파라미터 추가 및 const 생성자 선언
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _currentIndex = 0;

  // 탭 화면들
  final List<Widget> _screens = [
    const HomeScreen(), // 이전에 수정한 파일은 const 가능
    ChatScreen(),
    const UploadScreen(), // 이전에 수정한 파일은 const 가능
    MyPageScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: '중고거래 앱',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.orange,
        // 수정 2: 변하지 않는 디자인 요소에 const 추가
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0.5,
        ),
      ),
      // 참고: initialRoute와 home을 같이 쓰면 충돌 날 수 있습니다.
      // 하단 탭을 쓰시려면 home: Scaffold(...)가 우선 적용되도록 initialRoute는 제거하거나
      // 탭 네비게이션 로직에 맞게 조정하는 것이 좋습니다. 일단 문법 오류 위주로 수정했습니다.
      initialRoute: '/home',
      getPages: [
        GetPage(name: '/home', page: () => const HomeScreen()),
        GetPage(name: '/chat', page: () => ChatScreen()),
        GetPage(name: '/upload', page: () => const UploadScreen()),
        GetPage(name: '/mypage', page: () => MyPageScreen()),
      ],
      home: Scaffold(
        body: _screens[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: _currentIndex,
          selectedItemColor: Colors.orange,
          unselectedItemColor: Colors.grey,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          // 수정 3: 아이템 리스트에 const 추가
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: '홈'),
            BottomNavigationBarItem(
              icon: Icon(Icons.chat_bubble_outline),
              label: '채팅',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add_circle_outline),
              label: '글쓰기',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              label: '나의 당근',
            ),
          ],
        ),
      ),
    );
  }
}
