import 'package:flutter_test/flutter_test.dart';
import 'package:color_match/main.dart';

void main() {
  testWidgets('Match Color home page loads', (tester) async {
    await tester.pumpWidget(const MatchColorApp());

    expect(find.text('Match Color'), findsOneWidget);
    expect(find.text('เริ่มเล่นเกม'), findsOneWidget);
    expect(find.text('ผู้จัดทำ'), findsOneWidget);
  });
}