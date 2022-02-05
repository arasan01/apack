import 'package:apack/model/theme.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_acrylic/flutter_acrylic.dart' as flutter_acrylic;

final paneIndexProvider = StateProvider<int>((ref) => 0);
final remainingItemCountProvider = StateProvider<int>((ref) => 0);
final appThemeProvider =
    StateProvider<AppTheme>((ref) => AppTheme(color: systemAccentColor));
