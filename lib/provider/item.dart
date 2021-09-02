import 'package:flutter/cupertino.dart';

class ItemCount extends ChangeNotifier{
  int _currentIndex = 1;
  int get currentIndex => _currentIndex;

  void setIndex(int value){
    _currentIndex = value;
    notifyListeners();
  }
}