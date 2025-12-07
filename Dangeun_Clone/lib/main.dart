import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // 추후 사용
import 'firebase_options.dart';
import 'screens/home_screen.dart';
import 'screens/chat_screen.dart';
import 'screens/upload_screen.dart';
import 'screens/my_page_screen.dart';
import 'screens/login_screen.dart'; // 로그인 화면 추가 가정

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyCSaT0vcdKtmYyh6TS7VB5Rl8m48rlvPWc",
      authDomain: "ndmarketfp.firebaseapp.com",
      projectId: "ndmarketfp",
      storageBucket: "ndmarketfp.firebasestorage.app",
      messagingSenderId: "51104552446",
      appId: "1:51104552446:web:b05bf49c418e660a9edcaf",
      measurementId: "G-C4TF790TQQ"
      ),
  );
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    HomeScreen(),
    ChatScreen(),
    UploadScreen(),
    MyPageScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '중고거래 앱',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      // routes, initialRoute 등 확장을 위한 준비
      routes: {
        '/home': (context) => HomeScreen(),
        '/chat': (context) => ChatScreen(),
        '/upload': (context) => UploadScreen(),
        '/mypage': (context) => MyPageScreen(),
        '/login': (context) => LoginScreen(), // 추후 연결
      },
      home: Scaffold(
        body: _screens[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          selectedItemColor: Colors.orange,
          unselectedItemColor: Colors.grey,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: '홈'),
            BottomNavigationBarItem(icon: Icon(Icons.chat), label: '채팅'),
            BottomNavigationBarItem(icon: Icon(Icons.upload), label: '등록'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: '내정보'),
          ],
        ),
      ),
    );
  }
}
