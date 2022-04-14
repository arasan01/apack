import 'package:apack/constants.dart';
import 'package:apack/drag_and_drop_channel.dart';
import 'package:file_selector/file_selector.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final _filePathListProvider = StateProvider<List<XFile>>((_) => []);
// final _fileTreeViewItemProvider =

class ReduceSizeView extends HookConsumerWidget {
  const ReduceSizeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useEffect(() {
      eventSubscriptions[kDragDropEventChannel] =
          dragEventStream.listen((list) {
        final List<XFile> zipList = list
            .where((path) => path.endsWith('.zip'))
            .map((path) => XFile(path))
            .toList();
        if (zipList.isNotEmpty) {
          ref.read(_filePathListProvider.notifier).state = zipList;
        }
      });

      return () {
        eventSubscriptions[kDragDropEventChannel]?.cancel();
        eventSubscriptions.remove(kDragDropEventChannel);
      };
    }, []);

    return ScaffoldPage(
      header: const PageHeader(title: Text('Reduce the size of zipped images')),
      content: Padding(
        padding: EdgeInsets.only(
          bottom: kPageDefaultVerticalPadding / 2,
          left: PageHeader.horizontalPadding(context),
          right: PageHeader.horizontalPadding(context),
        ),
        child: Column(
          children: [
            Text(ref
                .watch(_filePathListProvider.state)
                .state
                .map((e) => e.path)
                .join(", ")),
            _buttons(ref),
            spacer,
            const Expanded(child: ProcessTabView()),
            // _splitTreeView(ref),
          ],
        ),
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

final _tabIndexProvider = StateProvider<int>((_) => 0);

class ProcessTabView extends HookConsumerWidget {
  const ProcessTabView({Key? key}) : super(key: key);
  static const List<Tab> tabs = [
    Tab(
        closeIcon: null,
        onClosed: null,
        text: Text("Zip"),
        icon: Icon(FluentIcons.archive)),
    Tab(
        closeIcon: null,
        onClosed: null,
        text: Text("Extract"),
        icon: Icon(FluentIcons.folder_open)),
  ];
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: BoxDecoration(
        color:
            FluentTheme.of(context).accentColor.resolve(context).withAlpha(65),
      ),
      child: TabView(
        closeButtonVisibility: CloseButtonVisibilityMode.never,
        shortcutsEnabled: false,
        currentIndex: ref.watch(_tabIndexProvider),
        onChanged: (next) => ref.read(_tabIndexProvider.notifier).state = next,
        tabs: tabs,
        bodies: [
          _splitTreeView(ref),
          _splitTreeView(ref),
        ],
      ),
    );
  }

  Widget _splitTreeView(WidgetRef ref) {
    return Row(
      children: [
        spacer,
        Expanded(
            flex: 1,
            child: Mica(
                child: ConstrainedBox(
              child: const WaitZipTreeDisplay(),
              constraints: const BoxConstraints.expand(),
            ))),
        spacer,
        Expanded(
            flex: 1,
            child: Mica(
                child: ConstrainedBox(
              child: const FileTreeDisplay(),
              constraints: const BoxConstraints.expand(),
            ))),
        spacer,
      ],
    );
  }
}

// final _f1ScrollProvider =
//     Provider.autoDispose<ScrollController>((_) => ScrollController());
final _f1Scroll = ScrollController();

class WaitZipTreeDisplay extends HookConsumerWidget {
  const WaitZipTreeDisplay({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView.builder(
      controller: _f1Scroll,
      itemCount: 100,
      itemBuilder: ((context, index) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              const Icon(FluentIcons.file_image),
              spacer,
              Text("Select ${index * 5}"),
            ],
          ),
        );
      }),
    );
  }
}

final _f2ScrollProvider =
    StateProvider.autoDispose<ScrollController>((_) => ScrollController());
final _f2Scroll = ScrollController();

class FileTreeDisplay extends HookConsumerWidget {
  const FileTreeDisplay({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView.builder(
      controller: _f2Scroll,
      itemCount: 100,
      itemBuilder: ((context, index) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              const Icon(FluentIcons.file_image),
              spacer,
              Text("Select $index"),
            ],
          ),
        );
      }),
    );
  }
}
