import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

import '../../../constant.dart';
import 'log_controller.dart';

final currentTimeProvider = StreamProvider.autoDispose<String>((ref) {
  return Stream.periodic(Duration(seconds: 1), (_) {
    final now = DateTime.now();
    final formattedTime =
        DateFormat.Hms().format(now); // Format without milliseconds
    return formattedTime;
  });
});

class LogScreen extends ConsumerStatefulWidget {
  const LogScreen({super.key});

  @override
  ConsumerState createState() => _LogScreenState();
}

class _LogScreenState extends ConsumerState<LogScreen> {
  bool showSpinner = true;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TextEditingController _email;
  late TextEditingController _password;

  @override
  void initState() {
    super.initState();
    _email = TextEditingController();
    _password = TextEditingController();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentTimeAsyncValue = ref.watch(currentTimeProvider);
    ref.listen<AsyncValue<void>>(
      logControllerProvider,
      (_, state) => state.whenOrNull(
        error: (error, stackTrace) {
          // show snackbar if an error occurred
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(error.toString())),
          );
        },
      ),
    );
    final loginValue = ref.watch(logControllerProvider);
    final isLoading = loginValue is AsyncLoading<void>;
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
                    return Text("Unable to get current date time");
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
                    controller: _email,
                    keyboardType: TextInputType.emailAddress,
                    decoration: constantTextFieldDecoration.copyWith(
                      hintText: 'Name',
                      prefixIcon:
                          const Icon(Icons.person, color: Colors.black45),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Oops! You forgot to enter your name. Please enter your name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  TextFormField(
                    controller: _password,
                    keyboardType: TextInputType.text,
                    decoration: constantTextFieldDecoration.copyWith(
                      hintText: 'Site',
                      prefixIcon: const Icon(Icons.location_city,
                          color: Colors.black45),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Site not specified. Please enter the site you want to work on!';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 60,
                  ),
                  ElevatedButton(onPressed: () {}, child: const Text("Sign in"))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
