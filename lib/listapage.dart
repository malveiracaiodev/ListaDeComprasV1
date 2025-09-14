import 'package:flutter/material.dart'; // Flutter framework
import 'dart:convert'; // For JSON encoding/decoding
import 'package:shared_preferences/shared_preferences.dart'; // Shared preferences for local storage  

class ListaPage extends StatefulWidget { // ListaPage class definition
  const ListaPage({super.key}); // Constructor

  @override // Overriding createState method
  State<ListaPage> createState() => _ListaPageState(); // Creating state for ListaPage
}

class _ListaPageState extends State<ListaPage> { // State class for ListaPage
  final TextEditingController mercadoCtrl = TextEditingController(); // Controller for supermarket input
  final TextEditingController produtoCtrl = TextEditingController(); // Controller for product input
  final TextEditingController marcaCtrl = TextEditingController(); // Controller for brand input
  final TextEditingController quantidadeCtrl = TextEditingController(); // Controller for quantity input
  final TextEditingController valorCtrl = TextEditingController(); // Controller for value input

void salvarListaAtual() async {
  final prefs = await SharedPreferences.getInstance();
  final listaJson = jsonEncode({
    "mercado": mercadoCtrl.text,
    "itens": itens,
    "total": total,
    "data": DateTime.now().toIso8601String(), 
  });
  await prefs.setString('ultima_lista', listaJson);
}
@override
void dispose() {
  salvarListaAtual();
  super.dispose();
}
  List<Map<String, dynamic>> itens = []; // List to hold items
  double total = 0; // Variable to hold total value

  void adicionarItem() { // Method to add item
    final produto = produtoCtrl.text; // Getting product name
    final marca = marcaCtrl.text; // Getting brand name
    final valor = double.tryParse(valorCtrl.text) ?? 0; // Getting value and parsing to double
    final quantidade = int.tryParse(quantidadeCtrl.text) ?? 1; // Getting quantity and parsing to int

    if (produto.isEmpty || marca.isEmpty || valor <= 0) return; // Validating inputs

   setState(() {
  itens.add({
    "produto": produto,
    "marca": marca,
    "valor": valor,
    "quantidade": quantidade,
  });
  total += valor * quantidade;
});

    produtoCtrl.clear(); // Clearing product input
    marcaCtrl.clear(); // Clearing brand input
    valorCtrl.clear(); // Clearing value input
    quantidadeCtrl.clear(); // Clearing quantity input
  }

  @override // Overriding the build method
  Widget build(BuildContext context) { // Build method
    return Scaffold( // Scaffold widget
      appBar: AppBar(title: const Text('Nova Lista')), // AppBar with title
      body: Padding( // Padding widget
        padding: const EdgeInsets.all(16), // Padding of 16 on all sides
        child: Column( // Column widget
          children: [ // Children of the column
            TextField(controller: mercadoCtrl, decoration: const InputDecoration(labelText: 'Supermercado')), // TextField for supermarket input
            const SizedBox(height: 10),
Row(
  children: [
    Expanded(child: TextField(controller: produtoCtrl, decoration: const InputDecoration(labelText: 'Produto'))),
    const SizedBox(width: 8),
    Expanded(child: TextField(controller: marcaCtrl, decoration: const InputDecoration(labelText: 'Marca'))),
    const SizedBox(width: 8),
    Expanded(child: TextField(controller: valorCtrl, decoration: const InputDecoration(labelText: 'Valor'), keyboardType: TextInputType.number)),
    const SizedBox(width: 8),
    Expanded(child: TextField(controller: quantidadeCtrl, decoration: const InputDecoration(labelText: 'Qtd'), keyboardType: TextInputType.number)),
  ],
),
const SizedBox(height: 20),
ElevatedButton(
  onPressed: () {
    Navigator.pushNamed(context, '/historico');
  },
  child: const Text('Ver Histórico'),
),
            const SizedBox(height: 10),
            ElevatedButton(onPressed: adicionarItem, child: const Text('Adicionar')), // Button to add item
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder( // ListView to display items
                itemCount: itens.length, // Number of items
                itemBuilder: (context, index) { // Item builder
                  final item = itens[index]; // Getting the item at the current index
                  return ListTile( // ListTile widget
                    title: Text("${item['produto']} (${item['quantidade']}x) - ${item['marca']}"),
                    trailing: Text("R\$ ${(item['valor'] * item['quantidade']).toStringAsFixed(2)}"),
                  );
                },
              ),
            ),
            Text("Total: R\$ ${total.toStringAsFixed(2)}", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
