import 'package:apack/constants.dart';
import 'package:apack/model/theme.dart';
import 'package:apack/providers.dart';
import 'package:apack/view/about.dart';
import 'package:apack/view/format_conversion.dart';
import 'package:apack/view/home.dart';
import 'package:apack/view/setting.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_acrylic/flutter_acrylic.dart' as flutter_acrylic;
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:system_theme/system_theme.dart';
import 'package:url_strategy/url_strategy.dart';

bool get isDesktop {
  if (kIsWeb) return false;
  return [
    TargetPlatform.windows,
    TargetPlatform.linux,
    TargetPlatform.macOS,
  ].contains(defaultTargetPlatform);
}

late bool darkMode;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  setPathUrlStrategy();

  if (defaultTargetPlatform == TargetPlatform.windows ||
      defaultTargetPlatform == TargetPlatform.android ||
      kIsWeb) {
    darkMode = await SystemTheme.darkMode;
    await SystemTheme.accentInstance.load();
  } else {
    darkMode = true;
  }
  if (!kIsWeb &&
      [TargetPlatform.windows, TargetPlatform.linux]
          .contains(defaultTargetPlatform)) {
    await flutter_acrylic.Window.initialize();
  }

  runApp(ProviderScope(child: ApackApp()));

  if (isDesktop) {
    doWhenWindowReady(() {
      final win = appWindow;
      win.minSize = const Size(410, 540);
      win.size = const Size(755, 545);
      win.alignment = Alignment.center;
      win.title = appTitle;
      win.show();
    });
  }
}

class ApackApp extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appTheme = ref.watch(appThemeProvider.state).state;
    return FluentApp(
      debugShowCheckedModeBanner: false,
      title: appTitle,
      themeMode: appTheme.mode,
      theme: ThemeData(
        accentColor: appTheme.color,
        brightness: appTheme.mode == ThemeMode.system
            ? darkMode
                ? Brightness.dark
                : Brightness.light
            : appTheme.mode == ThemeMode.dark
                ? Brightness.dark
                : Brightness.light,
        visualDensity: VisualDensity.standard,
        focusTheme: FocusThemeData(
          glowFactor: is10footScreen() ? 2.0 : 0.0,
        ),
      ),
      initialRoute: '/',
      routes: {'/': (_) => NavSideView()},
    );
  }
}

class NavSideView extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(paneIndexProvider.state).state;
    final remainCount = ref.watch(remainingItemCountProvider.state).state;
    final appTheme = ref.watch(appThemeProvider.state).state;

    return NavigationView(
      pane: NavigationPane(
        selected: selectedIndex,
        onChanged: (newIndex) {
          ref.read(paneIndexProvider.state).state = newIndex;
        },
        displayMode: PaneDisplayMode.auto,
        items: [
          PaneItem(
              icon: const Icon(FluentIcons.fabric_picture_library),
              title: const Text("Reduce Size"),
              infoBadge: remainCount > 0
                  ? InfoBadge(
                      source: Text('$selectedIndex'),
                    )
                  : null),
          PaneItem(
            icon: const Icon(FluentIcons.edit_photo),
            title: const Text("Format Conversion"),
          ),
          PaneItem(
            icon: const Icon(FluentIcons.settings),
            title: const Text("Setting"),
          ),
          PaneItem(
            icon: const Icon(FluentIcons.info),
            title: const Text("About"),
          )
        ],
      ),
      content: NavigationBody(
        index: selectedIndex,
        children: const [
          HomeView(),
          FormatConversionView(),
          SettingView(),
          AboutView(),
        ],
      ),
    );
  }
}
