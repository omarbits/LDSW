import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Widgets básicos de Flutter',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Widgets básicos'),
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 1. WIDGET TEXT
                const Text(
                  'Mis primeros widgets',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),

                const SizedBox(height: 10),

                const Text(
                  'Ejemplo de Text: este widget muestra '
                  'información escrita en la pantalla.',
                  style: TextStyle(fontSize: 16),
                ),

                const SizedBox(height: 20),

                // 2. WIDGET CONTAINER
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 238, 229, 95),
                    border: Border.all(color: Colors.blue),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Container',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Este widget permite agrupar contenido '
                        'y configurar el fondo, los márgenes, '
                        'el espacio interior y los bordes.',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // 3. WIDGET ROW
                const Text(
                  'Row: elementos en horizontal',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 12),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(Icons.text_fields, size: 35, color: Colors.blue),
                        SizedBox(height: 6),
                        Text('Text'),
                      ],
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(Icons.view_column, size: 35, color: Colors.green),
                        SizedBox(height: 6),
                        Text('Column'),
                      ],
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(Icons.layers, size: 35, color: Colors.orange),
                        SizedBox(height: 6),
                        Text('Stack'),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // 4. WIDGET STACK
                const Text(
                  'Stack: elementos superpuestos',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 12),

                SizedBox(
                  height: 130,
                  child: Stack(
                    children: [
                      // Fondo
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 74, 195, 189),
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),

                      // Texto sobre el fondo
                      const Center(
                        child: Text(
                          'Contenido principal',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      // Icono superpuesto
                      Positioned(
                        top: 10,
                        right: 10,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            color: Color.fromARGB(255, 239, 76, 65),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.star, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // 5. WIDGET COLUMN
                const Text(
                  'Column: elementos en vertical',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 8),

                const Text(
                  'La pantalla utiliza Column para organizar '
                  'los títulos, textos, contenedores e iconos '
                  'uno debajo de otro.',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
