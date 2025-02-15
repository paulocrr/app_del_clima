import 'dart:async';

import 'package:app_del_clima/core/failures/failure.dart';
import 'package:app_del_clima/models/temperatura_actual.dart';
import 'package:app_del_clima/repositories/clima_repository.dart';
import 'package:app_del_clima/ui/error_widget.dart';
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
  Failure? _falla;
  TemperaturaActual? _temperaturaActual;
  final _formKey = GlobalKey<FormState>();
  Timer? _timer;
  DateTime? _ultimaActualizacion;

  @override
  void initState() {
    _obtenerTemperatura('Lima');
    _consultarTiempoPeriocamente('Lima');
    super.initState();
  }

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
              key: _formKey,
              child: Column(
                spacing: 8,
                children: [
                  TextFormField(
                    controller: _ciudadTextController,
                    decoration: InputDecoration(
                      labelText: 'Nombre de ciudad',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty || value == '') {
                        return 'Este valor es requerido';
                      }

                      return null;
                    },
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      FocusManager.instance.primaryFocus?.unfocus();
                      final esValido = _formKey.currentState?.validate();
                      if (esValido == true) {
                        _obtenerTemperatura(_ciudadTextController.text);
                        _consultarTiempoPeriocamente(
                            _ciudadTextController.text);
                      }
                    },
                    label: Text('Buscar'),
                    icon: Icon(Icons.search),
                  )
                ],
              ),
            ),
            if (_estaCargando == false) ...[
              if (_falla != null) ...[
                Expanded(
                  child: SingleChildScrollView(
                    child: ErrorWidgetPerzonalizado(
                      falla: _falla!,
                    ),
                  ),
                )
              ] else if (_temperaturaActual != null)
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Ultima actualizacion: $_ultimaActualizacion'),
                        Text('Ciudad: ${_temperaturaActual!.ciudad}'),
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

  void _obtenerTemperatura(String ciudad) async {
    setState(() {
      _estaCargando = true;
      _temperaturaActual = null;
      _falla = null;
    });
    final resultadoTemperatura =
        await _climaRepository.obtenerClimaPorCiudad(ciudad);
    setState(() {
      _estaCargando = false;
      resultadoTemperatura.fold((falla) {
        _timer?.cancel();
        _falla = falla;
      }, (temperaturaActual) {
        _ultimaActualizacion = DateTime.now();
        _temperaturaActual = temperaturaActual;
      });
    });
  }

  void _consultarTiempoPeriocamente(String ciudad) {
    _timer?.cancel();
    _timer = Timer.periodic(Duration(minutes: 30), (_) {
      _obtenerTemperatura(ciudad);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
