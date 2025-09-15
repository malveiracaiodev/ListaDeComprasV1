import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class ListaPreparadaPage extends StatefulWidget {
  const ListaPreparadaPage({super.key});

  @override
  State<ListaPreparadaPage> createState() => _ListaPreparadaPageState();
}
InputDecoration campoEstilizado(String label, IconData icon) {
  return InputDecoration(
    labelText: label,
    hintText: 'Digite $label...',
    prefixIcon: Icon(icon),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    filled: true,
    fillColor: Colors.grey[100],
  );
}
class _ListaPreparadaPageState extends State<ListaPreparadaPage> {
  final TextEditingController produtoCtrl = TextEditingController();
  final TextEditingController quantidadeCtrl = TextEditingController();

  List<Map<String, dynamic>> listaPreparada = [];

  void adicionarItem() {
    final produto = produtoCtrl.text.trim();
    final quantidade = int.tryParse(quantidadeCtrl.text) ?? 1;

    if (produto.isEmpty) return;

    setState(() {
      listaPreparada.add({
        "produto": produto,
        "quantidade": quantidade,
      });
    });

    produtoCtrl.clear();
    quantidadeCtrl.clear();
    salvarLista();
  }

  void removerItem(int index) {
    setState(() {
      listaPreparada.removeAt(index);
    });
    salvarLista();
  }

  void salvarLista() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('lista_preparada', jsonEncode(listaPreparada));
  }

  void carregarLista() async {
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getString('lista_preparada');
    if (json != null) {
      setState(() {
        listaPreparada = List<Map<String, dynamic>>.from(jsonDecode(json));
      });
    }
  }

  @override
  void initState() {
    super.initState();
    carregarLista();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lista de Compras')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(child: TextField(controller: produtoCtrl, decoration: const InputDecoration(labelText: 'Produto'))),
                const SizedBox(width: 8),
                SizedBox(
                  width: 80,
                  child: TextField(
                    controller: quantidadeCtrl,
                    decoration: const InputDecoration(labelText: 'Qtd'),
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
  icon: const Icon(Icons.shopping_cart),
  label: const Text('Ir para Modo Comprando'),
  onPressed: () {
    Navigator.pushNamed(
      context,
      '/comprando',
      arguments: listaPreparada,
    );
  },
),
            ElevatedButton(onPressed: adicionarItem, child: const Text('Adicionar')),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: listaPreparada.length,
                itemBuilder: (context, index) {
                  final item = listaPreparada[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    child: ListTile(
                      leading: const Icon(Icons.checklist, color: Colors.orange),
                      title: Text("${item['produto']} (${item['quantidade']}x)"),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => removerItem(index),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
