import 'package:flutter/material.dart';

import '../models/pelicula.dart';

class PeliculaCard extends StatelessWidget {
  final Pelicula pelicula;
  final bool esFavorita;
  final VoidCallback onTap;

  const PeliculaCard({
    super.key,
    required this.pelicula,
    required this.onTap,
    this.esFavorita = false,
  });

  @override
  Widget build(BuildContext context) {
    final colores = Theme.of(context).colorScheme;

    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Hero(
                tag: 'poster_${pelicula.id}',
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    pelicula.imagen,
                    width: 95,
                    height: 140,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            pelicula.titulo,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        if (esFavorita)
                          const Icon(Icons.favorite,
                              color: Colors.redAccent, size: 20),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${pelicula.genero} • ${pelicula.anio}',
                      style: TextStyle(color: colores.primary, fontSize: 13),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      pelicula.descripcion,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.white70),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 18),
                        const SizedBox(width: 4),
                        Text(
                          pelicula.calificacion.toString(),
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
