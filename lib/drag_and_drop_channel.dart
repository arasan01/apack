import 'dart:async';

import 'package:apack/constants.dart';
import 'package:flutter/services.dart';

EventChannel eventChannel = const EventChannel(kDragDropEventChannel);
StreamSubscription? eventSubscription;
