import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/comentario.dart';

class ComentarioService {
  final CollectionReference _collection =
      FirebaseFirestore.instance.collection('comentarios');

  Future<void> adicionar(Comentario comentario) async {
    await _collection.add(comentario.toMap());
  }

  Stream<List<Comentario>> ouvirDaPublicacao(String publicacaoId) {
    return _collection
        .where('publicacaoId', isEqualTo: publicacaoId)
        .snapshots()
        .map((snapshot) {
      final lista = snapshot.docs
          .map((doc) =>
              Comentario.fromMap(doc.id, doc.data() as Map<String, dynamic>))
          .toList();
      lista.sort((a, b) => a.criadoEm.compareTo(b.criadoEm));
      return lista;
    });
  }

  Future<void> excluir(String id) async {
    await _collection.doc(id).delete();
  }
}
