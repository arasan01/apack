import 'package:apack/constants.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// final _fileTreeViewItemProvider =

class ReduceSizeView extends HookConsumerWidget {
  const ReduceSizeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ScaffoldPage(
      header: const PageHeader(title: Text('Reduce the size of zipped images')),
      content: ListView(
        padding: EdgeInsets.only(
          bottom: kPageDefaultVerticalPadding,
          left: PageHeader.horizontalPadding(context),
          right: PageHeader.horizontalPadding(context),
        ),
        children: [_buttons(ref), spacer, const FileTreeDisplay()],
      ),
    );
  }

  Button _selectButton(WidgetRef ref) {
    return Button(
      child: const Text("select"),
      onPressed: () {},
    );
  }

  Button _runButton(WidgetRef ref) {
    return Button(
      child: const Text("run"),
      onPressed: () {},
    );
  }

  Button _stopButton(WidgetRef ref) {
    return Button(
      child: const Text("stop"),
      onPressed: () {},
    );
  }

  Row _buttons(WidgetRef ref) {
    return Row(
      children: [
        _selectButton(ref),
        spacer,
        _runButton(ref),
        spacer,
        _stopButton(ref)
      ],
    );
  }
}

class FileTreeDisplay extends HookConsumerWidget {
  const FileTreeDisplay({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final
    // return TreeView(items: const []);
    return const Text("Tree");
  }
}
