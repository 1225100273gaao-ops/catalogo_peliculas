import 'package:flutter/material.dart';

import '../data/peliculas_data.dart';
import '../models/pelicula.dart';
import '../widgets/pelicula_card.dart';
import 'detalle_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _categoria = 'Todas';
  String _texto = '';
  final Set<int> _favoritos = {};

  List<String> get _categorias =>
      ['Todas', ...{...peliculas.map((p) => p.genero)}];

  List<Pelicula> get _filtradas {
    return peliculas.where((p) {
      final coincideCategoria = _categoria == 'Todas' || p.genero == _categoria;
      final coincideTexto =
          p.titulo.toLowerCase().contains(_texto.toLowerCase());
      return coincideCategoria && coincideTexto;
    }).toList();
  }

  Future<void> _abrirDetalle(Pelicula pelicula) async {
    final resultado = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => DetalleScreen(
          pelicula: pelicula,
          esFavorita: _favoritos.contains(pelicula.id),
        ),
      ),
    );

    if (resultado == null || !mounted) return;

    setState(() {
      if (resultado) {
        _favoritos.add(pelicula.id);
      } else {
        _favoritos.remove(pelicula.id);
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          resultado
              ? '"${pelicula.titulo}" agregada a favoritos'
              : '"${pelicula.titulo}" quitada de favoritos',
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final lista = _filtradas;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'CineApp',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle, size: 30),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Perfil próximamente')),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          // Barra de búsqueda
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: TextField(
              onChanged: (valor) => setState(() => _texto = valor),
              decoration: InputDecoration(
                hintText: 'Buscar película...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          // Categorías
          SizedBox(
            height: 48,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _categorias.length,
              separatorBuilder: (context, index) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final categoria = _categorias[index];
                return ChoiceChip(
                  label: Text(categoria),
                  selected: _categoria == categoria,
                  onSelected: (_) => setState(() => _categoria = categoria),
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          // Lista dinámica
          Expanded(
            child: lista.isEmpty
                ? const Center(child: Text('No se encontraron películas'))
                : ListView.builder(
                    itemCount: lista.length,
                    itemBuilder: (context, index) {
                      final pelicula = lista[index];
                      return PeliculaCard(
                        pelicula: pelicula,
                        esFavorita: _favoritos.contains(pelicula.id),
                        onTap: () => _abrirDetalle(pelicula),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
