import 'package:freezed_annotation/freezed_annotation.dart';

part 'pagination.freezed.dart';
part 'pagination.g.dart';

@freezed
abstract class Pagination<T> with _$Pagination<T> {
  const Pagination._();

  @JsonSerializable(genericArgumentFactories: true)
  const factory Pagination({
    @Default(1) int page,
    @JsonKey(name: 'per_page') @Default(6) int perPage,
    @Default(0) int total,
    @JsonKey(name: 'total_pages') @Default(0) int totalPages,
    @Default([]) List<T> data,
  }) = _Pagination<T>;

  bool get hasNextPage => page < totalPages;

  factory Pagination.initial() => Pagination(
        page: 1,
        perPage: 6,
        total: 0,
        totalPages: 0,
        data: [],
      );

  factory Pagination.fromMap(
    Map<String, dynamic> map,
    List<T> listData,
  ) =>
      Pagination(
        page: map['page'],
        perPage: map['per_page'],
        total: map['total'],
        totalPages: map['total_pages'],
        data: listData,
      );

  factory Pagination.fromJson(
    Map<String, dynamic> json,
    T Function(Object?) fromJsonT,
  ) {
    return _$PaginationFromJson(json, fromJsonT);
  }

  Map<String, dynamic> toJson(Object Function(T) toJsonT) =>
      _$PaginationToJson(this as _Pagination<T>, toJsonT);
}
