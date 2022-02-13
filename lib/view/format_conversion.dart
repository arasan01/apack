import 'dart:io';

import 'package:apack/constants.dart';
import 'package:apack/define/format_conversion.dart';
import 'package:apack/drag_and_drop_channel.dart';
import 'package:apack/entity/process_image.dart';
import 'package:apack/define/image_output_type.dart';
import 'package:apack/logic/image.dart';
import 'package:apack/providers/compression_option.dart';
import 'package:apack/providers/global.dart';
import 'package:file_selector/file_selector.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:path/path.dart' as path;

final _sliderValueProvider = StateProvider<double>(
    (ref) => ref.read(compressionImageOptionProvider).quality.toDouble());
final _filePathProvider = StateProvider<XFile?>((_) => null);
final _outputTypeProvider =
    StateProvider<AppImageOutputType>((_) => AppImageOutputType.jpg);

final _inOutMethodProvider = Provider<FormatConversionInOut>((_) =>
    FormatConversionInOut(
        selectImageFileWithOpenExplorer, saveImageFileWithOpenExplorer));
final _processImageProvider = FutureProvider<ProcessImage?>((ref) async {
  final type = ref.watch(_outputTypeProvider.state).state;
  final file = ref.watch(_filePathProvider.state).state;
  final imageOption = ref.watch(compressionImageOptionProvider);
  if (file == null) return null;
  final image = await compressImage(
    file: file,
    type: type,
    imageOption: imageOption,
  );
  return image;
});

class FormatConversionView extends HookConsumerWidget {
  const FormatConversionView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useEffect(() {
      eventSubscription = eventChannel.receiveBroadcastStream().listen(
        (data) {
          List<String> list = List<String>.from(data);
          ref.read(dragDropPlatformMessageProvider.state).state = list;
          final ext =
              path.extension(list.first).toLowerCase().replaceFirst('.', '');
          if (allowSelectImageFormat.contains(ext)) {
            ref.read(_filePathProvider.state).state = XFile(list.first);
          }
        },
        onError: (error) {
          stderr.writeln('error $error');
        },
        cancelOnError: false,
      );

      return () {
        eventSubscription?.cancel();
        eventSubscription = null;
      };
    }, []);

    return ScaffoldPage(
      header: const PageHeader(
          title:
              Text('Format Conversion WebP, PSD, PNG, etc to JPG, PNG, GIF')),
      content: ListView(
        padding: EdgeInsets.only(
          bottom: kPageDefaultVerticalPadding,
          left: PageHeader.horizontalPadding(context),
          right: PageHeader.horizontalPadding(context),
        ),
        children: [
          buttons(ref),
          spacer,
          if (ref.watch(_outputTypeProvider.state).state ==
              AppImageOutputType.jpg)
            jpegSlider(context, ref),
          spacer,
          const ImageDisplay()
        ],
      ),
    );
  }

  Row jpegSlider(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        Text("jpgQuality",
            style: FluentTheme.of(context).typography.bodyStrong),
        spacer,
        Expanded(
          child: Slider(
            value: ref.watch(_sliderValueProvider.state).state,
            onChanged: (value) {
              ref.read(_sliderValueProvider.state).state = value;
            },
            onChangeEnd: (value) {
              ref
                  .read(compressionImageOptionProvider.notifier)
                  .update(quality: value.toInt());
            },
            min: 1,
            max: 100,
            divisions: 100,
          ),
        ),
        spacer,
        Text(ref.watch(_sliderValueProvider.state).state.toStringAsFixed(0),
            style: FluentTheme.of(context).typography.bodyStrong),
      ],
    );
  }

  Row buttons(WidgetRef ref) {
    return Row(
      children: [
        selectButton(ref),
        spacer,
        selectOutputType(ref),
        spacer,
        saveButton(ref),
      ],
    );
  }

  Button saveButton(WidgetRef ref) {
    return Button(
      child: Row(
        children: ref.watch(_processImageProvider).when(data: (_) {
          return const [
            Icon(FluentIcons.download),
            spacer,
            Text("Save"),
          ];
        }, error: (_, __) {
          return const [
            Icon(FluentIcons.error),
            spacer,
            Text("Oops, saved photo error"),
          ];
        }, loading: () {
          return const [
            Icon(FluentIcons.progress_loop_inner),
            spacer,
            Text("Processing"),
          ];
        }),
      ),
      onPressed: () => ref
          .read(_inOutMethodProvider)
          .output(ref.read(_processImageProvider)),
    );
  }

  SizedBox selectOutputType(WidgetRef ref) {
    return SizedBox(
      width: 100,
      child: Combobox<AppImageOutputType>(
        value: ref.watch(_outputTypeProvider.state).state,
        items: AppImageOutputType.values
            .map((e) => ComboboxItem<AppImageOutputType>(
                  value: e,
                  child: Text(e.extensionName),
                ))
            .toList(),
        onChanged: (value) async {
          if (value != null) {
            ref.read(_outputTypeProvider.state).state = value;
          }
        },
      ),
    );
  }

  Button selectButton(WidgetRef ref) {
    return Button(
        child: Row(
          children: const [
            Icon(FluentIcons.file_image),
            spacer,
            Text("Select"),
          ],
        ),
        onPressed: () {
          ref.read(_inOutMethodProvider).input().then((value) {
            if (value != null) {
              ref.read(_filePathProvider.state).state = value;
            }
          });
        });
  }
}

class ImageDisplay extends HookConsumerWidget {
  const ImageDisplay({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<ProcessImage?> processedImage =
        ref.watch(_processImageProvider);
    return processedImage.when(
      data: (processedImage) {
        if (processedImage == null) return Container();
        return Mica(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  processedImage.suggestedFileName,
                  style: FluentTheme.of(context).typography.bodyStrong,
                ),
                Text(
                  processedImage.fileSize,
                  style: FluentTheme.of(context).typography.body,
                ),
                spacer,
                Text("Preview Image",
                    style: FluentTheme.of(context).typography.caption),
                Image.memory(
                  processedImage.image,
                  fit: BoxFit.contain,
                )
              ],
            ),
          ),
        );
      },
      error: (_, __) => Container(),
      loading: () => const ProgressBar(),
    );
  }
}
