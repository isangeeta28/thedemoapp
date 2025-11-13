import 'package:dio/dio.dart';
import '../models/experience_model.dart';

class ApiService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://staging.chamberofsecrets.8club.co',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

  Future<List<Experience>> getExperiences() async {
    try {
      final response = await _dio.get('/v1/experiences?active=true');

      if (response.statusCode == 200) {
        final List<dynamic> experiencesJson =
        response.data['data']['experiences'];
        return experiencesJson
            .map((json) => Experience.fromJson(json))
            .toList();
      } else {
        throw Exception('Failed to load experiences');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    }
  }
}