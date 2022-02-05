import 'package:hooks_riverpod/hooks_riverpod.dart';

final paneIndexProvider = StateProvider<int>((ref) => 0);
final remainingItemCountProvider = StateProvider<int>((ref) => 0);
