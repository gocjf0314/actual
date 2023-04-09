import 'package:actual/restaurant/model/restaurant_model.dart';
import 'package:json_annotation/json_annotation.dart';
import '../../common/utils/data_utils.dart';

part 'restaurant_detail_model.g.dart';

@JsonSerializable()
class RestaurantDetailModel extends RestaurantModel {
  final String detail;

  @JsonKey(toJson: productsToJson)
  final List<RestaurantProductModel> products;

  RestaurantDetailModel({
    required super.id,
    required super.name,
    required super.thumbUrl,
    required super.tags,
    required super.priceRange,
    required super.ratingsCount,
    required super.deliveryTime,
    required super.deliveryFee,
    required super.ratings,
    required this.detail,
    required this.products,
  });

  factory RestaurantDetailModel.fromJson(Map<String, dynamic> json) {
    return _$RestaurantDetailModelFromJson(json);
  }

  @override
  Map<String, dynamic> toJson() => _$RestaurantDetailModelToJson(this);

  static productsToJson(List<RestaurantProductModel> products) {
    return products.map((e) => e.toJson()).toList();
  }
}

@JsonSerializable()
class RestaurantProductModel {
  final String id;
  final String name;
  final String detail;

  @JsonKey(fromJson: DataUtils.pathToUrl)
  final String imgUrl;
  final int price;

  RestaurantProductModel({
    required this.id,
    required this.name,
    required this.detail,
    required this.imgUrl,
    required this.price,
  });

  factory RestaurantProductModel.fromJson(Map<String, dynamic> json) =>
      _$RestaurantProductModelFromJson(json);

  Map<String, dynamic> toJson() => _$RestaurantProductModelToJson(this);
}
