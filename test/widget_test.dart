import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_state_management_showcase/main.dart';

void main() {
  testWidgets('App launches with example selector',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: App()),
    );

    expect(find.text('State Management'), findsOneWidget);
    expect(find.text('BLoC'), findsNWidgets(2));
    expect(find.text('Cubit'), findsOneWidget);
    expect(find.text('Riverpod'), findsOneWidget);
  });
}
