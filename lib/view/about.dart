import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AboutView extends HookConsumerWidget {
  const AboutView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ScaffoldPage(
      header: Text(
        "About",
        style: TextStyle(fontSize: 60),
      ),
      content: Center(child: Text("Welcome to About!")),
    );
  }
}
