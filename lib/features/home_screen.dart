import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BottomNavigationBar Demo'),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.login),
            label: 'Calls',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.electric_bolt_sharp),
            label: 'Camera',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.report),
            label: 'Chats',
          ),
        ],
      ),
    );
  }
}
