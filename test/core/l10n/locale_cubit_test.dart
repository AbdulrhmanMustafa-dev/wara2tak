import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:wara2tak/core/l10n/locale_cubit.dart';

void main() {
  group('LocaleCubit', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    tearDown(() {
      SharedPreferences.setMockInitialValues({});
    });

    group('initial state', () {
      test('emits LocaleLoaded with saved locale when preference exists', () async {
        SharedPreferences.setMockInitialValues({'app_locale': 'ar'});
        final prefs = await SharedPreferences.getInstance();

        final cubit = LocaleCubit(prefs);

        // Wait for async initialization
        await Future.delayed(Duration.zero);
        await Future.delayed(Duration.zero);

        expect(cubit.state, isA<LocaleLoaded>());
        expect((cubit.state as LocaleLoaded).locale, const Locale('ar'));
      });

      test('remains LocaleInitial when no preference exists (currentLocale returns default)', () async {
        SharedPreferences.setMockInitialValues({});
        final prefs = await SharedPreferences.getInstance();

        final cubit = LocaleCubit(prefs);

        // Wait for async initialization
        await Future.delayed(Duration.zero);
        await Future.delayed(Duration.zero);

        // State remains LocaleInitial when no saved preference
        expect(cubit.state, isA<LocaleInitial>());
        // But currentLocale returns default
        expect(cubit.currentLocale, const Locale('en'));
      });

      test('remains LocaleInitial when saved locale is unsupported (currentLocale returns default)', () async {
        SharedPreferences.setMockInitialValues({'app_locale': 'fr'});
        final prefs = await SharedPreferences.getInstance();

        final cubit = LocaleCubit(prefs);

        // Wait for async initialization
        await Future.delayed(Duration.zero);
        await Future.delayed(Duration.zero);

        // State remains LocaleInitial when unsupported locale
        expect(cubit.state, isA<LocaleInitial>());
        // But currentLocale returns default
        expect(cubit.currentLocale, const Locale('en'));
      });
    });

    group('changeLocale', () {
      test('changes locale and persists to SharedPreferences', () async {
        SharedPreferences.setMockInitialValues({'app_locale': 'en'});
        final prefs = await SharedPreferences.getInstance();

        final cubit = LocaleCubit(prefs);
        await Future.delayed(Duration.zero);
        await Future.delayed(Duration.zero);

        await cubit.changeLocale('ar');

        expect(cubit.state, isA<LocaleLoaded>());
        expect((cubit.state as LocaleLoaded).locale, const Locale('ar'));
        expect(prefs.getString('app_locale'), 'ar');
      });

      test('does not change locale if unsupported language code provided', () async {
        SharedPreferences.setMockInitialValues({'app_locale': 'en'});
        final prefs = await SharedPreferences.getInstance();

        final cubit = LocaleCubit(prefs);
        await Future.delayed(Duration.zero);
        await Future.delayed(Duration.zero);

        await cubit.changeLocale('fr');

        // State should remain unchanged (still en)
        expect(cubit.state, isA<LocaleLoaded>());
        expect((cubit.state as LocaleLoaded).locale, const Locale('en'));
        expect(prefs.getString('app_locale'), 'en');
      });

      test('does not emit new state if locale is already set to the same value', () async {
        SharedPreferences.setMockInitialValues({'app_locale': 'ar'});
        final prefs = await SharedPreferences.getInstance();

        final cubit = LocaleCubit(prefs);
        await Future.delayed(Duration.zero);
        await Future.delayed(Duration.zero);

        final initialState = cubit.state;
        await cubit.changeLocale('ar');

        // State should remain the same
        expect(cubit.state, same(initialState));
        expect(prefs.getString('app_locale'), 'ar');
      });
    });

    group('toggleLocale', () {
      test('toggles from en to ar', () async {
        SharedPreferences.setMockInitialValues({'app_locale': 'en'});
        final prefs = await SharedPreferences.getInstance();

        final cubit = LocaleCubit(prefs);
        await Future.delayed(Duration.zero);
        await Future.delayed(Duration.zero);

        await cubit.toggleLocale();

        expect(cubit.state, isA<LocaleLoaded>());
        expect((cubit.state as LocaleLoaded).locale, const Locale('ar'));
        expect(prefs.getString('app_locale'), 'ar');
      });

      test('toggles from ar to en', () async {
        SharedPreferences.setMockInitialValues({'app_locale': 'ar'});
        final prefs = await SharedPreferences.getInstance();

        final cubit = LocaleCubit(prefs);
        await Future.delayed(Duration.zero);
        await Future.delayed(Duration.zero);

        await cubit.toggleLocale();

        expect(cubit.state, isA<LocaleLoaded>());
        expect((cubit.state as LocaleLoaded).locale, const Locale('en'));
        expect(prefs.getString('app_locale'), 'en');
      });

      test('toggles from default (en) to ar when no saved preference', () async {
        SharedPreferences.setMockInitialValues({});
        final prefs = await SharedPreferences.getInstance();

        final cubit = LocaleCubit(prefs);
        await Future.delayed(Duration.zero);
        await Future.delayed(Duration.zero);

        await cubit.toggleLocale();

        expect(cubit.state, isA<LocaleLoaded>());
        expect((cubit.state as LocaleLoaded).locale, const Locale('ar'));
        expect(prefs.getString('app_locale'), 'ar');
      });
    });

    group('currentLocale', () {
      test('returns saved locale when available', () async {
        SharedPreferences.setMockInitialValues({'app_locale': 'ar'});
        final prefs = await SharedPreferences.getInstance();

        final cubit = LocaleCubit(prefs);
        await Future.delayed(Duration.zero);
        await Future.delayed(Duration.zero);

        expect(cubit.currentLocale, const Locale('ar'));
      });

      test('returns default locale (en) when no saved preference', () async {
        SharedPreferences.setMockInitialValues({});
        final prefs = await SharedPreferences.getInstance();

        final cubit = LocaleCubit(prefs);
        await Future.delayed(Duration.zero);
        await Future.delayed(Duration.zero);

        expect(cubit.currentLocale, const Locale('en'));
      });
    });

    group('isRtl', () {
      test('returns true for Arabic locale', () async {
        SharedPreferences.setMockInitialValues({'app_locale': 'ar'});
        final prefs = await SharedPreferences.getInstance();

        final cubit = LocaleCubit(prefs);
        await Future.delayed(Duration.zero);
        await Future.delayed(Duration.zero);

        expect(cubit.isRtl, true);
      });

      test('returns false for English locale', () async {
        SharedPreferences.setMockInitialValues({'app_locale': 'en'});
        final prefs = await SharedPreferences.getInstance();

        final cubit = LocaleCubit(prefs);
        await Future.delayed(Duration.zero);
        await Future.delayed(Duration.zero);

        expect(cubit.isRtl, false);
      });
    });

    group('supportedLocales', () {
      test('contains only en and ar', () {
        expect(LocaleCubit.supportedLocales, containsAll([const Locale('en'), const Locale('ar')]));
        expect(LocaleCubit.supportedLocales.length, 2);
      });
    });
  });
}