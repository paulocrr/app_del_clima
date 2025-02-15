import 'package:app_del_clima/core/exceptions/error_cuota_excedida.dart';
import 'package:app_del_clima/core/exceptions/error_desconocido.dart';
import 'package:app_del_clima/core/exceptions/error_en_peticion.dart';
import 'package:app_del_clima/core/exceptions/error_interno_servidor.dart';
import 'package:app_del_clima/core/exceptions/error_no_autorizado.dart';
import 'package:app_del_clima/core/exceptions/error_no_encontrado.dart';
import 'package:app_del_clima/core/exceptions/error_sin_coneccion.dart';
import 'package:dio/dio.dart';

class NetworkDataSource {
  late Dio dio;
  NetworkDataSource({Dio? dio}) {
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
    try {
      final response = await dio.get(path, queryParameters: params);

      return response.data;
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionError) {
        throw ErrorSinConeccion();
      } else {
        final respuestaError = e.response;
        if (respuestaError?.statusCode == 400) {
          throw ErrorEnPeticion();
        } else if (respuestaError?.statusCode == 401) {
          throw ErrorNoAutorizado();
        } else if (respuestaError?.statusCode == 404) {
          throw ErrorNoEncontrado();
        } else if (respuestaError?.statusCode == 429) {
          throw ErrorCuotaExcedida();
        } else if (respuestaError?.statusCode == 500) {
          throw ErrorInternoServidor();
        } else {
          throw ErrorDesconocido();
        }
      }
    } catch (e) {
      throw ErrorDesconocido();
    }
  }
}
