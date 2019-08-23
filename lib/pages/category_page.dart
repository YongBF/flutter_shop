import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_shop/provider/category_provider.dart';
import 'package:provider/provider.dart';
import '../service/service_method.dart';
import '../model/category.dart';
import 'dart:convert';

class CategoryPage extends StatelessWidget {
  const CategoryPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(builder: (_) => CategoryProvider(),)
      ],
      child: Scaffold(
        appBar: AppBar(
          title: Text('商品分类'),
        ),
        body: Container(
          child: Row(
            children: <Widget>[
              LeftCategory(),
              Column(
                children: <Widget>[
                  RightCategoryNav()
                ],
              )
            ],
          ),
        )
      )
    );
  }
}


class LeftCategory extends StatefulWidget {
  LeftCategory({Key key}) : super(key: key);

  _LeftCategoryState createState() => _LeftCategoryState();
}

class _LeftCategoryState extends State<LeftCategory> {

  List list = [];
  int currentIndex = 0;

  void _getCategory() async {
    await request('getCategory').then((val) {
      var data = json.decode(val.toString());
      CategoryModel category = CategoryModel.fromJson(data);
      setState(() {
       list = category.data; 
      });
      Provider.of<CategoryProvider>(context).setList(list[0].bxMallSubDto);
    });
  }

  @override
  void initState() {
    super.initState();
    _getCategory();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ScreenUtil().setWidth(180),
      decoration: BoxDecoration(
        border: Border(
          right: BorderSide(
            width: 1,
            color: Colors.black12
          )
        )
      ),
       child: ListView.builder(
         itemCount: list.length,
         itemBuilder: (context, index) {
           return _leftItem(index);
         },
       ),
    );
  }

  Widget _leftItem(int index) {
    return InkWell(
      onTap: () {
        Provider.of<CategoryProvider>(context).setList(list[index].bxMallSubDto);
        setState(() {
         currentIndex = index; 
        });
      },
      child: Container(
        height: ScreenUtil().setHeight(100),
        padding: EdgeInsets.only(left: 10, top: 20),
        decoration: BoxDecoration(
          color: index == currentIndex ? Colors.black12 : Colors.white,
          border: Border(
            bottom: BorderSide(width: 1, color: Colors.black12)
          )
        ),
        child: Text(list[index].mallCategoryName, style: TextStyle(fontSize: ScreenUtil().setSp(28)),),
      ),
    );
  }
}

class RightCategoryNav extends StatefulWidget {
  RightCategoryNav({Key key}) : super(key: key);

  _RightCategoryNavState createState() => _RightCategoryNavState();
}

class _RightCategoryNavState extends State<RightCategoryNav> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenUtil().setHeight(80),
      width: ScreenUtil().setWidth(570),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            width: 1,
            color: Colors.black12
          )
        )
      ),
      child: Consumer<CategoryProvider>(builder: (context, category, _) {
        return ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: category.list.length,
          itemBuilder: (context, index) {
            return _rightNavItem(category.list[index]);
          }
        );
      },)
    );
  }

  Widget _rightNavItem(CategoryMallModel item) {
    return InkWell(
      onTap: () {},
      child: Container(
        padding: EdgeInsets.fromLTRB(5.0, 10.0, 5.0, 10.0),
        child: Text(
          item.mallSubName,
          style: TextStyle(fontSize: ScreenUtil().setSp(28)),
        ),
      ),
    );
  }
}