import 'package:actual/common/const/data.dart';
import 'package:actual/restaurant/model/restaurant_model.dart';
import 'package:actual/restaurant/view/restaurant_detail_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../component/restaurant_card.dart';

class RestaurantScreen extends StatefulWidget {
  const RestaurantScreen({Key? key}) : super(key: key);

  @override
  State<RestaurantScreen> createState() => _RestaurantScreenState();
}

class _RestaurantScreenState extends State<RestaurantScreen> {

  Future<List> paginateRestaurant() async{
    final dio = Dio();

    String requestUrl = 'http://${getIPByPlatform()}/restaurant';

    final accessToken = await secureStorage.read(key: ACCESS_TOKEN_KEY);

    final response = await dio.get(
      requestUrl,
      options: Options(
        headers: {
          'authorization' : 'Bearer $accessToken',
        },
      ),
    );

    // response.data 에
    // meta : { ... } 와 data : { ... }가 있다
    // 현재 상품 정보를 담고 있는 데이터의 키는 "data"이다
    // meta 부분에는 url query 를 담고 있다
    return response.data['data'];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Center(
        child: FutureBuilder<List>(
          future: paginateRestaurant(),
          builder: (context, AsyncSnapshot<List> snapshot) {
            if(!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            return ListView.separated(
              shrinkWrap: true,
              itemCount: snapshot.data!.length,
              separatorBuilder: (_, index) => const SizedBox(height: 16.0),
              itemBuilder: (_, index) {
                final item = snapshot.data![index];

                final parsedItem = RestaurantModel.fromJson(item);

                return GestureDetector(
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => RestaurantDetailScreen(
                        restaurantModel: parsedItem,
                      ),
                    ),
                  ),
                  child: RestaurantCard(restaurant: parsedItem),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
