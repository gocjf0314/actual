import 'package:flutter/material.dart';

import 'package:actual/common/view/splash_screen.dart';

void main() async{
  runApp(const _App());
}

class _App extends StatelessWidget {
  const _App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'NotoSans',
      ),
      home: SplashScreen(),
    );
  }
}
