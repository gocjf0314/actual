import 'package:actual/common/const/data.dart';
import 'package:actual/common/dio/dio.dart';
import 'package:actual/common/model/cursor_pagination_model.dart';
import 'package:actual/common/repository/base_pagination_repository.dart';
import 'package:actual/product/model/product_model.dart';
import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retrofit/http.dart';
import '../../common/model/pagination_params.dart';

part 'product_repository.g.dart';

final productRepositoryProvider = Provider<ProductRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return ProductRepository(dio, baseUrl: 'http://${getIPByPlatform()}/product');
});

// http://${getIPByPlatform}/product
@RestApi()
abstract class ProductRepository<T> implements IBasePaginationRepository<ProductModel> {
  factory ProductRepository(Dio dio, {String baseUrl}) = _ProductRepository;

  @GET('/')
  @Headers({'accessToken': 'true'})
  @override
  Future<CursorPagination<ProductModel>> paginate({
    PaginationParams? params = const PaginationParams(),
  });
}
