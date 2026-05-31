import 'package:flutter_test/flutter_test.dart';

import 'package:noorix/main.dart';
import 'package:noorix/core/di/service_locator.dart';

void main() {
  testWidgets('App launches successfully', (WidgetTester tester) async {
    ServiceLocator.instance.init();
    await tester.pumpWidget(const NoorixSupportApp());
    await tester.pumpAndSettle();

    // Verify the customers screen is displayed with customer data
    expect(find.text('أحمد علي'), findsOneWidget);
    expect(find.text('سارة خالد'), findsOneWidget);
  });
}
