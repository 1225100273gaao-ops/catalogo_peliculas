import 'package:flutter/material.dart';

import '../models/pelicula.dart';

class DetalleScreen extends StatefulWidget {
  final Pelicula pelicula;
  final bool esFavorita;

  const DetalleScreen({
    super.key,
    required this.pelicula,
    this.esFavorita = false,
  });

  @override
  State<DetalleScreen> createState() => _DetalleScreenState();
}

class _DetalleScreenState extends State<DetalleScreen> {
  late bool _favorita;

  @override
  void initState() {
    super.initState();
    _favorita = widget.esFavorita;
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.pelicula;
    final colores = Theme.of(context).colorScheme;

    // Al volver (botón atrás o gesto) se devuelve el estado de favorito
    // a la pantalla anterior con Navigator.pop(context, resultado).
    return PopScope<Object?>(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        Navigator.pop(context, _favorita);
      },
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 420,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  p.titulo,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    shadows: [Shadow(blurRadius: 8, color: Colors.black)],
                  ),
                ),
                background: Hero(
                  tag: 'poster_${p.id}',
                  child: Image.asset(p.imagen, fit: BoxFit.cover),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Iconos informativos
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _Dato(
                          icono: Icons.star,
                          color: Colors.amber,
                          texto: '${p.calificacion}',
                          etiqueta: 'Calificación',
                        ),
                        _Dato(
                          icono: Icons.access_time,
                          color: colores.primary,
                          texto: '${p.duracion} min',
                          etiqueta: 'Duración',
                        ),
                        _Dato(
                          icono: Icons.calendar_today,
                          color: colores.primary,
                          texto: '${p.anio}',
                          etiqueta: 'Año',
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Chip(label: Text(p.genero)),
                    const SizedBox(height: 16),
                    const Text(
                      'Sinopsis',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      p.sinopsis,
                      style: const TextStyle(fontSize: 16, height: 1.5),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Director',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.movie_creation_outlined),
                        const SizedBox(width: 8),
                        Text(p.director, style: const TextStyle(fontSize: 16)),
                      ],
                    ),
                    const SizedBox(height: 28),
                    // Botones de acción
                    Row(
                      children: [
                        Expanded(
                          child: FilledButton.icon(
                            onPressed: () =>
                                setState(() => _favorita = !_favorita),
                            icon: Icon(
                              _favorita
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                            ),
                            label: Text(
                              _favorita ? 'En favoritos' : 'Favorito',
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Compartiendo "${p.titulo}"...'),
                                ),
                              );
                            },
                            icon: const Icon(Icons.share),
                            label: const Text('Compartir'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Dato extends StatelessWidget {
  final IconData icono;
  final Color color;
  final String texto;
  final String etiqueta;

  const _Dato({
    required this.icono,
    required this.color,
    required this.texto,
    required this.etiqueta,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icono, color: color, size: 28),
        const SizedBox(height: 6),
        Text(
          texto,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Text(etiqueta, style: const TextStyle(color: Colors.white60)),
      ],
    );
  }
}
