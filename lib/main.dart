import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
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

  factory Movie.fromSnapshot(
    QueryDocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    final data = snapshot.data();
    return Movie(
      id: snapshot.id,
      title: data['title'] as String? ?? '',
      year: data['year'] as String? ?? '',
      director: data['director'] as String? ?? '',
      genre: data['genre'] as String? ?? '',
      synopsis: data['synopsis'] as String? ?? '',
      imageUrl: data['imageUrl'] as String? ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'year': year,
      'director': director,
      'genre': genre,
      'synopsis': synopsis,
      'imageUrl': imageUrl,
    };
  }
}

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
                    Image.asset(
                      'filmapp-logo.png',
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
                      child: FilledButton(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const AuthScreen(register: true),
                          ),
                        ),
                        child: const Text('Registrarse'),
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: const BorderSide(color: Colors.white),
                        ),
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const AuthScreen(register: false),
                          ),
                        ),
                        child: const Text('Iniciar sesión'),
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

// 2. REGISTRO E INICIO DE SESION
class AuthScreen extends StatefulWidget {
  final bool register;

  const AuthScreen({super.key, required this.register});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    super.dispose();
  }

  Future<void> continueToCatalog() async {
    if (emailController.text.trim().isEmpty ||
        passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ingresa tu correo y contraseña.')),
      );
      return;
    }

    setState(() => isLoading = true);
    try {
      if (widget.register) {
        final credential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
              email: emailController.text.trim(),
              password: passwordController.text,
            );
        await credential.user?.updateDisplayName(nameController.text.trim());
      } else {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text,
        );
      }

      if (!mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const CatalogScreen()),
        (route) => route.isFirst,
      );
    } on FirebaseAuthException catch (error) {
      if (!mounted) return;
      final message = switch (error.code) {
        'configuration-not-found' =>
          'Firebase Authentication no está configurado. Habilita el proveedor '
              'Correo electrónico/contraseña en Firebase Console.',
        'invalid-credential' ||
        'invalid-login-credentials' ||
        'wrong-password' ||
        'user-not-found' => 'Correo o contraseña incorrectos.',
        'email-already-in-use' =>
          'Ya existe una cuenta con ese correo electrónico.',
        'weak-password' => 'La contraseña debe tener al menos 6 caracteres.',
        'invalid-email' => 'El correo electrónico no tiene un formato válido.',
        'too-many-requests' =>
          'Demasiados intentos. Espera unos minutos e inténtalo de nuevo.',
        _ => error.message ?? 'No se pudo autenticar la cuenta.',
      };
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.register ? 'Crear cuenta' : 'Iniciar sesión'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          if (widget.register)
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Nombre',
                prefixIcon: Icon(Icons.person_outline),
              ),
            ),
          const SizedBox(height: 12),
          TextField(
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              labelText: 'Correo electrónico',
              prefixIcon: Icon(Icons.email_outlined),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: passwordController,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: 'Contraseña',
              prefixIcon: Icon(Icons.lock_outline),
            ),
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: isLoading ? null : continueToCatalog,
            child: isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(widget.register ? 'Crear cuenta' : 'Entrar'),
          ),
        ],
      ),
    );
  }
}

// 3. CATALOGO
class CatalogScreen extends StatefulWidget {
  const CatalogScreen({super.key});

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  CollectionReference<Map<String, dynamic>> get moviesRef =>
      FirebaseFirestore.instance.collection('movies');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Filmapp | Catálogo'),
        actions: [
          IconButton(
            tooltip: 'Cerrar sesión',
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              if (!context.mounted) return;
              Navigator.popUntil(context, (route) => route.isFirst);
            },
          ),
          IconButton(
            tooltip: 'Administrar películas',
            icon: const Icon(Icons.settings),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AdminScreen()),
              );
              setState(() {});
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: moviesRef.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            final error = snapshot.error;
            final message =
                error is FirebaseException && error.code == 'permission-denied'
                ? 'No tienes permiso para ver el catálogo.'
                : 'No se pudo cargar el catálogo.';
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(message, textAlign: TextAlign.center),
              ),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final movies =
              snapshot.data?.docs.map(Movie.fromSnapshot).toList() ?? [];

          if (movies.isEmpty) {
            return const Center(child: Text('No hay películas disponibles.'));
          }

          return GridView.builder(
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
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        onTap: (index) {
          if (index == 0) {
            Navigator.popUntil(context, (route) => route.isFirst);
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AdminScreen()),
            ).then((_) => setState(() {}));
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
          BottomNavigationBarItem(icon: Icon(Icons.movie), label: 'Catálogo'),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Administración',
          ),
        ],
      ),
    );
  }
}

