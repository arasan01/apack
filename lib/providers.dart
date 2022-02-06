import 'package:apack/entity/compression_image_options.dart';
import 'package:apack/entity/process_image.dart';
import 'package:apack/entity/theme.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_compression_flutter/image_compression_flutter.dart';

// NavigationPane selected index
final paneIndexProvider = StateProvider<int>((ref) => 0);

// NavigationPane add badge counter
final remainItemCountProvider = StateProvider<int>((ref) => 0);
final remainInfoBadgeProvider = Provider<InfoBadge?>((ref) {
  final state = ref.watch(remainItemCountProvider.state).state;
  return state > 0
      ? InfoBadge(
          source: Text('$state'),
        )
      : null;
});

// Format conversion select file path
final formatConversionFilePathProvider = StateProvider<XFile?>((_) => null);
final formatConversionOutputTypeProvider =
    StateProvider<ImageOutputType>((_) => ImageOutputType.jpg);
final formatConversionProcessImageProvider =
    StateNotifierProvider.autoDispose<ProcessImageNotifier, ProcessImage?>(
        (_) => ProcessImageNotifier());

// Theme provider
final appThemeProvider = StateNotifierProvider<AppThemeNotifier, AppTheme>(
    (_) => AppThemeNotifier());

// Zip archive compression parameters
final compressionImageOptionProvider = StateNotifierProvider<
    CompressionImageOptionsNotifier, CompressionImageOptions>(
  (_) => CompressionImageOptionsNotifier(),
);
