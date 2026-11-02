import 'package:flutter/material.dart';

void main() {
  runApp(const Filmapp());
}

class Filmapp extends StatelessWidget {
  const Filmapp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Filmapp',
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Imagen de fondo
          Image.network(
            'https://images.unsplash.com/photo-1489599849927-2ee91cede3ba?auto=format&fit=crop&w=1600&q=80',
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(color: const Color(0xFF202C43));
            },
          ),

          // Capa oscura para mejorar la lectura del texto
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.85),
                  Colors.black.withValues(alpha: 0.30),
                ],
              ),
            ),
          ),

          // Contenido principal de la pantalla
          SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Logo de la aplicación
                    Image.asset(
                      'filmapp-logo.ico',
                      width: 85,
                      height: 85,
                      fit: BoxFit.contain,
                    ),

                    const SizedBox(height: 20),

                    // Nombre de la aplicación
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

                    const SizedBox(height: 20),

                    // Texto solicitado en la actividad
                    const Text(
                      'Hello World',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Mensaje de bienvenida
                    const Text(
                      '¡Bienvenido a Filmapp!',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 22, color: Colors.white),
                    ),

                    const SizedBox(height: 10),

                    const Text(
                      'Disfruta de tus películas favoritas.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Colors.white70),
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
