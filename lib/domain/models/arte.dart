import 'package:art_app/domain/models/autor.dart';

class Arte {
  final int id;
  final Autor? autor;
  final String? nome; 
  final String? descricao;
  final String? temas;
  final String? curiosidades;
  late String? urlImage; 

  Arte({required this.id, this.autor, this.nome, this.descricao, this.temas, this.curiosidades, this.urlImage});

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
      autor: json['author'] != null ? Autor.fromJson(json['author']) : null,
      nome: json['nome'],
      descricao: json['descricao'],
      temas: json['temas'],
      curiosidades: json['curiosidades'],
    );
  }
}