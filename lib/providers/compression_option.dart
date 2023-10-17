// Zip archive compression parameters
import 'package:apack/entity/compression_image_options.dart';
import 'package:apack/variables.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final compressionImageOptionProvider = StateNotifierProvider<
    CompressionImageOptionsNotifier, CompressionImageOptions>(
  (_) => CompressionImageOptionsNotifier()
    ..update2(
        quality: prefs.getInt('quality'),
        width: prefs.getInt('width'),
        height: prefs.getInt('height'),
        format: prefs.getString('format')),
);
