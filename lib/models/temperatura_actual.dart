class TemperaturaActual {
  final double temperatura;
  final String descripcion;
  final String descripcionPrincipal;
  final String ciudad;

  TemperaturaActual({
    required this.temperatura,
    required this.descripcion,
    required this.descripcionPrincipal,
    required this.ciudad,
  });

  factory TemperaturaActual.fromMap(Map<String, dynamic> map) {
    return TemperaturaActual(
      temperatura: map['main']['temp'] as double,
      descripcion: map['weather'][0]['description'],
      descripcionPrincipal: map['weather'][0]['main'],
      ciudad: map['name'],
    );
  }
}
