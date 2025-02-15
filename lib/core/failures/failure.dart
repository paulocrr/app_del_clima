sealed class Failure {
  final String mensaje;

  Failure({required this.mensaje});
}

class FallaDesconocido extends Failure {
  FallaDesconocido() : super(mensaje: 'Error desconocido');
}

class FallaEnPeticion extends Failure {
  FallaEnPeticion() : super(mensaje: 'Error en la petición');
}

class FallaInternaServidor extends Failure {
  FallaInternaServidor() : super(mensaje: 'Error en el servidor');
}

class FallaNoAutorizado extends Failure {
  FallaNoAutorizado() : super(mensaje: 'Error en la api key');
}

class FallaNoEncontrado extends Failure {
  FallaNoEncontrado() : super(mensaje: 'Ciudad no encontrada');
}

class FallaSinConeccion extends Failure {
  FallaSinConeccion() : super(mensaje: 'Sin coneccion a internet');
}

class FallaCuotaExcedida extends Failure {
  FallaCuotaExcedida()
      : super(mensaje: 'Se ha llegado al limite de peticiones');
}
