import 'package:actual/common/const/data.dart';
import 'package:actual/common/secure_storage/secure_storage.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// [Interceptor]
/// 1) onRequest
/// 2) onResponse
/// 3) onError
/// [Options]
/// method: GET, POST, PATCH, DELETE, ...

final dioProvider = Provider<Dio>((ref) {
  final dio = Dio();
  final secureStorage = ref.watch(secureStorageProvider);

  dio.interceptors.add(
    CustomInterceptor(
      secureStorage: secureStorage,
    ),
  );

  return dio;
});

class CustomInterceptor extends Interceptor{
  final FlutterSecureStorage secureStorage;

  CustomInterceptor({required this.secureStorage});

  /// 1) Send request
  // 요청을 보낼 때 헤더에 'accessToken' : 'true'이 존재한다면
  // secure storage를 통해 새로운 토큰 값을 받아와서 할당한다.
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    print('[REQ] [${options.method}] ${options.uri}');

    if(options.headers['accessToken'] == 'true') {
      // 기존 토큰 값을 제거.
      options.headers.remove('accessToken');

      // 새로운 토큰 값을 받아와서 할당.
      final accessToken = await secureStorage.read(key: ACCESS_TOKEN_KEY);
      options.headers.addAll({
        'authorization': 'Bearer $accessToken',
      });
    }

    if(options.headers['refreshToken'] == 'true') {
      // 기존 토큰 값을 제거.
      options.headers.remove('refreshToken');

      // 새로운 토큰 값을 받아와서 할당.
      final accessToken = await secureStorage.read(key: REFRESH_TOKEN_KEY);
      options.headers.addAll({
        'authorization': 'Bearer $accessToken',
      });
    }

    return super.onRequest(options, handler);
  }

  /// 2) Receive response
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    print('[RES] [${response.requestOptions.method}] ${response.requestOptions.uri}');

    return super.onResponse(response, handler);
  }

  /// 3) Occurred error
  @override
  void onError(DioError err, ErrorInterceptorHandler handler) async {
    // Status Code: 401
    //  토큰 재발급 시도 -> 재발급 된 토큰으로 새로운 요청
    print('[ERR]: [${err.requestOptions.method}] ${err.requestOptions.uri}');

    final refreshToken = await secureStorage.read(key: REFRESH_TOKEN_KEY);
    if(refreshToken == null) {
      // 원하는 정보가 잘못된 값으로 들어올 경우 에러 반환하기
      return handler.reject(err);
    }

    final isStatus401 = err.response?.statusCode == 401;
    final isPathRefresh = err.requestOptions.path == '/auth/token';
    if(isStatus401 && !isPathRefresh) {
      final dio = Dio();
      try {
        final response = await dio.post(
          'http://${getIPByPlatform()}/auth/token',
          options: Options(
            headers: {'authorization': 'Bearer: $refreshToken'},
          ),
        );
        final accessToken = response.data['accessToken'];

        final options = err.requestOptions;
        options.headers.addAll({'authorization': 'Bearer $accessToken'});

        await secureStorage.write(key: ACCESS_TOKEN_KEY, value: accessToken);

        // 똑같은 요청을 토큰만 새로 바꾸어서 요청 재전송
        // options: 기존에 에러를 발생시킨 옵션과 관련 된 모든 정보들
        // 실제로 에러가 나지 않은 것 처럼 보여줌
        final res = await dio.fetch(options);

        // 에러가 발생했을 때 정해진 값을 넣어서 보내 주어야 하는 경우
        // 직접적으로 상황을 컨트롤 하는 방법
        // 해당 코드 라인에서 반환 목적: 정상적인 응답이 왔음을 알림
        return handler.resolve(res);
      } catch(e) {
        return handler.reject(err);
      }
    }

    return super.onError(err, handler);
  }
}