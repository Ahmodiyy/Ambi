import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

class ReportRepo {
  Future<void> sendReport(String name, String subject, String message) async {
    var url = Uri.https('example.com', 'whatsit/create');
    var response = await http.post(
      url,
    );
  }
}

final reportRepoProvider = Provider<ReportRepo>((ref) {
  return ReportRepo();
});
