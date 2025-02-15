class TemperaturaActual {
  final double temperatura;
  final String descripcion;
  final String descripcionPrincipal;

  TemperaturaActual({
    required this.temperatura,
    required this.descripcion,
    required this.descripcionPrincipal,
  });

  factory TemperaturaActual.fromMap(Map<String, dynamic> map) {
    return TemperaturaActual(
      temperatura: map['main']['temp'],
      descripcion: map['weather'][0]['description'],
      descripcionPrincipal: map['weather'][0]['main'],
    );
  }
}
