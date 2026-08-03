import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:noorix/core/di/service_locator.dart';
import 'package:noorix/main.dart';
import 'package:noorix/presentation/screens/onboarding_screen.dart';

void main() {
  testWidgets('App launches successfully', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({
      OnboardingScreen.preferencesKey: true,
    });
    await ServiceLocator.instance.init();

    await tester.pumpWidget(const NoorixSupportApp());
    await tester.pump();
    await tester.pump();

    expect(find.text('لوحة الأدمن'), findsWidgets);
    expect(find.text('إجمالي العملاء'), findsOneWidget);
  });
}
