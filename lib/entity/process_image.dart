import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:image_compression_flutter/image_compression_flutter.dart';
import 'package:state_notifier/state_notifier.dart';

part 'process_image.freezed.dart';

@freezed
class ProcessImage with _$ProcessImage {
  const factory ProcessImage({
    required XFile image,
    required String suggestedFileName,
    required String mimeType,
    required String extension,
  }) = _ProcessImage;
}

class ProcessImageNotifier extends StateNotifier<ProcessImage?> {
  ProcessImageNotifier() : super(null);

  void update(ProcessImage? value) => state = value;
}
