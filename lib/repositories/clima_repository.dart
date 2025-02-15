import 'package:app_del_clima/core/configs/configs.dart';
import 'package:app_del_clima/data_sources/network_data_source.dart';
import 'package:app_del_clima/models/temperatura_actual.dart';

class ClimaRepository {
  late NetworkDataSource _networkDataSource;
  final _path = '/weather';
  ClimaRepository() {
    _networkDataSource = NetworkDataSource();
  }

  Future<TemperaturaActual> obtenerClimaPorCiudad(String ciudad) async {
    final data = await _networkDataSource.peticionesGet(path: _path, params: {
      'q': ciudad,
      'appid': Configs.weatherApiKey,
      'units': 'metric',
      'lang': 'es',
    });

    return TemperaturaActual.fromMap(data);
  }
}
