import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:knosis/app/knosis_app.dart';
import 'package:knosis/core/theme/app_colors.dart';
import 'package:knosis/shared/strings/app_strings.dart';

void main() {
  testWidgets('app shell renders the wordmark and tagline', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: KnosisApp()));

    expect(find.text(AppStrings.appName), findsOneWidget);
    expect(find.text(AppStrings.tagline), findsOneWidget);
  });

  testWidgets('app shell paints the paper background', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: KnosisApp()));

    final BuildContext context = tester.element(find.text(AppStrings.appName));

    expect(Theme.of(context).scaffoldBackgroundColor, AppColors.lightPaper);
  });
}
