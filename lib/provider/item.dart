import 'package:flutter/cupertino.dart';

class ItemCount extends ChangeNotifier{
  int _currentIndex = 2;
  List<int> _itemCount = [0,0,0];
  double _totalCost = 0;
  List<double> _cost = [0.0, 0.0, 0.0];
  List<String> _itemName = ["Burger", "French Fries", "Pizza"];
  List<double> _itemPrice = [5.0, 7.5, 15.0];


  int get currentIndex => _currentIndex;
  List<int> get itemCount => _itemCount;
  double get totalCost => _totalCost;
  List<double> get cost => _cost;
  List<String> get itemName => _itemName;
  List<double> get itemPrice => _itemPrice;


  int setIndex(int value){
    _currentIndex = value;

    notifyListeners();
    return _currentIndex;
  }

  void increment(int index){
    _itemCount[index]++;
    _cost[index] = _itemPrice[index] * _itemCount[index];
    totalPrice();

    notifyListeners();
  }

  void decrement(int index){
    _itemCount[index]--;
    if(_itemCount[index]<0)
    {
      _itemCount[index] = 0;
    }
    _cost[index] = _itemPrice[index] * _itemCount[index];
    totalPrice();

    notifyListeners();
  }

  void totalPrice(){
    double cost = 0;
    for(int i=0;i<3;i++){
      cost += _cost[i];
    }
    _totalCost = cost;
    notifyListeners();
  }
}