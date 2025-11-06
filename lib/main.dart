import 'package:art_app/ui/exibicao_arte/view_model/exibicao_arte_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';


void main() {
  runApp( MyApp());
}

class MyApp extends StatelessWidget {
   MyApp({super.key});

  ExibicaoArteViewmodel exibicaoViewModel = ExibicaoArteViewmodel();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Guia do Museu de Chicago',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: MyHomePage(title: 'Guia do Museu de Chicago', viewModel: exibicaoViewModel),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title, required this.viewModel});
  final String title;
  final ExibicaoArteViewmodel viewModel;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}
class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    widget.viewModel.addListener(() {
      setState(() {});
    });
  }

    Future<void> _abrirLink(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Não foi possível abrir o link')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final artes = widget.viewModel.listaArtes;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: artes.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: artes.length,
              itemBuilder: (context, index) {
                final arte = artes[index];
                return ListTile(
                  title: Text(arte.nome ?? 'Sem título'),
                  subtitle: Text(arte.autor?.authorName ?? 'Artista desconhecido'),
                  trailing: const Icon(Icons.open_in_browser),
                  onTap: () {
                    if (arte.urlImage != null && arte.urlImage!.isNotEmpty) {
                      _abrirLink(arte.urlImage!);
                    }
                  },
                );
              },
            ),
    );
  }

}
