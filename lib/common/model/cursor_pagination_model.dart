import 'package:json_annotation/json_annotation.dart';

part 'cursor_pagination_model.g.dart';

/// Settings for Using [JsonSerializable] with [Generic]
/// [Decorator]
/// @JsonSerializable(
///   genericArgumentFactories: true,
/// )
///
/// [DeclareClass]
/// class A<T> {
///   ...
///   List<T> list;
///   ...
/// }
///
/// [fromJson] in A
/// factory A.fromJson(
///   Map<String, dynamic> json,
///   T Function(Object? object) [fromJsonT],
/// ) => ...
///   fromJsonT 함수가 json 데이터를 T타입으로 변환한다.
///   단, 이때 T타입은 fromJson 함수를 가지고 있어야 한다.
///
///   [A.g.dart]
///   json['variable_name'] as List<dynamic>).map([fromJsonT]).toList()

@JsonSerializable(
  genericArgumentFactories: true,
)
class CursorPagination<T> {
  final CursorPaginationMeta meta;
  final List<T> data;

  CursorPagination({
    required this.meta,
    required this.data,
  });

  factory CursorPagination.fromJson(
    Map<String, dynamic> json,
    T Function(Object? object) fromJsonT,
  ) => _$CursorPaginationFromJson(json, fromJsonT);
}

@JsonSerializable()
class CursorPaginationMeta {
  final int count;
  final bool? moreHas;

  CursorPaginationMeta({
    required this.count,
    required this.moreHas,
  });

  factory CursorPaginationMeta.fromJson(Map<String, dynamic> json)
  => _$CursorPaginationMetaFromJson(json);

  Map<String, dynamic> toJson() => _$CursorPaginationMetaToJson(this);
}