import 'package:app_del_clima/core/failures/failure.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class ErrorWidgetPerzonalizado extends StatelessWidget {
  final Failure falla;
  const ErrorWidgetPerzonalizado({super.key, required this.falla});

  @override
  Widget build(BuildContext context) {
    late final Widget animacionDeError;
    switch (falla) {
      case FallaNoAutorizado():
        animacionDeError =
            LottieBuilder.asset('assets/unauthorized_error.json');
      case FallaNoEncontrado():
        animacionDeError = LottieBuilder.asset('assets/404_error.json');
      case FallaSinConeccion():
        animacionDeError =
            LottieBuilder.asset('assets/no_connection_error.json');
      default:
        animacionDeError = LottieBuilder.asset(
          'assets/generic_error.json',
        );
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        animacionDeError,
        Text(falla.mensaje),
      ],
    );
  }
}
