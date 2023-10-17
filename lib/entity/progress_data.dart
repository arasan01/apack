import 'package:freezed_annotation/freezed_annotation.dart';

part 'progress_data.freezed.dart';

enum ProgressType { indeterminate, determinate }

@freezed
class ProgressData with _$ProgressData {
  const factory ProgressData({
    @Default(0) int current,
    @Default(0) int total,
    @Default(ProgressType.indeterminate) ProgressType type,
  }) = _ProgressData;
}
