class Publicacao {
  String? id;
  String texto;
  String autorNome;
  String autorUid;
  int criadoEm;

  Publicacao({
    this.id,
    required this.texto,
    required this.autorNome,
    required this.autorUid,
    required this.criadoEm,
  });

  Map<String, dynamic> toMap() {
    return {
      'texto': texto,
      'autorNome': autorNome,
      'autorUid': autorUid,
      'criadoEm': criadoEm,
    };
  }

  factory Publicacao.fromMap(String id, Map<String, dynamic> map) {
    return Publicacao(
      id: id,
      texto: map['texto'] ?? '',
      autorNome: map['autorNome'] ?? '',
      autorUid: map['autorUid'] ?? '',
      criadoEm: map['criadoEm'] ?? 0,
    );
  }
}
