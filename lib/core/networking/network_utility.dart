import 'package:dio/dio.dart';

class NetworkUtility {
  late Dio dio;
  NetworkUtility({Dio? dio}) {
    if (dio == null) {
      this.dio = Dio(
        BaseOptions(
          baseUrl: 'https://api.openweathermap.org/data/2.5',
          responseType: ResponseType.json,
        ),
      );
    } else {
      this.dio = dio;
    }
  }

  Future<dynamic> peticionesGet({
    required String path,
    Map<String, dynamic> params = const {},
  }) async {
    final response = await dio.get(path, queryParameters: params);
    return response.data;
  }
}
