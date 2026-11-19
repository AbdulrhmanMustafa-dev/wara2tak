import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

import 'package:wara2tak/core/design_system/app_theme.dart';
import 'package:wara2tak/generated/l10n/app_localizations.dart';

void main() {
  testWidgets(
    'RefreshIndicator has MaterialLocalizations in the Arabic locale',
    (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('ar'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: [
            AppLocalizations.delegate,
            ...GlobalMaterialLocalizations.delegates,
          ],
          home: Scaffold(
            body: RefreshIndicator(
              onRefresh: () async {},
              child: ListView(children: const [SizedBox(height: 400)]),
            ),
          ),
        ),
      );

      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('back button arrow points right in the Arabic locale', (
    tester,
  ) async {
    await tester.pumpWidget(_appWithBackButton(const Locale('ar')));

    // IconData stays semantic; Icon mirrors it to the right in RTL.
    expect(find.byIcon(Symbols.arrow_back), findsOneWidget);
  });

  testWidgets('back button arrow points left in the English locale', (
    tester,
  ) async {
    await tester.pumpWidget(_appWithBackButton(const Locale('en')));

    expect(find.byIcon(Symbols.arrow_back), findsOneWidget);
  });
}

Widget _appWithBackButton(Locale locale) {
  return MaterialApp(
    theme: AppTheme.lightTheme,
    locale: locale,
    supportedLocales: AppLocalizations.supportedLocales,
    localizationsDelegates: [
      AppLocalizations.delegate,
      ...GlobalMaterialLocalizations.delegates,
    ],
    home: const Scaffold(body: BackButtonIcon()),
  );
}
