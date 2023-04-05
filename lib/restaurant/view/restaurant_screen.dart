import 'package:actual/common/model/cursor_pagination_model.dart';
import 'package:actual/restaurant/provider/restaurant_provider.dart';
import 'package:actual/restaurant/view/restaurant_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../component/restaurant_card.dart';

class RestaurantScreen extends ConsumerStatefulWidget {
  const RestaurantScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<RestaurantScreen> createState() => _RestaurantScreenState();
}

class _RestaurantScreenState extends ConsumerState<RestaurantScreen> {
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    scrollController.addListener(scrollListener);
  }

  void scrollListener() {
    // 현재 위치가 끝 부분에 다다르기 직전이면 데이터 추가 요청
    if(scrollController.offset > scrollController.position.maxScrollExtent - 300) {
      ref.read(restaurantProvider.notifier).paginate(fetchMore: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(restaurantProvider);

    if(state is CursorPaginationLoad) {
      return const Center(child: CircularProgressIndicator());
    }
    if(state is CursorPaginationError) {
      return Center(child: Text(state.message));
    }

    final cursorPagination = state as CursorPagination;
    final data = cursorPagination.data;

    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: ListView.separated(
        controller: scrollController,
        shrinkWrap: true,
        itemCount: data.length + 1,
        separatorBuilder: (_, index) => const SizedBox(height: 16.0),
        itemBuilder: (_, index) {
          if(index == data.length) {
            return Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(8.0),
              child: cursorPagination is CursorPaginationFetchingMore
                  ? CircularProgressIndicator()
                  : Text('마지막 데이터 입니다'),
            );
          }

          final item = data[index];

          return GestureDetector(
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => RestaurantDetailScreen(
                  restaurantModel: item,
                ),
              ),
            ),
            child: RestaurantCard.fromModel(model: item),
          );
        },
      ),
    );
  }
}
