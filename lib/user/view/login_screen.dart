import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

import 'package:actual/common/layout/default_layout.dart';
import 'package:actual/common/component/custom_text_form_field.dart';
import 'package:actual/common/const/colors.dart';
import 'package:actual/common/const/data.dart';

import 'package:actual/common/view/root_tab.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  // For Networking
  final Dio dio = Dio();

  String userName = '';
  String password = '';

  Future signIn(context) async{
    // When press this button, request token to this path
    //
    // Server Url for signing
    String requestUrl = 'http://${getIPByPlatform()}/auth/login';

    // Plain auth data(ID:PW)
    // data before encoded
    final String rawString = '$userName:$password';

    // Encoding way is "Base 64"
    // Codec<T, S> => Get T type data And Return S type data
    // Convert Raw string to string encoded way to Base64
    // Codec: utf8. This is Public Codec
    Codec<String, String> stringToBase64 = utf8.fuse(base64);

    // Data that encoding raw string(plain data)
    String token = stringToBase64.encode(rawString);
    print('Encoding: Token is $token');

    try{
      final response = await dio.post(
        requestUrl,
        // Options => Define data for getting token
        options: Options(
          headers: {
            'authorization' : 'Basic $token',
          },
        ),
      );

      // response.data is Body of response
      print('Response Data is ${response.data}');

      String refreshToken = response.data['refreshToken'];
      String accessToken = response.data['accessToken'];

      await secureStorage.write(key: REFRESH_TOKEN_KEY, value: refreshToken);
      await secureStorage.write(key: ACCESS_TOKEN_KEY, value: accessToken);

      if(!mounted) return;

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => RootTab()),
        (route) => false,
      );
    } catch(error){
      print('SignIn Error: $error');
    }
  }

  Future signUp() async{
    String? refreshToken = await secureStorage.read(key: REFRESH_TOKEN_KEY);
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
      // 'response.data' is body of response
      print('SingUp response is ${response.data}');
    } catch(error){
      print('SignUp Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {

    return DefaultLayout(
      body: SafeArea(
        top: true,
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
          ),
          // TextFormField 키보드 올라올 때
          // 화면 범위 초과로
          // 레이아웃 깨짐 현상 방지
          child: SingleChildScrollView(
            // 키보드 없애는 행동 양식
            // manual: done(완료) 버튼 눌러서 없앤다
            // onDrag: 끌어내려서 없앤다
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const _Title(),
                const SizedBox(height: 16,),
                const _SubTitle(),
                Image.asset(
                  'asset/img/misc/logo.png',
                  width: MediaQuery.of(context).size.width * 2/3,
                ),
                CustomTextFormField(
                  hintText: '이메일을 입력해 주세요',
                  onChanged: (value) {
                    userName = value;
                  },
                ),
                const SizedBox(height: 16,),
                CustomTextFormField(
                  hintText: '비밀번호를 입력해 주세요',
                  onChanged: (value) {
                    password = value;
                  },
                  obscureText: true,
                ),
                const SizedBox(height: 16,),
                ElevatedButton(
                  onPressed: () async => await signIn(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: PRIMARY_COLOR,
                  ),
                  child: Text('로그인'),
                ),
                TextButton(
                  onPressed: () async => await signUp(),
                  style: TextButton.styleFrom(
                    // TextButton.styleForm 에서
                    // 글자 색 변경시 backgroundColor 가 아닌
                    // foregroundColor 로 색 지정
                    foregroundColor: Colors.black,
                  ),
                  child: Text('회원가입'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// 메인 위젯 요소로 들어가는 하위 위젯들
///   private 으로 사용하기 위해
///   클래스 명 앞에 언더바 붙이고
///   같은 파일 안에서 사용하는 방법
class _Title extends StatelessWidget {
  const _Title({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Text(
      '환영합니다!',
      style: TextStyle(
        fontSize: 34,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}

class _SubTitle extends StatelessWidget {
  const _SubTitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Text(
      '이메일과 비밀번호를 입력해서 로그인 해주세요.'
          '\n오늘도 성공적인 주문이 되길 :)',
      style: TextStyle(
        fontSize: 16,
        color: BODY_TEXT_COLOR,
      ),
    );
  }
}


