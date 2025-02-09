import 'dart:convert';

import 'package:app_del_clima/core/configs/configs.dart';
import 'package:app_del_clima/core/networking/network_utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final lista = [];
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: ElevatedButton(
            onPressed: () async {
              final networkUtility = NetworkUtility();
              final resultados = await Future.wait([
                networkUtility.peticionesGet(
                  path: '/weather',
                  params: {
                    'q': 'London',
                    'appid': Configs.weatherApiKey,
                    'units': 'metric',
                  },
                ),
              ]);

              print(resultados[0]['coord']);
            },
            child: Text('test'),
          ),
        ),
      ),
    );
  }
}
