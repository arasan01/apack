import 'dart:async';

import 'package:apack/constants.dart';
import 'package:flutter/services.dart';

EventChannel _eventChannel = const EventChannel(kDragDropEventChannel);
Stream<List<String>> dragEventStream = _eventChannel
    .receiveBroadcastStream()
    .map((event) => List<String>.from(event))
    .asBroadcastStream();

Map<String, StreamSubscription> eventSubscriptions = {};
