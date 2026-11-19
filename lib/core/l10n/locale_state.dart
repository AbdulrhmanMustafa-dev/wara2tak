part of 'locale_cubit.dart';

/// LocaleState represents the current locale state
sealed class LocaleState extends Equatable {
  const LocaleState();

  /// Initial state before loading saved locale
  const factory LocaleState.initial() = LocaleInitial;

  /// Locale loaded (from preferences or changed by user)
  const factory LocaleState.loaded(Locale locale) = LocaleLoaded;
}

class LocaleInitial extends LocaleState {
  const LocaleInitial();

  @override
  List<Object?> get props => [];
}

class LocaleLoaded extends LocaleState {
  final Locale locale;
  const LocaleLoaded(this.locale);

  @override
  List<Object?> get props => [locale];
}