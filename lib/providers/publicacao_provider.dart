import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../models/publicacao.dart';
import '../services/publicacao_service.dart';

class PublicacaoProvider extends ChangeNotifier {
  final PublicacaoService _service = PublicacaoService();

  Stream<List<Publicacao>> ouvirPublicacoes() {
    return _service.ouvirTodas();
  }

  Future<void> publicar(String texto) async {
    final usuario = FirebaseAuth.instance.currentUser!;
    final publicacao = Publicacao(
      texto: texto,
      autorNome: usuario.displayName ?? usuario.email ?? '',
      autorUid: usuario.uid,
      criadoEm: DateTime.now().millisecondsSinceEpoch,
    );
    await _service.adicionar(publicacao);
  }
}
