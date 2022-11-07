import 'package:flutter/material.dart';

import 'package:actual/common/const/colors.dart';
import 'package:actual/common/layout/default_layout.dart';

import 'package:actual/restaurant/view/restaurant_screen.dart';

class RootTab extends StatefulWidget {

  const RootTab({Key? key}) : super(key: key);

  @override
  State<RootTab> createState() => _RootTabState();
}

class _RootTabState extends State<RootTab> with SingleTickerProviderStateMixin{

  int currentIndex = 0;

  late TabController bottomBarController;

  @override
  void initState() {
    super.initState();

    /// vsync: 현재 탭바를 사용하고 있는 stateful 위젯
    bottomBarController = TabController(
      length: 4,
      vsync: this,
      initialIndex: 0,
    );

    bottomBarController.addListener(tabListener);
  }

  @override
  void dispose() {
    bottomBarController.removeListener(tabListener);
    super.dispose();
  }

  void tabListener() {
    setState(() {
      currentIndex = bottomBarController.index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: '코팩 딜리버리',
      body: TabBarView(
        physics: const NeverScrollableScrollPhysics(),
        controller: bottomBarController,
        children: [
          RestaurantScreen(),
          Container(alignment: Alignment.center, child: Text('음식'),),
          Container(alignment: Alignment.center, child: Text('주문'),),
          Container(alignment: Alignment.center, child: Text('프로필'),),
        ],
      ),
      bottomBar: BottomNavigationBar(
        selectedItemColor: PRIMARY_COLOR,
        unselectedItemColor: BODY_TEXT_COLOR,
        selectedFontSize: 10,
        unselectedFontSize: 10,
        /// 하단바 선택된 아이콘 행동 양식
        type: BottomNavigationBarType.fixed,
        onTap: (int index) {
          if(bottomBarController.index != index){
            bottomBarController.animateTo(index);
          }
        },
        currentIndex: currentIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: '홈',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fastfood_outlined),
            label: '음식',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long_outlined),
            label: '주문',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: '프로필',
          ),
        ],
      ),
    );
  }
}
