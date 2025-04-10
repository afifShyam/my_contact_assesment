import 'package:dio/dio.dart';
import 'package:my_contact/model/contact_model.dart';
import 'package:my_contact/model/pagination.dart';

class ContactRepository {
  final Dio _dio = Dio();

  Future<Pagination<ContactModel>> fetchContacts(int page) async {
    final response = await _dio.get('https://reqres.in/api/users?page=$page');
    final List<ContactModel> data = List<ContactModel>.from(
      (response.data['data']).map((x) => ContactModel.fromJson(x)),
    );
    return Pagination<ContactModel>(data: data);
  }

  Future<ContactModel> addContact(
    String email,
    String firstName,
    String lastName,
    String avatar,
  ) async {
    final response = await _dio.post(
      'https://reqres.in/api/users',
      data: {
        'email': email,
        'first_name': firstName,
        'last_name': lastName,
        'avatar': avatar,
      },
    );

    final data = _normalizeId(response.data);

    return ContactModel.fromJson(data);
  }

  Future<void> deleteContact(int id) async {
    try {
      await _dio.delete('https://reqres.in/api/users/$id');
    } catch (e) {
      throw Exception('$e');
    }
  }

  Future<ContactModel> updateContact({
    required int id,
    required String email,
    required String firstName,
    required String lastName,
    String? avatar,
  }) async {
    final response = await _dio.put(
      'https://reqres.in/api/users/$id',
      data: {
        'email': email,
        'first_name': firstName,
        'last_name': lastName,
        'avatar': avatar,
      },
    );

    final data = _normalizeId(response.data);

    return ContactModel.fromJson(data);
  }

  // 🔧 Helper to normalize ID to int
  Map<String, dynamic> _normalizeId(Map<String, dynamic> data) {
    final idRaw = data['id'];
    final id = int.tryParse(idRaw.toString());
    return {
      ...data,
      'id': id ?? 0,
    };
  }
}
