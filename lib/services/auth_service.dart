import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<User?> ouvirUsuario() {
    return _auth.authStateChanges();
  }

  Future<void> cadastrar(String nome, String email, String senha) async {
    final credencial = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: senha,
    );
    await credencial.user!.updateDisplayName(nome);
    await credencial.user!.reload();
  }

  Future<void> entrar(String email, String senha) async {
    await _auth.signInWithEmailAndPassword(email: email, password: senha);
  }

  Future<void> sair() async {
    await _auth.signOut();
  }
}
