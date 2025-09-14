import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:intl/intl.dart';

class HistoricoPage extends StatefulWidget {
  const HistoricoPage({super.key});

  @override
  State<HistoricoPage> createState() => _HistoricoPageState();
}
class _HistoricoPageState extends State<HistoricoPage> {
  List<Map<String, dynamic>> historico = [];

  @override
  void initState() {
    super.initState();
    carregarHistorico();
  }

  void carregarHistorico() async {
  final prefs = await SharedPreferences.getInstance();
  final listasJson = prefs.getStringList('listas_salvas') ?? [];

  final listasDecodificadas = listasJson.map((json) => jsonDecode(json)).toList();

  setState(() {
    historico = List<Map<String, dynamic>>.from(listasDecodificadas);
  });
  }
void excluirLista(int index) async {
  final prefs = await SharedPreferences.getInstance();
  final listasJson = prefs.getStringList('listas_salvas') ?? [];

  listasJson.removeAt(index);
  await prefs.setStringList('listas_salvas', listasJson);

  setState(() {
    historico.removeAt(index);
  });
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Histórico de Listas')),
      body: historico.isEmpty
          ? const Center(child: Text('Nenhuma lista salva'))
          : ListView.builder(
              itemCount: historico.length,
              itemBuilder: (context, index) {
            final lista = historico[index];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      lista['mercado'] ?? 'Supermercado',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text("Total: R\$ ${lista['total'].toStringAsFixed(2)}"),
                    if (lista['data'] != null)
                      Text("Data: ${DateFormat('dd/MM/yyyy – HH:mm').format(DateTime.parse(lista['data']))}"),

                    const SizedBox(height: 8),
                    const Text("Itens:", style: TextStyle(fontWeight: FontWeight.bold)),
                    ...List<Widget>.from((lista['itens'] as List).map((item) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        child: Text(
                          "- ${item['produto']} (${item['quantidade']}x) ${item['marca']} - R\$ ${(item['valor'] * item['quantidade']).toStringAsFixed(2)}",
                        ),
                      );
                    })),
                    Align(
                      alignment: Alignment.centerRight,
                      child: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => excluirLista(index),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );
  }
}
