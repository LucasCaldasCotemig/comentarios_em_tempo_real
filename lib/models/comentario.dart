class Comentario {
  String? id;
  String texto;
  String nome;
  String usuarioId;
  String publicacaoId;
  int criadoEm;

  Comentario({
    this.id,
    required this.texto,
    required this.nome,
    required this.usuarioId,
    required this.publicacaoId,
    required this.criadoEm,
  });

  Map<String, dynamic> toMap() {
    return {
      'texto': texto,
      'nome': nome,
      'usuarioId': usuarioId,
      'publicacaoId': publicacaoId,
      'criadoEm': criadoEm,
    };
  }

  factory Comentario.fromMap(String id, Map<String, dynamic> map) {
    return Comentario(
      id: id,
      texto: map['texto'] ?? '',
      nome: map['nome'] ?? '',
      usuarioId: map['usuarioId'] ?? '',
      publicacaoId: map['publicacaoId'] ?? '',
      criadoEm: map['criadoEm'] ?? 0,
    );
  }
}
