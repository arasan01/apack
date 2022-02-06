import 'dart:isolate';

import 'package:apack/entity/process_image.dart';
import 'package:apack/image_output_type.dart';
import 'package:apack/providers.dart';
import 'package:file_selector/file_selector.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image/image.dart';
import 'package:image_compression_flutter/image_compression_flutter.dart';
import 'package:path/path.dart';

Future<void> formatConversionSelectFile(
    BuildContext context, WidgetRef ref) async {
  final XTypeGroup typeGroup = XTypeGroup(
    label: 'images',
    extensions: <String>['jpg', 'jpeg', 'png', 'webp'],
  );
  final XFile? file =
      await openFile(acceptedTypeGroups: <XTypeGroup>[typeGroup]);
  if (file == null) {
    return;
  }
  ref.read(formatConversionFilePathProvider.state).state = file;
}

Future<ProcessImage?> formatConversionProcessImage(
    BuildContext context, WidgetRef ref) async {
  ref.read(formatConversionProcessImageProvider.notifier).update(null);

  final type = ref.read(formatConversionOutputTypeProvider.state).state;
  final imageOption = ref.read(compressionImageOptionProvider);
  final file = ref.read(formatConversionFilePathProvider.state).state;
  if (file == null) {
    return null;
  }

  final ImageFile imageFile = await file.asImageFile;
  final Configuration config =
      Configuration(outputType: type, quality: imageOption.quality);

  final compressParameters =
      ImageFileConfiguration(input: imageFile, config: config);

  final ImageFile outputFile = await compressor.compress(compressParameters);
  final String outputName =
      '${basenameWithoutExtension(file.name)}.${type.extensionName}';

  final XFile saveFile = XFile.fromData(outputFile.rawBytes,
      mimeType: outputFile.contentType,
      length: outputFile.sizeInBytes,
      name: outputName);

  final ProcessImage processImage = ProcessImage(
      image: saveFile,
      suggestedFileName: outputName,
      extension: type.extensionName,
      mimeType: type.mimeType);
  return processImage;
}

Future<void> formatConversionSaveFile(
    BuildContext context, WidgetRef ref) async {
  final processInfo = ref.read(formatConversionProcessImageProvider);
  if (processInfo == null) {
    return;
  }

  final String? outputPath = await getSavePath(
    suggestedName: processInfo.suggestedFileName,
    acceptedTypeGroups: [
      XTypeGroup(
        label: 'images',
        extensions: [processInfo.extension],
        mimeTypes: [processInfo.mimeType],
      ),
    ],
  );
  if (outputPath == null) {
    return;
  }
  await processInfo.image.saveTo(outputPath);
}
