import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_shop/service/service_method.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with AutomaticKeepAliveClientMixin {

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return Container(
       child: Scaffold(
         appBar: AppBar(
           title: Text('百姓生活+'),
         ),
         body: SingleChildScrollView(
           child: FutureBuilder(
             future: getHomePageContent(),
             builder: (context, snapshot) {
               if(snapshot.hasData) {
                 var data = json.decode(snapshot.data.toString());
                 List<Map> swiperDataList = (data['data']['slides'] as List).cast();
                 List<Map> navigatorList = (data['data']['category'] as List).cast();
                 if(navigatorList.length > 10) {
                   navigatorList.removeRange(10, navigatorList.length);
                 }
                 String advertPicture = data['data']['advertesPicture']['PICTURE_ADDRESS'];
                 String leaderImage = data['data']['shopInfo']['leaderImage'];
                 String leaderPhone = data['data']['shopInfo']['leaderPhone'];
                 List<Map> recommendList = (data['data']['recommend'] as List).cast();
                 return SingleChildScrollView(
                   child: Column(
                    children: <Widget>[
                      SwiperDIY(swiperDataList: swiperDataList),
                      TopNavigator(navigatorList: navigatorList),
                      AdBanner(advertPicture: advertPicture),
                      LeaderPhone(leaderImage: leaderImage,leaderPhone: leaderPhone),
                      Recommend(recommendList: recommendList)
                    ],
                  )
                 );
               } else {
                 return Center(
                   child: Text('加载中...'),
                 );
               }
             },
           ),
         ),
       ),
    );
  }
}

class SwiperDIY extends StatelessWidget { //轮播图
  final List swiperDataList;
  const SwiperDIY({Key key, this.swiperDataList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ScreenUtil().setWidth(750),
      height: ScreenUtil().setHeight(333),
      child: Swiper(
        itemCount: swiperDataList.length,
        itemBuilder: (context, index) {
          return Image.network('${swiperDataList[index]['image']}', fit: BoxFit.fill);
        },
        pagination: new SwiperPagination(),
        autoplay: true,
      ),
    );
  }
}

class TopNavigator extends StatelessWidget { //顶部导航
  final List navigatorList;
  const TopNavigator({Key key, this.navigatorList}) : super(key: key);

  Widget _gridViewItemUI(context, item) {
    return InkWell(
      child: Column(
        children: <Widget>[
          Image.network(item['image'], width: ScreenUtil().setWidth(95)),
          Text(item['mallCategoryName'])
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenUtil().setHeight(320),
      padding: EdgeInsets.all(3.0),
      child: GridView.count(
        crossAxisCount: 5,
        padding: EdgeInsets.all(5.0),
        children: navigatorList.map((item) {
          return _gridViewItemUI(context, item);
        }).toList(),
      ),
    );
  }
}

class AdBanner extends StatelessWidget { //广告
  final String advertPicture;
  const AdBanner({Key key, this.advertPicture}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Image.network(advertPicture),
    );
  }
}

class LeaderPhone extends StatelessWidget { //电话拨打
  final String leaderImage;
  final String leaderPhone;
  const LeaderPhone({Key key, this.leaderImage, this.leaderPhone}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: InkWell(
        child: Image.network(leaderImage),
        onTap: () {
          _launchUrl();
        },
      ),
    );
  }

  void _launchUrl() async {
    String url = 'tel:' + leaderPhone;
    if(await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'can not launch this phone';
    }
  }
}

class Recommend extends StatelessWidget {
  final List recommendList;
  const Recommend({Key key, this.recommendList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          _titleWidget(),
          _recommendList()
        ],
      ),
    );
  }

  Widget _titleWidget() {
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.fromLTRB(10.0, 2.0, 0.0, 5.0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(width: 1.0, color: Colors.white12)
        )
      ),
      child: Text(
        '商品推荐',
        style: TextStyle(color: Colors.pink),
      ),
    );
  }

  Widget _recommendItem(index) {
    return InkWell(
      child: Container(
        height: ScreenUtil().setHeight(330),
        width: ScreenUtil().setWidth(250),
        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            left: BorderSide(
              width: index == 0 ? 0.0 : 0.5,
              color: Colors.grey
            )
          )
        ),
        child: Column(
          children: <Widget>[
            Image.network(recommendList[index]['image']),
            Text('￥${recommendList[index]['mallPrice']}'),
            Text(
              '￥${recommendList[index]['price']}',
              style: TextStyle(
                decoration: TextDecoration.lineThrough,
                color: Colors.grey
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _recommendList() {
    return Container(
      height: ScreenUtil().setHeight(330),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: recommendList.length,
        itemBuilder: (context, index) {
          return _recommendItem(index);
        }
      ),
    );
  }
}