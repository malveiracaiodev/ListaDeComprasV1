import 'package:flutter/material.dart'; // Flutter framework
import 'homepage.dart'; // Importing the HomePage
import 'historicopage.dart'; // Correct import for HistoricoPage

void main() { // Main function
  runApp(const ListaComprasApp()); // Running the app
}

class ListaComprasApp extends StatelessWidget { // Main app class
  const ListaComprasApp({super.key}); // Constructor

  @override // Overriding the build method
  Widget build(BuildContext context) { // Build method
    return MaterialApp( // MaterialApp widget
      title: 'Lista de Compras', // App title
      theme: ThemeData(primarySwatch: Colors.green), // Theme with green primary color
      home: const HomePage(), // Setting HomePage as the home screen
      routes: {
        '/historico': (context) => const HistoricoPage(),
      },
    );
  }
}

