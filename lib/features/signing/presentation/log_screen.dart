import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:intl/intl.dart';

import '../../../constant.dart';
import 'log_controller.dart';

final currentTimeProvider = StreamProvider.autoDispose<String>((ref) {
  return Stream.periodic(const Duration(seconds: 1), (_) {
    final now = DateTime.now();
    final formattedTime =
        DateFormat.Hms().format(now); // Format without milliseconds
    return formattedTime;
  });
});

final logControllerProvider =
    AsyncNotifierProvider.autoDispose<LogController, void>(() {
  return LogController();
});

class LogScreen extends ConsumerStatefulWidget {
  const LogScreen({super.key});

  @override
  ConsumerState createState() => _LogScreenState();
}

class _LogScreenState extends ConsumerState<LogScreen> {
  bool showSpinner = true;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TextEditingController _name;
  late TextEditingController _site;
  late ConnectivityResult connectivityResult;
  @override
  void initState() {
    super.initState();
    _name = TextEditingController();
    _site = TextEditingController();
  }

  @override
  void dispose() {
    _name.dispose();
    _site.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentTimeAsyncValue = ref.watch(currentTimeProvider);
    final loginValue = ref.watch(logControllerProvider);
    bool isLoading = loginValue is AsyncLoading<void>;
    ref.listen(logControllerProvider, (previous, next) {
      next.when(
          data: (value) => {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Successful")),
                ),
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
                    height: 60,
                  ),
                  currentTimeAsyncValue.when(data: (data) {
                    return AutoSizeText(data.toString(),
                        maxLines: 1,
                        style: Theme.of(context).textTheme.displayLarge);
                  }, error: (obj, stack) {
                    return const AutoSizeText(
                        "Unable to get current date time");
                  }, loading: () {
                    return const Center(
                        child: CircularProgressIndicator(
                      color: Colors.black,
                    ));
                  }),
                  const SizedBox(
                    height: 30,
                  ),
                  AutoSizeText(
                    "Please enter your valid details",
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
                    controller: _site,
                    keyboardType: TextInputType.text,
                    decoration: constantTextFieldDecoration.copyWith(
                      hintText: 'Site',
                      prefixIcon: const Icon(Icons.location_city,
                          color: Colors.black45),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Site not specified!';
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
                          await ref
                              .read(logControllerProvider.notifier)
                              .log(_name.text, _site.text);
                          _name.clear();
                          _site.clear();
                        }
                      },
                      child: isLoading
                          ? const RepaintBoundary(
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            )
                          : const Text("Sign in"))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
