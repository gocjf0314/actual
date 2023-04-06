import 'package:actual/common/proivder/pagination_provider.dart';
import 'package:flutter/cupertino.dart';

class PaginationUtils {
  static void paginate({
    required ScrollController scrollController,
    required PaginationProvider paginationProvider,
  }) {
    if(scrollController.offset > scrollController.position.maxScrollExtent - 300) {
      paginationProvider.paginate(fetchMore: true);
    }
  }
}