import 'dart:async';

import 'package:ambi/features/signing/data/log_repo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LogController extends AutoDisposeAsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  Future<void> log(String name, String site) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(logRepoProvider).log(name: name, site: site);
    });
  }
}

final logControllerProvider =
    AsyncNotifierProvider.autoDispose<LogController, void>(() {
  return LogController();
});
