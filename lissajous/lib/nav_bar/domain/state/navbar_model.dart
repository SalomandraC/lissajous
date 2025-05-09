import 'package:flutter/material.dart';

class NavbarModel extends ChangeNotifier {
  int _currentIndex = 0;
  int get currentIndex => _currentIndex;

  final List<Widget> _screens = [];

  void changeItem(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  Widget getCurrentPage() {
    return _screens[_currentIndex];
  }
}
