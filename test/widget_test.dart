import 'package:flutter_test/flutter_test.dart';
import 'package:beautyscan/main.dart';

void main() {
  testWidgets('BeautyScan app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const BeautyScanApp());
    expect(find.byType(BeautyScanApp), findsOneWidget);
  });
}
