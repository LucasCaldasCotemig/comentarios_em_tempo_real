import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/comentario.dart';
import '../models/publicacao.dart';
import '../providers/comentario_provider.dart';

class ComentariosPage extends StatefulWidget {
  final Publicacao publicacao;

  const ComentariosPage({super.key, required this.publicacao});

  @override
  State<ComentariosPage> createState() => _ComentariosPageState();
}

class _ComentariosPageState extends State<ComentariosPage> {
  final _comentarioController = TextEditingController();

  late final Stream<List<Comentario>> _comentarios = context
      .read<ComentarioProvider>()
      .ouvirComentarios(widget.publicacao.id!);

  @override
  void dispose() {
    _comentarioController.dispose();
    super.dispose();
  }

  void _comentar() async {
    final texto = _comentarioController.text.trim();
    if (texto.isEmpty) return;
    await context
        .read<ComentarioProvider>()
        .comentar(widget.publicacao.id!, texto);
    _comentarioController.clear();
  }

  void _excluir(Comentario comentario) async {
    await context.read<ComentarioProvider>().excluirComentario(comentario.id!);
  }

  @override
  Widget build(BuildContext context) {
    final uidAtual = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(title: const Text('Comentários')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: Card(
                color: Colors.deepPurple.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.publicacao.texto,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 4),
                      Text('Por ${widget.publicacao.autorNome}'),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: StreamBuilder<List<Comentario>>(
                stream: _comentarios,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Center(
                      child: Text('Erro ao carregar os comentários.'),
                    );
                  }
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final comentarios = snapshot.data!;
                  if (comentarios.isEmpty) {
                    return const Center(
                      child: Text('Nenhum comentário ainda.'),
                    );
                  }
                  return ListView.builder(
                    itemCount: comentarios.length,
                    itemBuilder: (context, index) {
                      final comentario = comentarios[index];
                      return Card(
                        child: ListTile(
                          title: Text(comentario.nome),
                          subtitle: Text(comentario.texto),
                          trailing: comentario.usuarioId == uidAtual
                              ? IconButton(
                                  icon: const Icon(Icons.delete,
                                      color: Colors.red),
                                  onPressed: () => _excluir(comentario),
                                )
                              : null,
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _comentarioController,
                    decoration:
                        const InputDecoration(labelText: 'Escreva um comentário'),
                    onSubmitted: (_) => _comentar(),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.deepPurple),
                  onPressed: _comentar,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
