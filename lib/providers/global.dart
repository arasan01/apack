import 'package:apack/entity/theme.dart';
import 'package:apack/variables.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// NavigationPane selected index
final paneIndexProvider = StateProvider<int>((ref) => 0);

// NavigationPane add badge counter
final remainItemCountProvider = StateProvider<int>((ref) => 0);
final remainInfoBadgeProvider = Provider<InfoBadge?>((ref) {
  final state = ref.watch(remainItemCountProvider.state).state;
  return state > 0
      ? InfoBadge(
          source: Text('$state'),
        )
      : null;
});

// Theme provider
final appThemeProvider = StateNotifierProvider<AppThemeNotifier, AppTheme>(
    (_) => AppThemeNotifier()
      ..update(mode: prefs.getString('themeMode')?.toThemeMode()));
