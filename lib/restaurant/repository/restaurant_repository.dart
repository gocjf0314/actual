import 'package:actual/common/model/cursor_pagination_model.dart';
import 'package:actual/restaurant/model/restaurant_detail_model.dart';
import 'package:actual/restaurant/model/restaurant_model.dart';
import 'package:dio/dio.dart' hide Headers;
import 'package:retrofit/retrofit.dart';

part 'restaurant_repository.g.dart';

@RestApi()
abstract class RestaurantRepository {
  // http://${getIPByPlatform()}/restaurant
  factory RestaurantRepository(Dio dio, {String baseUrl}) =
  _RestaurantRepository;

  // http://${getIPByPlatform()}/restaurant/
  @GET('/')
  @Headers({
    'accessToken': 'true',
  })
  Future<CursorPagination<RestaurantModel>> paginate();

  // http://${getIPByPlatform()}/restaurant/{id}
  // accessToken 혹은 refreshToken 값이 필요한 요청일 경우
  // {'accessToken' : 'true'}을 포함시켜서 요청 할 때 마다
  // 강제로 새로운 값을 받도록 설정
  @GET('/{id}')
  @Headers({
    'accessToken': 'true',
  })
  Future<RestaurantDetailModel> getRestaurantDetail({
    @Path('id') required String id,
  });
}