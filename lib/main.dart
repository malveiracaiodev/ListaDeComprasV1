import 'package:flutter/material.dart'; // Flutter framework
import '../homepage.dart'; // Importing the HomePage
import './historicopage.dart'; // Correct import for HistoricoPage
import 'listapreparadapage.dart';
import "./listapage.dart";

void main() { // Main function
  runApp(const ListaComprasApp()); // Running the app
}

class ListaComprasApp extends StatelessWidget { // Main app class
  const ListaComprasApp({super.key}); // Constructor

  @override // Overriding the build method
  Widget build(BuildContext context) { // Build method
   return MaterialApp(
  title: 'Lista de Compras',
  theme: ThemeData(
  colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
  useMaterial3: true,
  textTheme: const TextTheme(
    titleLarge: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
    bodyMedium: TextStyle(fontSize: 16),
  ),
),
  home: const HomePage(),
  routes: {
    '/preparar': (context) => const ListaPreparadaPage(),
    '/comprando': (context) => const ListaPage(),
    '/historico': (context) => const HistoricoPage(),
  },
);  }
}

