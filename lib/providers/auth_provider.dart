import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _service = AuthService();

  late final Stream<User?> usuario = _service.ouvirUsuario();

  bool _carregando = false;
  bool get carregando => _carregando;

  String? _erro;
  String? get erro => _erro;

  String mensagemDeErro(FirebaseAuthException e) {
    switch (e.code) {
      case 'email-already-in-use':
        return 'Este e-mail já está cadastrado.';
      case 'weak-password':
        return 'A senha precisa ter pelo menos 6 caracteres.';
      case 'invalid-email':
        return 'E-mail inválido.';
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-credential':
        return 'E-mail ou senha incorretos.';
      default:
        return 'Não foi possível concluir. Tente novamente.';
    }
  }

  Future<void> cadastrar(String nome, String email, String senha) async {
    _carregando = true;
    _erro = null;
    notifyListeners();
    try {
      await _service.cadastrar(nome, email, senha);
    } on FirebaseAuthException catch (e) {
      _erro = mensagemDeErro(e);
    }
    _carregando = false;
    notifyListeners();
  }

  Future<void> entrar(String email, String senha) async {
    _carregando = true;
    _erro = null;
    notifyListeners();
    try {
      await _service.entrar(email, senha);
    } on FirebaseAuthException catch (e) {
      _erro = mensagemDeErro(e);
    }
    _carregando = false;
    notifyListeners();
  }

  Future<void> sair() async {
    await _service.sair();
  }
}
