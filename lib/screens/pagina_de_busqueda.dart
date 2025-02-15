import 'package:app_del_clima/models/temperatura_actual.dart';
import 'package:app_del_clima/repositories/clima_repository.dart';
import 'package:flutter/material.dart';

class PaginaDeBusqueda extends StatefulWidget {
  const PaginaDeBusqueda({super.key});

  @override
  State<PaginaDeBusqueda> createState() => _PaginaDeBusquedaState();
}

class _PaginaDeBusquedaState extends State<PaginaDeBusqueda> {
  final _ciudadTextController = TextEditingController();
  final _climaRepository = ClimaRepository();
  bool _estaCargando = false;
  TemperaturaActual? _temperaturaActual;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Busqueda de Clima')),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 8,
        ),
        child: Column(
          children: [
            Form(
              child: Column(
                spacing: 8,
                children: [
                  TextFormField(
                    controller: _ciudadTextController,
                    decoration: InputDecoration(
                      labelText: 'Nombre de ciudad',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      FocusManager.instance.primaryFocus?.unfocus();
                      _obtenerTemperatura();
                    },
                    label: Text('Buscar'),
                    icon: Icon(Icons.search),
                  )
                ],
              ),
            ),
            if (_estaCargando == false) ...[
              if (_temperaturaActual != null)
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${_temperaturaActual!.temperatura} Celsius',
                          style: TextStyle(fontSize: 32),
                        ),
                        Text(
                          'Estado del Clima: ${_temperaturaActual!.descripcion.toUpperCase()}',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ),
            ] else ...[
              Expanded(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            ],
          ],
        ),
      ),
    );
  }

  void _obtenerTemperatura() async {
    setState(() {
      _estaCargando = true;
      _temperaturaActual = null;
    });
    final resultadoTemperatura = await _climaRepository
        .obtenerClimaPorCiudad(_ciudadTextController.text);

    setState(() {
      _estaCargando = false;
      _temperaturaActual = resultadoTemperatura;
    });
  }
}
