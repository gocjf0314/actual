enum RestaurantPriceRange{
  expensive,
  medium,
  cheap,
}

class RestaurantModel{

  final String id;
  final String name;
  final String thumbUrl;
  final List<String> tags;
  final RestaurantPriceRange priceRange;
  final int ratingsCount;
  final int deliveryTime;
  final int deliveryFee;
  final double ratings;

  RestaurantModel({
    required this.id,
    required this.name,
    required this.thumbUrl,
    required this.tags,
    required this.priceRange,
    required this.ratingsCount,
    required this.deliveryTime,
    required this.deliveryFee,
    required this.ratings,
  });

}