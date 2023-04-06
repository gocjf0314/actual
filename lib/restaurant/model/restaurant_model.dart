import 'package:actual/common/model/model_with_id.dart';
import 'package:actual/common/utils/data_utils.dart';
import 'package:json_annotation/json_annotation.dart';

/// Creating '*.g.dart' file for json serialization
/// Run in terminal: flutter pub run build_runner build
///   1회성 빌드 트리거. json 직렬화를 위해 해당 파일을 생성하여
///   part '*.g.dart'; 로 활용
///
/// Run in terminal: flutter pub run build_runner watch
///   더 편리한 코드 생성 프로세스를 제공한다.
///   프로젝트 파일의 변경사항을 감지하여 필요할 때 맞춰서
///   generated dart file 을 빌드한다.
///
/// File Nesting
///   .g.dart 형식을 추가하여 직접적으로 사용하지 않는 파일,
///   중요하지 않은 숨기기 기능 사용. 해당 파일과 상응하는 소스코드 파일의 캐럿을 누르면 표시 된다.
part 'restaurant_model.g.dart';

enum RestaurantPriceRange {
  expensive,
  medium,
  cheap,
}

/// 매핑된 json 데이터로 부터 모델에 값을 할당하는 과정에서
/// json['key'] 처럼 변수 하나 하나를 하드코딩으로 작성해 주어야 하는 불편함이 있다.
/// 이를 자동화 하기 위해 [JsonSerializable]을 사용
@JsonSerializable()
class RestaurantModel implements IModelWithId{
  @override
  final String id;

  final String name;

  /// Data return type is T
  /// static String function(String value) {
  ///   return '...${thumbsUrl}...';
  /// }
  /// [value] is json['variable_name']
  /// [static] keyword must be added
  @JsonKey(fromJson: DataUtils.pathToUrl)
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

  factory RestaurantModel.fromJson(Map<String, dynamic> json) => _$RestaurantModelFromJson(json);

  Map<String, dynamic> toJson() => _$RestaurantModelToJson(this);
}
