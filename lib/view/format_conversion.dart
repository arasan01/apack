import 'dart:io';

import 'package:apack/constants.dart';
import 'package:apack/entity/process_image.dart';
import 'package:apack/image_output_type.dart';
import 'package:apack/logic/image.dart';
import 'package:apack/providers.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:file_selector/file_selector.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_compression_flutter/image_compression_flutter.dart';
import 'package:path/path.dart';

typedef ProcessImageEffect = void Function(WidgetRef ref, ProcessImage image);

class FormatConversionView extends HookConsumerWidget {
  FormatConversionView({Key? key}) : super(key: key);

  ProcessImageEffect? _processImageEffect;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useEffect(() {
      _processImageEffect = (ref, image) {
        ref.read(formatConversionProcessImageProvider.notifier).update(image);
      };
      formatConversionProcessImage(context, ref).then((processImage) {
        if (processImage != null) {
          _processImageEffect?.call(ref, processImage);
        }
      });
      return () {
        _processImageEffect = null;
      };
    }, []);
    return ScaffoldPage(
      header:
          const PageHeader(title: Text('Format Conversion JPG, PNG, and WebP')),
      content: ListView(
        padding: EdgeInsets.only(
          bottom: kPageDefaultVerticalPadding,
          left: PageHeader.horizontalPadding(context),
          right: PageHeader.horizontalPadding(context),
        ),
        children: [
          Row(
            children: [
              Button(
                child: Row(
                  children: const [
                    Icon(FluentIcons.file_image),
                    spacer,
                    Text("Select"),
                  ],
                ),
                onPressed: () async {
                  await formatConversionSelectFile(context, ref);
                  final processImage =
                      await formatConversionProcessImage(context, ref);
                  if (processImage != null) {
                    _processImageEffect?.call(ref, processImage);
                  }
                },
              ),
              spacer,
              SizedBox(
                width: 100,
                child: Combobox<ImageOutputType>(
                  value:
                      ref.watch(formatConversionOutputTypeProvider.state).state,
                  items: imageOutputTypeValueWindowsAvailable
                      .map((e) => ComboboxItem<ImageOutputType>(
                            value: e,
                            child: Text(e.extensionName),
                          ))
                      .toList(),
                  onChanged: (value) async {
                    if (value != null) {
                      ref.read(formatConversionOutputTypeProvider.state).state =
                          value;
                      final processImage =
                          await formatConversionProcessImage(context, ref);
                      if (processImage != null) {
                        _processImageEffect?.call(ref, processImage);
                      }
                    }
                  },
                ),
              ),
              spacer,
              Button(
                child: Row(
                  children:
                      ref.watch(formatConversionProcessImageProvider) != null
                          ? const [
                              Icon(FluentIcons.download),
                              spacer,
                              Text("Save"),
                            ]
                          : const [
                              Icon(FluentIcons.progress_loop_inner),
                              spacer,
                              Text("Processing"),
                            ],
                ),
                onPressed: () => formatConversionSaveFile(context, ref),
              ),
            ],
          ),
          spacer,
          const ImageDisplay()
        ],
      ),
    );
  }
}

class ImageDisplay extends HookConsumerWidget {
  const ImageDisplay({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final file = ref.watch(formatConversionFilePathProvider.state).state;
    return file == null
        ? Container()
        : Mica(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    file.name,
                    style: FluentTheme.of(context).typography.bodyStrong,
                  ),
                  spacer,
                  Container(
                    constraints:
                        const BoxConstraints(maxWidth: 900, maxHeight: 500),
                    child: Image.file(
                      File(file.path),
                    ),
                  )
                ],
              ),
            ),
          );
  }
}
