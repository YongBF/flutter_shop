import 'package:flutter/material.dart';

class CategoryProvider with ChangeNotifier {
  List _list = [];

  setList(List list) {
    _list = list;
    notifyListeners();
  }

  List get list => _list;
}