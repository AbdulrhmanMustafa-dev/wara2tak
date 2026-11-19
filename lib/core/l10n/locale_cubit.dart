import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'locale_state.dart';

/// LocaleCubit manages the app's UI language (en/ar)
/// Persists selection to SharedPreferences for instant launch in saved language
class LocaleCubit extends Cubit<LocaleState> {
  LocaleCubit(this._prefs) : super(const LocaleState.initial()) {
    _loadSavedLocale();
  }

  final SharedPreferences _prefs;
  static const _localeKey = 'app_locale';

  /// Supported app UI languages (only en and ar per design system)
  static const supportedLocales = [Locale('en'), Locale('ar')];

  /// Load saved locale from SharedPreferences
  Future<void> _loadSavedLocale() async {
    final languageCode = _prefs.getString(_localeKey);
    if (languageCode != null) {
      final locale = Locale(languageCode);
      if (_isSupported(locale)) {
        emit(LocaleState.loaded(locale));
      }
    }
  }

  /// Check if locale is supported (en or ar only)
  bool _isSupported(Locale locale) {
    return supportedLocales.any((l) => l.languageCode == locale.languageCode);
  }

  /// Change the app locale and persist it
  Future<void> changeLocale(String languageCode) async {
    final newLocale = Locale(languageCode);
    if (!_isSupported(newLocale)) return;

    final currentState = state;
    if (currentState is LocaleLoaded && currentState.locale == newLocale) {
      return; // No change needed
    }

    await _prefs.setString(_localeKey, languageCode);
    emit(LocaleState.loaded(newLocale));
  }

  /// Get current locale or default to English
  Locale get currentLocale {
    final currentState = state;
    if (currentState is LocaleLoaded) {
      return currentState.locale;
    }
    return const Locale('en');
  }

  /// Check if current locale is RTL
  bool get isRtl => currentLocale.languageCode == 'ar';

  /// Toggle between English and Arabic
  Future<void> toggleLocale() async {
    final current = currentLocale.languageCode;
    final next = current == 'en' ? 'ar' : 'en';
    await changeLocale(next);
  }
}