import 'package:flutter/material.dart';

void main() {
  runApp(const Filmapp());
}

// MODELO DE PELICULA
class Movie {
  final String id;
  final String title;
  final String year;
  final String director;
  final String genre;
  final String synopsis;
  final String imageUrl;

  Movie({
    required this.id,
    required this.title,
    required this.year,
    required this.director,
    required this.genre,
    required this.synopsis,
    required this.imageUrl,
  });
}

// DATOS DE DEMOSTRACION
final List<Movie> movies = [
  Movie(
    id: '1',
    title: 'Inception',
    year: '2010',
    director: 'Christopher Nolan',
    genre: 'Ciencia ficción',
    synopsis:
        'Un ladron especializado en extraer secretos '
        'del subconsciente debe implantar una idea '
        'en la mente de su objetivo.',
    imageUrl: 'https://image.tmdb.org/t/p/w500/9gk7adHYeDvHkCSEqAvQNLV5Uge.jpg',
  ),
  Movie(
    id: '2',
    title: 'Interstellar',
    year: '2014',
    director: 'Christopher Nolan',
    genre: 'Ciencia ficción',
    synopsis:
        'Un grupo de exploradores viaja a traves '
        'del espacio en busca de un futuro para '
        'la humanidad.',
    imageUrl: 'https://image.tmdb.org/t/p/w500/gEU2QniE6E77NI6lCU6MxlNBvIx.jpg',
  ),
  Movie(
    id: '3',
    title: 'The Dark Knight',
    year: '2008',
    director: 'Christopher Nolan',
    genre: 'Accion',
    synopsis:
        'Batman se enfrenta al Joker, un criminal '
        'que amenaza el equilibrio de Gotham.',
    imageUrl: 'https://image.tmdb.org/t/p/w500/qJ2tW6WMUDux911r6m7haRef0WH.jpg',
  ),
  Movie(
    id: '4',
    title: 'Avengers',
    year: '2012',
    director: 'Joss Whedon',
    genre: 'Accion',
    synopsis:
        'Un equipo de heroes se une para proteger '
        'la Tierra de una amenaza extraordinaria.',
    imageUrl: 'https://image.tmdb.org/t/p/w500/RYMX2wcKCBAr24UyPD7xwmjaTn.jpg',
  ),
];

class Filmapp extends StatelessWidget {
  const Filmapp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Filmapp',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.amber),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF202C43),
          foregroundColor: Colors.white,
        ),
      ),
      home: const HomeScreen(),
    );
  }
}

// 1. HOME SCREEN
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(
            'https://images.unsplash.com/photo-1489599849927-2ee91cede3ba'
            '?auto=format&fit=crop&w=1200&q=80',
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) =>
                Container(color: const Color(0xFF202C43)),
          ),
          Container(color: Colors.black.withOpacity(0.65)),
          SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Icono de la app
                    Image.asset(
                      'filmapp-logo.ico',
                      width: 85,
                      height: 85,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(height: 16),
                    const Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(text: 'Film'),
                          TextSpan(
                            text: 'app',
                            style: TextStyle(color: Colors.amber),
                          ),
                        ],
                      ),
                      style: TextStyle(
                        fontSize: 42,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Bienvenidos, Cinéfilos',
                      style: TextStyle(fontSize: 21, color: Colors.white),
                    ),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const CatalogScreen(),
                          ),
                        ),
                        icon: const Icon(Icons.movie),
                        label: const Text('Catálogo'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// 2. CATALOGO
class CatalogScreen extends StatefulWidget {
  const CatalogScreen({super.key});

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Filmapp | Catálogo')),
      body: movies.isEmpty
          ? const Center(child: Text('No hay películas disponibles.'))
          : GridView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: movies.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.62,
              ),
              itemBuilder: (context, index) {
                final movie = movies[index];

                return Card(
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => MovieDetailScreen(movie: movie),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: SizedBox(
                            width: double.infinity,
                            child: Image.network(
                              movie.imageUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) =>
                                  const Icon(Icons.movie, size: 60),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                movie.title,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(movie.year),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        onTap: (index) {
          if (index == 0) {
            Navigator.popUntil(context, (route) => route.isFirst);
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
          BottomNavigationBarItem(icon: Icon(Icons.movie), label: 'Catálogo'),
        ],
      ),
    );
  }
}

// 3. DESCRIPCION DE PELICULA
class MovieDetailScreen extends StatelessWidget {
  final Movie movie;

  const MovieDetailScreen({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detalle de película')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              movie.imageUrl,
              height: 320,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => const SizedBox(
                height: 220,
                child: Icon(Icons.movie, size: 90),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            movie.title,
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Text('Año de estreno: ${movie.year}'),
          const SizedBox(height: 8),
          Text('Director: ${movie.director}'),
          const SizedBox(height: 8),
          Text('Género: ${movie.genre}'),
          const SizedBox(height: 20),
          const Text(
            'Sinopsis',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(movie.synopsis, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}
