import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:pam_p9_2026_ifs23040/main.dart';

void main() {
  testWidgets('shows login screen', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});

    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    expect(find.text('Login Admin'), findsOneWidget);
    expect(find.text('Login'), findsOneWidget);
  });
}
