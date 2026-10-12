class Pelicula {
  final int id;
  final String titulo;
  final String descripcion;
  final String sinopsis;
  final String genero;
  final int anio;
  final int duracion; // minutos
  final double calificacion;
  final String director;
  final String imagen;

  const Pelicula({
    required this.id,
    required this.titulo,
    required this.descripcion,
    required this.sinopsis,
    required this.genero,
    required this.anio,
    required this.duracion,
    required this.calificacion,
    required this.director,
    required this.imagen,
  });
}
