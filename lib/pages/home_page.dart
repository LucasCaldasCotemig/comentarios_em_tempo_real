import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/publicacao.dart';
import '../providers/publicacao_provider.dart';
import 'comentarios_page.dart';
import 'perfil_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _textoController = TextEditingController();

  late final Stream<List<Publicacao>> _publicacoes =
      context.read<PublicacaoProvider>().ouvirPublicacoes();

  @override
  void dispose() {
    _textoController.dispose();
    super.dispose();
  }

  void _publicar() async {
    final texto = _textoController.text.trim();
    if (texto.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Escreva algo para publicar.')),
      );
      return;
    }
    await context.read<PublicacaoProvider>().publicar(texto);
    _textoController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Publicações'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            tooltip: 'Perfil',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const PerfilPage()),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _textoController,
              decoration: const InputDecoration(labelText: 'No que você está pensando?'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _publicar,
              child: const Text('PUBLICAR'),
            ),
            const Divider(height: 32),
            Expanded(
              child: StreamBuilder<List<Publicacao>>(
                stream: _publicacoes,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Center(
                      child: Text('Erro ao carregar as publicações.'),
                    );
                  }
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final publicacoes = snapshot.data!;
                  if (publicacoes.isEmpty) {
                    return const Center(
                      child: Text('Nenhuma publicação ainda.'),
                    );
                  }
                  return ListView.builder(
                    itemCount: publicacoes.length,
                    itemBuilder: (context, index) {
                      final publicacao = publicacoes[index];
                      return Card(
                        child: ListTile(
                          title: Text(publicacao.texto),
                          subtitle: Text('Por ${publicacao.autorNome}'),
                          trailing: IconButton(
                            icon: const Icon(Icons.comment,
                                color: Colors.deepPurple),
                            tooltip: 'Comentários',
                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ComentariosPage(
                                  publicacao: publicacao,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
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
