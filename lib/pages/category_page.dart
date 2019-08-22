import 'package:flutter/material.dart';
import '../service/service_method.dart';
import '../model/category.dart';
import 'dart:convert';

class CategoryPage extends StatelessWidget {
  const CategoryPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    _getCategory();
    return Container(
      child: Text(''),
    );
  }

  void _getCategory() async {
    await request('getCategory').then((val) {
      var data = json.decode(val.toString());
      CategoryModel category = CategoryModel.fromJson(data);
      print('获取数据.........................');
      print(category);
    });
  }
}