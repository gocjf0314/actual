import 'package:actual/common/model/cursor_pagination_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repository/restaurant_repository.dart';

final restaurantProvider =
StateNotifierProvider<RestaurantStateNotifier, CursorPaginationBase>((ref) {
  final repository = ref.watch(restaurantRepositoryProvider);
  final notifier = RestaurantStateNotifier(restaurantRepository: repository);

  return notifier;
});

class RestaurantStateNotifier extends StateNotifier<CursorPaginationBase> {
  final RestaurantRepository restaurantRepository;

  RestaurantStateNotifier({
    required this.restaurantRepository,
  }) : super(CursorPaginationLoad()) {
    // RestaurantStateNotifier 생성과 동시에
    // paginate 실행
    paginate();
  }

  paginate() async {
    final response = await restaurantRepository.paginate().catchError((error) {
      return CursorPaginationError(message: error.toString());
    });

    state = response;
  }
}