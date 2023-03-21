import 'package:actual/common/layout/default_layout.dart';
import 'package:actual/product/component/product_card.dart';
import 'package:actual/restaurant/component/restaurant_card.dart';
import 'package:actual/restaurant/model/restaurant_detail_model.dart';
import 'package:actual/restaurant/model/restaurant_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../common/const/data.dart';

class RestaurantDetailScreen extends StatelessWidget {
  final RestaurantModel restaurantModel;

  const RestaurantDetailScreen({
    required this.restaurantModel,
    Key? key,
  }) : super(key: key);

  Future<Map<String, dynamic>> getRestaurantDetail() async{
    final dio = Dio();

    String requestUrl = 'http://${getIPByPlatform()}/restaurant/${restaurantModel.id}';

    final accessToken = await secureStorage.read(key: ACCESS_TOKEN_KEY);

    final response = await dio.get(
      requestUrl,
      options: Options(
        headers: {
          'authorization': 'Bearer $accessToken',
        },
      ),
    );

    return response.data as Map<String, dynamic>;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: restaurantModel.name,
      body: FutureBuilder<Map<String, dynamic>>(
        future: getRestaurantDetail(),
        builder: (_, snapshot) {
          if(!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final item = RestaurantDetailModel.fromJson(snapshot.data!);

          return CustomScrollView(
            slivers: [
              renderTop(model: item),
              renderLabel(),
              renderProducts(products: item.products),
            ],
          );
        },
      ),
    );
  }

  renderProducts({required List<ProductModel> products}) {
    return SliverPadding(
      padding: const EdgeInsets.all(16.0),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          childCount: products.length,
          (context, index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: ProductCard(product: products[index]),
            );
          },
        ),
      ),
    );
  }

  SliverToBoxAdapter renderLabel() {
    return const SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Text(
          '메뉴',
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  SliverToBoxAdapter renderTop({
    required RestaurantDetailModel model,
  }) {
    return SliverToBoxAdapter(
      child: RestaurantCard(
        restaurant: model,
        isDetail: true,
        detail: model.detail,
      ),
    );
  }
}
