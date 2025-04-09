import 'package:freezed_annotation/freezed_annotation.dart';

part 'pagination.freezed.dart';
part 'pagination.g.dart';

@freezed
abstract class Pagination<T> with _$Pagination<T> {
  const Pagination._();

  @JsonSerializable(genericArgumentFactories: true)
  const factory Pagination({
    @Default(1) int page,
    @JsonKey(name: 'per_page') @Default(20) int perPage,
    @Default(0) int total,
    @JsonKey(name: 'total_pages') @Default(0) int totalPages,
    @Default([]) List<T> data,
  }) = _Pagination<T>;

  bool get hasNextPage => page < totalPages;

  factory Pagination.initial() => Pagination(
        page: 1,
        perPage: 20,
        total: 0,
        totalPages: 0,
        data: [],
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

class PaginationConverter<T> implements JsonConverter<Pagination<T>, Map<String, dynamic>> {
  final T Function(Map<String, dynamic>) fromJsonT;
  final Map<String, dynamic> Function(T) toJsonT;

  const PaginationConverter({
    required this.fromJsonT,
    required this.toJsonT,
  });

  @override
  Pagination<T> fromJson(Map<String, dynamic> json) {
    return Pagination<T>(
      page: json['page'] as int,
      perPage: json['per_page'] as int,
      total: json['total'] as int,
      totalPages: json['total_pages'] as int,
      data: (json['data'] as List<dynamic>)
          .map((item) => fromJsonT(item as Map<String, dynamic>))
          .toList(),
    );
  }

  @override
  Map<String, dynamic> toJson(Pagination<T> instance) {
    return {
      'page': instance.page,
      'per_page': instance.perPage,
      'total': instance.total,
      'total_pages': instance.totalPages,
      'data': instance.data.map(toJsonT).toList(),
    };
  }
}
