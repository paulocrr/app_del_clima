import 'package:app_del_clima/core/configs/configs.dart';
import 'package:app_del_clima/core/exceptions/error_cuota_excedida.dart';
import 'package:app_del_clima/core/exceptions/error_en_peticion.dart';
import 'package:app_del_clima/core/exceptions/error_interno_servidor.dart';
import 'package:app_del_clima/core/exceptions/error_no_autorizado.dart';
import 'package:app_del_clima/core/exceptions/error_no_encontrado.dart';
import 'package:app_del_clima/core/exceptions/error_sin_coneccion.dart';
import 'package:app_del_clima/core/failures/failure.dart';
import 'package:app_del_clima/data_sources/network_data_source.dart';
import 'package:app_del_clima/models/temperatura_actual.dart';
import 'package:dartz/dartz.dart';

class ClimaRepository {
  late NetworkDataSource _networkDataSource;
  final _path = '/weather';
  ClimaRepository() {
    _networkDataSource = NetworkDataSource();
  }

  Future<Either<Failure, TemperaturaActual>> obtenerClimaPorCiudad(
      String ciudad) async {
    try {
      final data = await _networkDataSource.peticionesGet(path: _path, params: {
        'q': ciudad,
        'appid': Configs.weatherApiKey,
        'units': 'metric',
        'lang': 'es',
      });

      return Right(TemperaturaActual.fromMap(data));
    } on ErrorSinConeccion {
      return Left(FallaSinConeccion());
    } on ErrorEnPeticion {
      return Left(FallaEnPeticion());
    } on ErrorNoAutorizado {
      return Left(FallaNoAutorizado());
    } on ErrorNoEncontrado {
      return Left(FallaNoEncontrado());
    } on ErrorCuotaExcedida {
      return Left(FallaCuotaExcedida());
    } on ErrorInternoServidor {
      return Left(FallaInternaServidor());
    } catch (e) {
      return Left(FallaDesconocido());
    }
  }
}
