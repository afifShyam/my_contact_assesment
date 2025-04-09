import 'package:dio/dio.dart';
import 'package:my_contact/model/contact_model.dart';
import 'package:my_contact/model/pagination.dart';

class ContactRepository {
  final Dio _dio = Dio();
  Future<Pagination<ContactModel>> fetchContacts(
    int page,
  ) async {
    final Response response = await _dio.get('https://reqres.in/api/users?page=$page');
    final List<ContactModel> data = List<ContactModel>.from(
      (response.data['data']).map((x) => ContactModel.fromJson(x)),
    );

    return Pagination<ContactModel>(
      data: data,
    );
  }
}
