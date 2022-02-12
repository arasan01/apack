import 'package:apack/entity/process_image.dart';
import 'package:file_selector/file_selector.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

typedef FormatConversionInput = Future<XFile?> Function();
typedef FormatConversionOutput = Future<void> Function(
    AsyncValue<ProcessImage?> saveInfo);

class FormatConversionInOut {
  final FormatConversionInput input;
  final FormatConversionOutput output;
  FormatConversionInOut(this.input, this.output);
}
