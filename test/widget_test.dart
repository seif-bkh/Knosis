import 'package:flutter_test/flutter_test.dart';

import 'package:knosis/main.dart';

void main() {
  testWidgets('shows the Knosis tagline', (WidgetTester tester) async {
    await tester.pumpWidget(const KnosisApp());

    expect(find.text('From words to worlds.'), findsOneWidget);
  });
}
