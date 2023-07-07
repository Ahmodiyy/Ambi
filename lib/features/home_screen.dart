import 'package:ambi/constant.dart';
import 'package:ambi/features/signing/presentation/log_screen.dart';
import 'package:ambi/features/temp/presentation/ambient_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'issues/presentation/report_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  static const List<Widget> _pages = <Widget>[
    LogScreen(),
    AmbientScreen(),
    ReportScreen(),
  ];
  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: whiteColor,
        selectedItemColor: Colors.black,
        currentIndex: _selectedIndex,
        elevation: 3,
        onTap: _onItemTapped,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.login_outlined,
            ),
            label: 'Log',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.electric_bolt_sharp),
            label: 'Sensor',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.report_gmailerrorred_outlined),
            label: 'Report',
          ),
        ],
      ),
    );
  }
}
