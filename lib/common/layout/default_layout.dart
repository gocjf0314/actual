import 'package:flutter/material.dart';

/// Default Layout
/// 모든 레이아웃에 공통적인 기본 요소로 적용할 때 유용하다
/// 예를들면 아래와 같이 Screen을 Scaffold로 구현 해야 할 때
/// body 속성에 해당 화면에 넣을 요소들을 적용시키면 된다

class DefaultLayout extends StatelessWidget {

  final Color? backgroundColor;
  final String? title;
  final Widget body;
  final Widget? bottomBar;

  const DefaultLayout({
    Key? key,
    required this.body,
    this.title,
    this.backgroundColor,
    this.bottomBar,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor ?? Colors.white,
      appBar: renderAppBar(),
      body: body,
      bottomNavigationBar: bottomBar,
    );
  }

  AppBar? renderAppBar() {
    if(title == null){
      return null;
    }

    return AppBar(
      elevation: 0.0,
      /// ForegroundColor: Element's Color on the AppBar
      foregroundColor: Colors.black,
      backgroundColor: Colors.white,
      title: Text(
        title!,
        style: TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
