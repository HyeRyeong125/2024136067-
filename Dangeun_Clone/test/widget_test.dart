import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:p_2nd_market/main.dart';

void main() {
  testWidgets('앱이 정상적으로 실행되고 홈 화면이 표시되는지 테스트', (WidgetTester tester) async {
    // 앱 위젯 빌드
    await tester.pumpWidget(MyApp());

    // 홈 화면에 특정 텍스트나 위젯이 표시되는지 확인
    // 예: '홈', '채팅', '등록', '내정보' 탭이 있는지 테스트
    expect(find.text('홈'), findsOneWidget);
    expect(find.byIcon(Icons.home), findsOneWidget);
    expect(find.byType(BottomNavigationBar), findsOneWidget);
  });
}
