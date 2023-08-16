import 'dart:async';
import 'package:ambi/features/issues/data/report_repo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ReportController extends AutoDisposeAsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  Future<void> sendReport(String name, String subject, String message) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(reportRepoProvider).sendReport(name, subject, message);
    });
  }
}

final reportControllerProvider =
    AsyncNotifierProvider.autoDispose<ReportController, void>(() {
  return ReportController();
});