// 4. DESCRIPCION DE PELICULA
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

// 5. ADMINISTRACION: ALTA Y BAJA
class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  final titleController = TextEditingController();
  final yearController = TextEditingController();
  final directorController = TextEditingController();
  final genreController = TextEditingController();
  final synopsisController = TextEditingController();
  final imageController = TextEditingController();
  bool isSaving = false;

  @override
  void dispose() {
    titleController.dispose();
    yearController.dispose();
    directorController.dispose();
    genreController.dispose();
    synopsisController.dispose();
    imageController.dispose();
    super.dispose();
  }

  Future<void> addMovie() async {
    if (titleController.text.trim().isEmpty ||
        yearController.text.trim().isEmpty ||
        directorController.text.trim().isEmpty ||
        genreController.text.trim().isEmpty ||
        synopsisController.text.trim().isEmpty ||
        imageController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Completa todos los campos.')),
      );
      return;
    }

    setState(() => isSaving = true);
    try {
      await FirebaseFirestore.instance.collection('movies').add({
        'title': titleController.text.trim(),
        'year': yearController.text.trim(),
        'director': directorController.text.trim(),
        'genre': genreController.text.trim(),
        'synopsis': synopsisController.text.trim(),
        'imageUrl': imageController.text.trim(),
        'createdAt': FieldValue.serverTimestamp(),
      });

      titleController.clear();
      yearController.clear();
      directorController.clear();
      genreController.clear();
      synopsisController.clear();
      imageController.clear();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Película agregada al catálogo.')),
      );
    } on FirebaseException catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.message ?? 'No se pudo guardar.')),
      );
    } finally {
      if (mounted) setState(() => isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Administrar películas')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Dar de alta una película',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: titleController,
            decoration: const InputDecoration(labelText: 'Título'),
          ),
          TextField(
            controller: yearController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Año'),
          ),
          TextField(
            controller: directorController,
            decoration: const InputDecoration(labelText: 'Director'),
          ),
          TextField(
            controller: genreController,
            decoration: const InputDecoration(labelText: 'Género'),
          ),
          TextField(
            controller: synopsisController,
            maxLines: 3,
            decoration: const InputDecoration(labelText: 'Sinopsis'),
          ),
          TextField(
            controller: imageController,
            keyboardType: TextInputType.url,
            decoration: const InputDecoration(labelText: 'URL de la imagen'),
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: isSaving ? null : addMovie,
            icon: const Icon(Icons.add),
            label: const Text('Dar de alta película'),
          ),
          const Divider(height: 32),
          const Text(
            'Dar de baja una película',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: FirebaseFirestore.instance.collection('movies').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return const Text('No se pudo cargar la lista.');
              }

              final movies =
                  snapshot.data?.docs.map(Movie.fromSnapshot).toList() ?? [];
              if (movies.isEmpty) {
                return const Text('No hay películas para eliminar.');
              }

              return Column(
                children: movies
                    .map(
                      (movie) => ListTile(
                        leading: const Icon(Icons.movie),
                        title: Text(movie.title),
                        subtitle: Text(movie.year),
                        trailing: IconButton(
                          tooltip: 'Eliminar película',
                          icon: const Icon(
                            Icons.delete_outline,
                            color: Colors.red,
                          ),
                          onPressed: () async {
                            await FirebaseFirestore.instance
                                .collection('movies')
                                .doc(movie.id)
                                .delete();
                          },
                        ),
                      ),
                    )
                    .toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}
