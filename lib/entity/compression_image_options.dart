import 'package:apack/define/image_output_type.dart';
import 'package:apack/variables.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

part 'compression_image_options.freezed.dart';

@freezed
class CompressionImageOptions with _$CompressionImageOptions {
  const factory CompressionImageOptions({
    @Default(95) int quality,
    @Default(1920) int width,
    @Default(1333) int height,
    @Default(AppImageOutputType.jpg) AppImageOutputType format,
  }) = _CompressionImageOptions;
}

class CompressionImageOptionsNotifier
    extends StateNotifier<CompressionImageOptions> {
  CompressionImageOptionsNotifier() : super(const CompressionImageOptions());

  void update({
    int? quality,
    int? width,
    int? height,
    AppImageOutputType? format,
  }) {
    state = state.copyWith(
      quality: quality ?? state.quality,
      width: width ?? state.width,
      height: height ?? state.height,
      format: format ?? state.format,
    );
    store();
  }

  void update2({
    int? quality,
    int? width,
    int? height,
    String? format,
  }) {
    state = state.copyWith(
      quality: quality ?? state.quality,
      width: width ?? state.width,
      height: height ?? state.height,
      format: format?.toAppImageOutputType() ?? state.format,
    );
    store();
  }

  void store() {
    prefs.setInt('quality', state.quality);
    prefs.setInt('width', state.width);
    prefs.setInt('height', state.height);
    prefs.setString('format', state.format.name);
  }
}
