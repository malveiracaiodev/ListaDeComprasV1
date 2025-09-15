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

  List<Map<String, dynamic>> itens = []; // List to hold items
  double total = 0; // Variable to hold total value
@override
void didChangeDependencies() {
  super.didChangeDependencies();

  final args = ModalRoute.of(context)?.settings.arguments;
  if (args != null && args is List<Map<String, dynamic>>) {
    for (var item in args) {
      itens.add({
        "produto": item['produto'],
        "marca": '',
        "valor": 0.0,
        "quantidade": item['quantidade'],
      });
    }
  }
}
  void adicionarItem() {
    final produto = produtoCtrl.text;
    final marca = marcaCtrl.text;
    final valorTexto = valorCtrl.text.replaceAll(',', '.');
    final valor = double.tryParse(valorTexto) ?? 0;
    final quantidade = int.tryParse(quantidadeCtrl.text) ?? 1;

    if (produto.isEmpty || marca.isEmpty || valor <= 0) return;

    setState(() {
      itens.add({
        "produto": produto,
        "marca": marca,
        "valor": valor,
        "quantidade": quantidade,
      });
      total += valor * quantidade;
    });
ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(content: Text('Item "${produto}" adicionado')),
);
    produtoCtrl.clear();
    marcaCtrl.clear();
    valorCtrl.clear();
    quantidadeCtrl.clear();
  }

  @override
  Widget build(BuildContext context) {
    // The build method implementation is already present further down in your code.
    // No need to duplicate, just ensure this method exists.
    return Scaffold(
      appBar: AppBar(title: const Text('Modo Comprando')), // AppBar with title
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: mercadoCtrl, decoration: const InputDecoration(labelText: 'Supermercado')),
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
            ElevatedButton(onPressed: adicionarItem, child: const Text('Adicionar')),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: itens.length,
                itemBuilder: (context, index) {
                  final item = itens[index];
                  return Card(
  margin: const EdgeInsets.symmetric(vertical: 6),
  child: ListTile(
    leading: const Icon(Icons.shopping_bag, color: Colors.green),
    title: Text("${item['produto']} (${item['quantidade']}x) - ${item['marca']}"),
    subtitle: Text("R\$ ${(item['valor'] * item['quantidade']).toStringAsFixed(2)}"),
    trailing: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: const Icon(Icons.edit, color: Colors.blue),
          onPressed: () => editarItem(index),
        ),
        IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: () => removerItem(index),
        ),
      ],
    ),
  ),
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

void editarItem(int index) {
  final item = itens[index];

  produtoCtrl.text = item['produto'];
  marcaCtrl.text = item['marca'];
  valorCtrl.text = item['valor'].toString();
  quantidadeCtrl.text = item['quantidade'].toString();

  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text('Editar Item'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(controller: produtoCtrl, decoration: const InputDecoration(labelText: 'Produto')),
          TextField(controller: marcaCtrl, decoration: const InputDecoration(labelText: 'Marca')),
          TextField(controller: valorCtrl, decoration: const InputDecoration(labelText: 'Valor'), keyboardType: TextInputType.number),
          TextField(controller: quantidadeCtrl, decoration: const InputDecoration(labelText: 'Quantidade'), keyboardType: TextInputType.number),
        ]
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: () {
            final novoProduto = produtoCtrl.text;
            final novaMarca = marcaCtrl.text;
            final novoValor = double.tryParse(valorCtrl.text.replaceAll(',', '.')) ?? 0;
            final novaQtd = int.tryParse(quantidadeCtrl.text) ?? 1;

            if (novoProduto.isEmpty || novaMarca.isEmpty || novoValor <= 0) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Preencha todos os campos corretamente')),
              );
              return;
            }

            setState(() {
              total -= item['valor'] * item['quantidade'];
              itens[index] = {
                "produto": novoProduto,
                "marca": novaMarca,
                "valor": novoValor,
                "quantidade": novaQtd,
              };
              total += novoValor * novaQtd;
            });

            salvarListaAtual();

            produtoCtrl.clear();
            marcaCtrl.clear();
            valorCtrl.clear();
            quantidadeCtrl.clear();
            Navigator.pop(context);
          },
          child: const Text('Salvar'),
        ),
      ],
    ),
  );
}
void removerItem(int index) {
  setState(() {
    total -= itens[index]['valor'] * itens[index]['quantidade'];
    itens.removeAt(index);
  });
  salvarListaAtual();
}
void salvarListaAtual() async {
  final prefs = await SharedPreferences.getInstance();

  final novaLista = {
    "mercado": mercadoCtrl.text,
    "itens": itens,
    "total": total,
    "data": DateTime.now().toIso8601String(),
  };

  final listasExistentes = prefs.getStringList('listas_salvas') ?? [];
  listasExistentes.add(jsonEncode(novaLista));

  await prefs.setStringList('listas_salvas', listasExistentes);
}

@override
void dispose() {
  salvarListaAtual();
  super.dispose();
}
}
