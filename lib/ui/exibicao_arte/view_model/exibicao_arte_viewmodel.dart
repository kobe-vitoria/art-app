import 'package:art_app/data/repo_implementations/arte_repo.dart';
import 'package:art_app/domain/models/arte.dart';
import 'package:flutter/material.dart';

class ExibicaoArteViewmodel extends ChangeNotifier {
  List<Arte> listaArtes = [];

  ExibicaoArteViewmodel() {
    _carregaConteudo();
  }

  Future<void> _carregaConteudo() async {
    final arteRepo = ArteRepo();
    listaArtes = await arteRepo.getAllArteContent();
    notifyListeners();
    if (listaArtes.isNotEmpty) {
      await saveArts(listaArtes, arteRepo);
    }
  }

  Future<void> saveArts(List lista, ArteRepo repo) async {
    for (dynamic item in lista) {
      await repo.save(item as Arte);
    }
  } 
}