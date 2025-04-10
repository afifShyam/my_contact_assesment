import 'package:freezed_annotation/freezed_annotation.dart';

part 'contact_model.freezed.dart';
part 'contact_model.g.dart';

@freezed
sealed class ContactModel with _$ContactModel {
  factory ContactModel({
    required int id,
    required String email,
    @JsonKey(name: 'first_name') required String firstName,
    @JsonKey(name: 'last_name') required String lastName,
    @JsonKey(name: 'avatar') String? image,
    @Default(false) bool isFav,
  }) = _ContactModel;

  factory ContactModel.initial() => ContactModel(
        id: 0,
        email: '',
        firstName: '',
        lastName: '',
        image: 'https://static-00.iconduck.com/assets.00/person-icon-2048x1935-84jiekjd.png',
        isFav: false,
      );

  factory ContactModel.fromJson(Map<String, dynamic> json) => _$ContactModelFromJson(json);
}
