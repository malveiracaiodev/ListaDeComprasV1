import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Menu Principal')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Centraliza verticalmente
          crossAxisAlignment: CrossAxisAlignment.center, // Centraliza horizontalmente
          children: [
            Center(
              child: ElevatedButton.icon(
                icon: const Icon(Icons.add),
                label: const Text('Lista em compra'),
                onPressed: () {
                  Navigator.pushNamed(context, '/comprando');
                },
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton.icon(
                icon: const Icon(Icons.edit_note),
                label: const Text('Preparar Lista'),
                onPressed: () {
                  Navigator.pushNamed(context, '/preparar');
                },
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton.icon(
                icon: const Icon(Icons.history),
                label: const Text('Listas Anteriores'),
                onPressed: () {
                  Navigator.pushNamed(context, '/historico');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
