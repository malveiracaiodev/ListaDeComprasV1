import 'package:flutter/material.dart'; // Flutter framework
import 'lista_page.dart'; // Importing the ListaPage
import 'historico_page.dart'; // Importing the HistoricoPage

class HomePage extends StatelessWidget { // HomePage class definition
  const HomePage({super.key}); // Constructor

  @override // Overriding the build method
  Widget build(BuildContext context) { // Build method
    return Scaffold( // Scaffold widget
      appBar: AppBar(title: const Text('Menu Principal')), // AppBar with title
      body: Padding( // Padding widget
        padding: const EdgeInsets.all(24), // Padding of 24 on all sides
        child: Column( // Column widget
          mainAxisAlignment: MainAxisAlignment.center, // Centering the children vertically
          children: [ // Children of the column
            ElevatedButton.icon( // ElevatedButton with icon
              icon: const Icon(Icons.add), // Icon for the button
              label: const Text('Criar Nova Lista'), // Label for the button
              onPressed: () { // onPressed callback
                Navigator.push( // Navigating to ListaPage
                  context, // Current context
                  MaterialPageRoute(builder: (_) => const ListaPage()), // Route to ListaPage
                ); // End of Navigator.push
              }, // End of onPressed
            ), // End of ElevatedButton.icon
            const SizedBox(height: 20), // SizedBox for spacing
            ElevatedButton.icon( // Another ElevatedButton with icon
              icon: const Icon(Icons.history), // Icon for the button
              label: const Text('Listas Anteriores'), // Label for the button
              onPressed: () { // onPressed callback
                Navigator.push( // Navigating to HistoricoPage
                  context, // Current context
                  MaterialPageRoute(builder: (_) => const HistoricoPage()), // Route to HistoricoPage
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
