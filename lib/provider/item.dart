import 'package:billing_application/data/data.dart';
import 'package:flutter/cupertino.dart';

class ItemCount extends ChangeNotifier {

  Data data = Data();
  
  int _currentIndex = 0;
  double _totalCost = 0;


  int get currentIndex => _currentIndex;
  double get totalCost => _totalCost;
  List<int> get itemCount => data.itemCount;
  List<double> get cost => data.cost;

  List<String> get itemName => data.itemName;
  List<double> get itemPrice => data.itemPrice;

  int setIndex(int value) {
    _currentIndex = value;

    notifyListeners();
    return _currentIndex;
  }

  void increment(int index) {
    data.itemCount[index]++;
    data.cost[index] = data.itemPrice[index] * data.itemCount[index];
    totalPrice();

    notifyListeners();
  }

  void decrement(int index) {
    data.itemCount[index]--;
    if (data.itemCount[index] < 0) {
      data.itemCount[index] = 0;
    }
    data.cost[index] = data.itemPrice[index] * data.itemCount[index];
    totalPrice();

    notifyListeners();
  }

  void totalPrice() {
    double cost = 0;
    for (int i = 0; i < data.itemName.length; i++) {
      cost += data.cost[i];
    }
    _totalCost = cost;
    notifyListeners();
  }

  void resetItemCount(int index){
    data.itemCount[index] = 0;
    data.cost[index] = data.itemPrice[index] * data.itemCount[index];
    totalPrice();
    notifyListeners();
  }

}
