import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/publicacao.dart';

class PublicacaoService {
  final CollectionReference _collection =
      FirebaseFirestore.instance.collection('publicacoes');

  Future<void> adicionar(Publicacao publicacao) async {
    await _collection.add(publicacao.toMap());
  }

  Stream<List<Publicacao>> ouvirTodas() {
    return _collection.snapshots().map((snapshot) {
      final lista = snapshot.docs
          .map((doc) =>
              Publicacao.fromMap(doc.id, doc.data() as Map<String, dynamic>))
          .toList();
      lista.sort((a, b) => b.criadoEm.compareTo(a.criadoEm));
      return lista;
    });
  }
}
