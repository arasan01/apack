import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

part 'compression_image_options.freezed.dart';

enum CompressFormat { jpeg, png, heic, webp }

@freezed
class CompressionImageOptions with _$CompressionImageOptions {
  const factory CompressionImageOptions({
    @Default(95) int quality,
    @Default(1920) int width,
    @Default(1333) int height,
    @Default(CompressFormat.jpeg) CompressFormat format,
  }) = _CompressionImageOptions;
}

class CompressionImageOptionsNotifier
    extends StateNotifier<CompressionImageOptions> {
  CompressionImageOptionsNotifier() : super(const CompressionImageOptions());

  void update({
    int? quality,
    int? width,
    int? height,
    CompressFormat? format,
  }) {
    state = state.copyWith(
      quality: quality ?? state.quality,
      width: width ?? state.width,
      height: height ?? state.height,
      format: format ?? state.format,
    );
  }
}
