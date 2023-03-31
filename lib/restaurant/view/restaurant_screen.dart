import 'package:actual/common/model/cursor_pagination_model.dart';
import 'package:actual/restaurant/provider/restaurant_provider.dart';
import 'package:actual/restaurant/view/restaurant_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../component/restaurant_card.dart';

class RestaurantScreen extends ConsumerWidget {
  const RestaurantScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(restaurantProvider);

    if(state is CursorPaginationLoad) {
      return const Center(child: CircularProgressIndicator());
    } else if(state is CursorPaginationError) {
      return Center(child: Text(state.message));
    }

    final cursorPagination = state as CursorPagination;
    final data = cursorPagination.data;

    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: ListView.separated(
        shrinkWrap: true,
        itemCount: data.length,
        separatorBuilder: (_, index) => const SizedBox(height: 16.0),
        itemBuilder: (_, index) {
          final item = data[index];

          return GestureDetector(
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => RestaurantDetailScreen(
                  restaurantModel: item,
                ),
              ),
            ),
            child: RestaurantCard(restaurant: item),
          );
        },
      ),
    );
  }
}
