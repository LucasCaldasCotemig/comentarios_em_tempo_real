import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../models/comentario.dart';
import '../services/comentario_service.dart';

class ComentarioProvider extends ChangeNotifier {
  final ComentarioService _service = ComentarioService();

  Stream<List<Comentario>> ouvirComentarios(String publicacaoId) {
    return _service.ouvirDaPublicacao(publicacaoId);
  }

  Future<void> comentar(String publicacaoId, String texto) async {
    final usuario = FirebaseAuth.instance.currentUser!;
    final comentario = Comentario(
      texto: texto,
      nome: usuario.displayName ?? usuario.email ?? '',
      usuarioId: usuario.uid,
      publicacaoId: publicacaoId,
      criadoEm: DateTime.now().millisecondsSinceEpoch,
    );
    await _service.adicionar(comentario);
  }

  Future<void> excluirComentario(String id) async {
    await _service.excluir(id);
  }
}
