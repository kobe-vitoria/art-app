class Arte {
  final int id;
  final int autorId;
  final String nome; 
  final String descricao;
  final String temas;
  final String curiosidades;

  Arte({required this.id, required this.autorId, required this.nome, required this.descricao, required this.temas, required this.curiosidades});

 // Convert an Arte object to a Map (JSON)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'autorId': autorId,
      'nome': nome,
      'descricao': descricao,
      'temas': temas,
      'curiosidades': curiosidades
    };
  }

  // Create an Arte object from a Map (JSON)
  factory Arte.fromJson(Map<String, dynamic> json) {
    return Arte(
      id: json['id'],
      autorId: json['autorId'],
      nome: json['nome'],
      descricao: json['descricao'],
      temas: json['temas'],
      curiosidades: json['curiosidades']
    );
  }
}