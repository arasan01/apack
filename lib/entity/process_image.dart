import 'dart:math';
import 'dart:typed_data';

class ProcessImage {
  final Uint8List image;
  final String suggestedFileName;
  final String mimeType;
  final String extension;

  ProcessImage({
    required this.image,
    required this.suggestedFileName,
    required this.mimeType,
    required this.extension,
  });
}

extension View on ProcessImage {
  String get fileSize {
    final bytes = image.lengthInBytes;
    const suffixes = ["B", "KB", "MB", "GB", "TB"];
    var order = (log(bytes) / log(1024)).floor();
    return ((bytes / pow(1024, order)).toStringAsFixed(1)) +
        ' ' +
        suffixes[order];
  }
}
