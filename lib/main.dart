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
  theme: ThemeData(primarySwatch: Colors.green),
  home: const HomePage(),
  routes: {
    '/preparar': (context) => const ListaPreparadaPage(),
    '/comprando': (context) => const ListaPage(),
    '/historico': (context) => const HistoricoPage(),
  },
);  }
}

