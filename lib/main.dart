import 'package:apack/constants.dart';
import 'package:apack/entity/theme.dart';
import 'package:apack/providers.dart';
import 'package:apack/view/about.dart';
import 'package:apack/view/format_conversion.dart';
import 'package:apack/view/home.dart';
import 'package:apack/view/setting.dart';
import 'package:apack/view/window.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/foundation.dart';
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
    final appTheme = ref.watch(appThemeProvider);
    return FluentApp(
      debugShowCheckedModeBanner: false,
      title: appTitle,
      themeMode: appTheme.mode,
      theme: ThemeData(
        accentColor: systemAccentColor,
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

    return NavigationView(
      appBar: NavigationAppBar(
        title: () {
          if (kIsWeb) return const Text(appTitle);
          return MoveWindow(
            child: const Align(
              alignment: Alignment.centerLeft,
              child: Text(appTitle),
            ),
          );
        }(),
        actions: kIsWeb
            ? null
            : MoveWindow(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [Spacer(), WindowButtons()],
                ),
              ),
      ),
      pane: NavigationPane(
        selected: selectedIndex,
        onChanged: (newIndex) {
          ref.read(paneIndexProvider.state).state = newIndex;
        },
        displayMode: PaneDisplayMode.auto,
        header: const Text("Flutter for Windows"),
        items: [
          PaneItem(
            icon: const Icon(FluentIcons.fabric_picture_library),
            title: const Text("Reduce Size"),
            infoBadge: ref.watch(remainInfoBadgeProvider),
          ),
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
        children: [
          const HomeView(),
          FormatConversionView(),
          const SettingView(),
          const AboutView(),
        ],
      ),
    );
  }
}
