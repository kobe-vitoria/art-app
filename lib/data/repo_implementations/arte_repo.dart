import 'dart:convert';

import 'package:art_app/data/services/api_service.dart';
import 'package:art_app/data/services/database_service.dart';
import 'package:art_app/data/services/graphql_service.dart';
import 'package:art_app/domain/models/arte.dart';
import 'package:art_app/domain/models/autor.dart';
import 'package:art_app/domain/repositories/arte_repository.dart';
import 'package:sqflite/sqflite.dart';

class ArteRepo implements ArteRepository {
  @override
  Future<List<Arte>> getAllArteContent() async {
    List<Arte> lista = [];
    final baseUrl = 'https://graphql.contentful.com/content/v1/spaces/vq7mfbsggeis/environments/master?';
    final service = GraphQLService(baseUrl: baseUrl, authToken: 'bd_C3pgX-SGkkIzekWR_pnD4aSErbRFmsVX4TRdKZ14'); //TODO: add to .ENV
    final res = await service.query("""
      query {
        arteCollection {
          items {
            id
            nome
            descricao
            temas
            curiosidades
            author {
              id
              authorBio
              authorName
              lastUpdatedAt
            }
            
          }
        }
      }
    """);
    // print(res);
    if (res.runtimeType == String) {
      print('entrou aqui');
      lista = await load();
      print(jsonEncode(lista));
    } else {
      lista = res['arteCollection'] != null ? res['arteCollection']['items'].map((e) => Arte.fromJson(e)).toList().cast<Arte>() : [];
    }
    final listaIds = lista.map((e) => e.id).join(',');
    final imageIdsResponse = await getImageIdsFromArticApi(listaIds);
    for (final item in imageIdsResponse) {
      for (final arte in lista) {
        if (arte.id == item['id']) {
          arte.urlImage = getImageUrlFromArticApi(item['image_id']);
        }
      }
    }
    return lista;
  }

  Future<List<dynamic>> getImageIdsFromArticApi(String ids) async {
    final baseUrl = 'https://api.artic.edu/';
    final service = ApiService(baseUrl: baseUrl);
    final res = await service.get('api/v1/artworks?ids=$ids&fields=id,image_id');
    return res['data'] ?? [];
  }

  String getImageUrlFromArticApi(String imageId) {
    return 'https://www.artic.edu/iiif/2/$imageId/full/843,/0/default.jpg';
  }

  @override
  Future<List<Arte>> load() async {
  final db = await DatabaseService.instance.database;

  final maps = await db.rawQuery('''
    SELECT A.*, 
           AU.id as authorId,
           AU.authorName,
           AU.authorBio,
           AU.lastUpdatedAt
    FROM Arte A
    LEFT JOIN Author AU ON A.authorId = AU.id
  ''');

  return maps.map((json) {
    final author = Autor(
      id: json['authorId'] as int,
      authorName: json['authorName'] as String,
      authorBio: json['authorBio'] as String,
      lastUpdatedAt: json['lastUpdatedAt'] != null ? DateTime.parse(json['lastUpdatedAt'] as String) : DateTime.now(),
    );

    return Arte(
      id: json['id'] as int,
      autor: author,
      nome: json['nome'] as String,
      descricao: json['descricao'] as String,
      temas: json['temas'] != null ? json['temas'] as String : '',
      curiosidades: json['curiosidades'] != null ? json['curiosidades'] as String : null,
    );
  }).toList();
}


  @override
  Future<void> save(Arte arte) async {
    final db = await DatabaseService.instance.database;
    final batch = db.batch();
    if (arte.autor == null) {
        return;
    }
    batch.insert('Arte', arte.toJson(), conflictAlgorithm: ConflictAlgorithm.ignore);
    batch.insert('Author', arte.autor!.toJson(), conflictAlgorithm: ConflictAlgorithm.ignore);
    await batch.commit();
  }
  

  @override
  Future<void> delete(Arte arte) async {
    final db = await DatabaseService.instance.database;
    final batch = db.batch();
    if (arte.autor == null) {
        return;
    }
    batch.delete('Arte', where: 'id = ?', whereArgs: [arte.id]);
    batch.delete('Author', where: 'id = ?',whereArgs: [arte.autor!.id]);
    await batch.commit();
  }
  
}