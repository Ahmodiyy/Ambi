import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class LogController extends AutoDisposeAsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  Future<void> log(String a, String b) async {}
}

final logControllerProvider =
    AsyncNotifierProvider.autoDispose<LogController, void>(() {
  return LogController();
});
