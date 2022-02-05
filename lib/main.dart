import 'package:apack/providers.dart';
import 'package:apack/view/about.dart';
import 'package:apack/view/home.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() {
  runApp(ProviderScope(child: ApackApp()));
}

class ApackApp extends HookWidget {
  @override
  Widget build(BuildContext context) {
    return FluentApp(
      title: 'Apack',
      theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
          accentColor: Colors.blue,
          iconTheme: const IconThemeData(size: 24)),
      darkTheme: ThemeData(
          scaffoldBackgroundColor: Colors.black,
          accentColor: Colors.blue,
          iconTheme: const IconThemeData(size: 24)),
      home: NavSideView(),
    );
  }
}

class NavSideView extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return NavigationView(
      pane: NavigationPane(
        selected: ref.watch(paneIndexProvider.state).state,
        onChanged: (newIndex) {
          ref.read(paneIndexProvider.state).state = newIndex;
        },
        displayMode: PaneDisplayMode.auto,
        items: [
          PaneItem(
              icon: const Icon(FluentIcons.home),
              title: const Text("Home"),
              infoBadge: ref.watch(remainingItemCountProvider.state).state > 0
                  ? InfoBadge(
                      source: Text(
                          '${ref.watch(remainingItemCountProvider.state).state}'),
                    )
                  : null),
          PaneItem(
            icon: const Icon(FluentIcons.info),
            title: const Text("About"),
          )
        ],
      ),
      content: NavigationBody(
        index: ref.watch(paneIndexProvider.state).state,
        children: const [
          HomeView(),
          AboutView(),
        ],
      ),
    );
  }
}
