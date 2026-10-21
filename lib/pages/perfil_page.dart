import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class PerfilPage extends StatelessWidget {
  const PerfilPage({super.key});

  void _sair(BuildContext context) async {
    await context.read<AuthProvider>().sair();
    if (context.mounted) {
      Navigator.popUntil(context, (rota) => rota.isFirst);
    }
  }

  @override
  Widget build(BuildContext context) {
    final usuario = FirebaseAuth.instance.currentUser!;
    final nome = usuario.displayName ?? '';

    return Scaffold(
      appBar: AppBar(title: const Text('Perfil')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            CircleAvatar(
              radius: 40,
              child: Text(
                nome.isEmpty ? '?' : nome[0].toUpperCase(),
                style: const TextStyle(fontSize: 32),
              ),
            ),
            const SizedBox(height: 16),
            Text(nome, style: Theme.of(context).textTheme.headlineSmall),
            Text(usuario.email ?? ''),
            const SizedBox(height: 8),
            Text('UID: ${usuario.uid}'),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => _sair(context),
              child: const Text('SAIR'),
            ),
          ],
        ),
      ),
    );
  }
}
