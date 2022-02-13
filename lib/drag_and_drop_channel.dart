import 'dart:async';

import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

late EventChannel eventChannel = const EventChannel('dnd_channel');
StreamSubscription? eventSubscription;

// final streamSubscriptionProvider = StateProvider<StreamSubscription?>(
//     (ref) => eventChannel.receiveBroadcastStream().listen(
//           (data) {
//             final event = data as List<String>;
//             ref.read(dragDropPlatformMessageProvider.state).state = event;
//           },
//           onError: (_) {},
//           cancelOnError: false,
//         ));
final dragDropPlatformMessageProvider = StateProvider<List<String>>((_) => []);
