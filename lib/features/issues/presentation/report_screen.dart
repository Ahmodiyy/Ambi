import 'package:ambi/features/issues/presentation/report_controller.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../../../constant.dart';

class ReportScreen extends ConsumerStatefulWidget {
  const ReportScreen({super.key});

  @override
  ConsumerState createState() => _ReportScreenState();
}

class _ReportScreenState extends ConsumerState<ReportScreen> {
  bool showSpinner = true;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TextEditingController _name;
  late TextEditingController _subject;
  late TextEditingController _message;
  late ConnectivityResult connectivityResult;
  @override
  void initState() {
    super.initState();
    _name = TextEditingController();
    _subject = TextEditingController();
    _message = TextEditingController();
  }

  @override
  void dispose() {
    _name.dispose();
    _subject.dispose();
    _message.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reportValue = ref.watch(reportControllerProvider);
    bool isLoading = reportValue is AsyncLoading<void>;
    ref.listen(reportControllerProvider, (previous, next) {
      next.when(
          data: (value) {
            _name.clear();
            _subject.clear();
            _message.clear();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Successful")),
            );
          },
          error: (error, stackTrace) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(error.toString())),
            );
          },
          loading: () {});
    });

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  AutoSizeText("Email",
                      maxLines: 1,
                      style: Theme.of(context).textTheme.displayLarge),
                  const SizedBox(
                    height: 30,
                  ),
                  AutoSizeText(
                    "Send an issue or complaint",
                    maxLines: 1,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(
                    height: 60,
                  ),
                  TextFormField(
                    controller: _name,
                    keyboardType: TextInputType.emailAddress,
                    decoration: constantTextFieldDecoration.copyWith(
                      hintText: 'Name',
                      prefixIcon:
                          const Icon(Icons.person, color: Colors.black45),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Oops! You forgot to enter your name.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  TextFormField(
                    controller: _subject,
                    maxLines: null,
                    keyboardType: TextInputType.text,
                    decoration: constantTextFieldDecoration.copyWith(
                      hintText: 'Subject',
                      prefixIcon: const Icon(Icons.location_city,
                          color: Colors.black45),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Subject not specified!';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  TextFormField(
                    controller: _message,
                    maxLines: 20,
                    keyboardType: TextInputType.text,
                    decoration: constantTextFieldDecoration.copyWith(
                      hintText: 'Message',
                      prefixIcon: const Icon(Icons.location_city,
                          color: Colors.black45),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Provide your message';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 60,
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          var connectivityResult =
                              await Connectivity().checkConnectivity();
                          if (connectivityResult == ConnectivityResult.none) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text("No internet connection")),
                            );
                            return;
                          }

                          try {
                            await ref
                                .read(reportControllerProvider.notifier)
                                .sendReport(
                                    _name.text, _subject.text, _message.text);
                          } catch (e) {
                            debugPrint(e.toString());
                          }
                        }
                      },
                      child: isLoading
                          ? const RepaintBoundary(
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            )
                          : const Text("Submit"))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
