import 'package:flutter_test/flutter_test.dart';
import 'package:omni_clean/main.dart';

void main() {
  testWidgets('App loads', (WidgetTester tester) async {
    await tester.pumpWidget(const OmniCleanApp());
  });
}