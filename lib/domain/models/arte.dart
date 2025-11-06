import 'package:art_app/domain/models/autor.dart';

class Arte {
  final int id;
  final Autor? autor;
  final String nome; 
  final String descricao;
  final String temas;
  final String curiosidades;
  late final String? urlImage; 

  Arte({required this.id, required this.autor, required this.nome, required this.descricao, required this.temas, required this.curiosidades, this.urlImage});

 // Convert an Arte object to a Map (JSON)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'autor': autor?.id ?? '',
      'nome': nome,
      'descricao': descricao,
      'temas': temas,
      'curiosidades': curiosidades,
      'urlImage' : urlImage ?? ''
    };
  }

  // Create an Arte object from a Map (JSON)
  factory Arte.fromJson(Map<String, dynamic> json) {
    return Arte(
      id: json['id'],
      autor: Autor.fromJson(json['author']),
      nome: json['nome'],
      descricao: json['descricao'],
      temas: json['temas'],
      curiosidades: json['curiosidades'],
      urlImage: json['urlImage']
    );
  }
}