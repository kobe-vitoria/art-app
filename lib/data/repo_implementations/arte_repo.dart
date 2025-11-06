import 'package:art_app/data/services/graphql_service.dart';
import 'package:art_app/domain/models/arte.dart';
import 'package:art_app/domain/repositories/arte_repository.dart';

class ArteRepo implements ArteRepository {
  @override
  Future<List<Arte>> getAllArteContent() async {
    final baseUrl = 'https://cdn.contentful.com';
    final service = GraphQLService(baseUrl: baseUrl, authToken: 'bd_C3pgX-SGkkIzekWR_pnD4aSErbRFmsVX4TRdKZ14'); //TODO: add to .ENV
    final res = await service.query("""
      query {
        arteCollection {
          items {
            id
            nome
            descrio
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
    final lista = res['arteCollection']['items'] ? res['arteCollection']['items'].map((e) => Arte.fromJson(e)).toList().cast<Arte>() : [];
    return lista;
  }

  @override
  Future<List<Arte>> load(Arte arte) {
    // TODO: implement load
    throw UnimplementedError();
  }

  @override
  Future<void> save(Arte arte) {
    // TODO: implement save
    throw UnimplementedError();
  }
  
}