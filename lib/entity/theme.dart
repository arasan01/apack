import 'package:apack/variables.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:state_notifier/state_notifier.dart';
import 'package:system_theme/system_theme.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'theme.freezed.dart';

@freezed
class AppTheme with _$AppTheme {
  factory AppTheme({
    @Default(ThemeMode.system) ThemeMode mode,
  }) = _AppTheme;
}

class AppThemeNotifier extends StateNotifier<AppTheme> {
  AppThemeNotifier() : super(AppTheme());

  void update({ThemeMode? mode}) {
    state = state.copyWith(
      mode: mode ?? state.mode,
    );
    store();
  }

  void store() {
    prefs.setString('themeMode', state.mode.name);
  }
}

AccentColor get systemAccentColor {
  if (defaultTargetPlatform == TargetPlatform.windows ||
      defaultTargetPlatform == TargetPlatform.android ||
      kIsWeb) {
    return AccentColor('normal', {
      'darkest': SystemTheme.accentInstance.darkest,
      'darker': SystemTheme.accentInstance.darker,
      'dark': SystemTheme.accentInstance.dark,
      'normal': SystemTheme.accentInstance.accent,
      'light': SystemTheme.accentInstance.light,
      'lighter': SystemTheme.accentInstance.lighter,
      'lightest': SystemTheme.accentInstance.lightest,
    });
  }
  return Colors.blue;
}

extension ThemeModeExt on String {
  ThemeMode toThemeMode() {
    return ThemeMode.values.firstWhere((type) => type.name == this,
        orElse: () => ThemeMode.system);
  }
}
