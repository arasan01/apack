import 'package:image_compression_flutter/image_compression_flutter.dart';

extension AppExt on ImageOutputType {
  String get extensionName {
    switch (this) {
      case ImageOutputType.jpg:
        return 'jpg';
      case ImageOutputType.png:
        return 'png';
      case ImageOutputType.webpThenJpg:
        return 'webp';
      case ImageOutputType.webpThenPng:
        return 'webp';
    }
  }

  String get mimeType {
    switch (this) {
      case ImageOutputType.jpg:
        return 'image/jpeg';
      case ImageOutputType.png:
        return 'image/png';
      case ImageOutputType.webpThenJpg:
        return 'image/webp';
      case ImageOutputType.webpThenPng:
        return 'image/webp';
    }
  }
}

List<ImageOutputType> get imageOutputTypeValueWindowsAvailable {
  return [
    ImageOutputType.jpg,
    ImageOutputType.png,
    ImageOutputType.webpThenJpg,
  ];
}
