import 'dart:io';
import 'dart:isolate';
import 'dart:typed_data';

import 'package:apack/entity/compression_image_options.dart';
import 'package:apack/entity/process_image.dart';
import 'package:apack/define/image_output_type.dart';
import 'package:file_selector/file_selector.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image/image.dart' as img;
import 'package:path/path.dart';

class _CompressParam {
  final XFile file;
  final int maxWidth;
  final int maxHeight;
  final int quality;
  final AppImageOutputType type;
  final SendPort sendPort;

  _CompressParam({
    required this.file,
    required this.maxWidth,
    required this.maxHeight,
    required this.quality,
    required this.type,
    required this.sendPort,
  });
}

/// return Uint8List
Future _compressIsolate(_CompressParam param) async {
  Uint8List rawimageData = await param.file.readAsBytes();
  if (rawimageData.isEmpty) {
    param.sendPort.send(null);
    return;
  }

  img.Image? image = img.decodeImage(rawimageData);
  if (image == null) {
    param.sendPort.send(null);
    return;
  }

  final img.Image compressedImage = image.width > image.height
      ? img.copyResize(image,
          width: param.maxWidth > image.width ? image.width : param.maxWidth)
      : img.copyResize(image,
          height:
              param.maxHeight > image.height ? image.height : param.maxHeight);

  final bytes = _encodeOutputTypeImage(
    compressedImage,
    param.type,
    quality: param.quality,
  );
  if (bytes == null) {
    param.sendPort.send(null);
    return;
  }
  param.sendPort.send(bytes);
}

Uint8List? _encodeOutputTypeImage(img.Image image, AppImageOutputType type,
    {int quality = 95}) {
  final List<int> imageData;
  switch (type) {
    case AppImageOutputType.jpg:
      imageData = img.encodeJpg(image, quality: quality);
      break;
    case AppImageOutputType.png:
      imageData = img.encodePng(image);
      break;
    case AppImageOutputType.gif:
      imageData = img.encodeGif(image);
      break;
    default:
      return null;
  }
  final bytes = Uint8List.fromList(imageData);
  return bytes.isEmpty ? null : bytes;
}

Future<XFile?> selectImageFileWithOpenExplorer() async {
  final XTypeGroup typeGroup = XTypeGroup(
    label: 'images',
    extensions: <String>[
      'jpg',
      'jpeg',
      'png',
      'webp',
      'bmp',
      'tiff',
      'psd',
      'ico',
      'gif',
      'exr',
      'tga',
      'pvr',
      'pvrtc'
    ],
  );
  final XFile? file =
      await openFile(acceptedTypeGroups: <XTypeGroup>[typeGroup]);
  return file;
}

Future<void> saveImageFileWithOpenExplorer(
    AsyncValue<ProcessImage?> saveInfo) async {
  final processInfo = saveInfo.value;
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
  await File(outputPath).writeAsBytes(processInfo.image);
}

Future<ProcessImage?> compressImage({
  required XFile file,
  required AppImageOutputType type,
  required CompressionImageOptions imageOption,
}) async {
  var receivePort = ReceivePort();
  await Isolate.spawn(
      _compressIsolate,
      _CompressParam(
          file: file,
          maxWidth: imageOption.width,
          maxHeight: imageOption.height,
          quality: imageOption.quality,
          type: type,
          sendPort: receivePort.sendPort));
  final imageBytes = await receivePort.first as Uint8List?;
  receivePort.close();
  if (imageBytes == null) return null;
  final String outputName =
      '${basenameWithoutExtension(file.name)}.${type.extensionName}';

  final ProcessImage processImage = ProcessImage(
      image: imageBytes,
      suggestedFileName: outputName,
      extension: type.extensionName,
      mimeType: type.mimeType);
  return processImage;
}
