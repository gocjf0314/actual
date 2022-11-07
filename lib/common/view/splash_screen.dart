import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

import 'package:actual/common/layout/default_layout.dart';
import 'package:actual/common/const/colors.dart';
import 'package:actual/common/const/data.dart';
import 'package:actual/common/view/root_tab.dart';
import 'package:actual/user/view/login_screen.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  bool existToken = false;

  @override
  void initState() {
    super.initState();
    checkExistToken();
  }

  void checkExistToken() async{
    final Dio dio = Dio();

    final refreshToken = await secureStorage.read(key: REFRESH_TOKEN_KEY);
    final accessToken = await secureStorage.read(key: ACCESS_TOKEN_KEY);

    if(refreshToken == null || refreshToken.isEmpty){
      print('Please request refreshToken');
      return;
    }

    String requestUrl = 'http://${getIPByPlatform()}/auth/token';

    try{
      final response = await dio.post(
        requestUrl,
        options: Options(
          headers: {
            'authorization' : 'Bearer $refreshToken',
          },
        ),
      );
      print(response.data);

      // 'response.data' is body of response
      // RefreshToken 을 통해 재발금 받은 AccessToken
      String newAccess = response.data['accessToken'];

      if(newAccess != accessToken){
        print('Store accessToken ');
        await secureStorage.write(key: ACCESS_TOKEN_KEY, value: newAccess);
      }

      if(!mounted) return;

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => RootTab()),
            (route) => false,
      );

    } catch(error){
      /// 토큰 값 제대로 못 받아 오면
      /// 로그인 페이지로 이동 시킴
      print('SignUp Error: $error');

      final refreshToken = await secureStorage.read(key: REFRESH_TOKEN_KEY);
      final accessToken = await secureStorage.read(key: ACCESS_TOKEN_KEY);

      print('RefreshToken: $refreshToken');
      print('AccessToken: $accessToken');

      if(!mounted) return;

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => LoginScreen()),
            (route) => false,
      );
    }
  }

  // void deleteToken() async{
  //   await secureStorage.deleteAll();
  // }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      backgroundColor: PRIMARY_COLOR,
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'asset/img/logo/logo.png',
              width: MediaQuery.of(context).size.width / 2,
            ),
            const Padding(
              padding: EdgeInsets.all(10),
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
