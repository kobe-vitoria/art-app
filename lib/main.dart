import 'package:art_app/ui/exibicao_arte/view_model/exibicao_arte_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final ExibicaoArteViewmodel exibicaoViewModel = ExibicaoArteViewmodel();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Guia do Museu de Chicago',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MyHomePage(
        title: 'Guia do Museu de Chicago',
        viewModel: exibicaoViewModel,
      ),
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
  final Set<int> _expandedCards = {}; // IDs das artes expandidas

  Future<void> _abrirLink(BuildContext context, String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Não foi possível abrir o link')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.viewModel,
      builder: (context, _) {
        final artes = widget.viewModel.listaArtes;

        return Scaffold(
          backgroundColor: Colors.grey[100],
          appBar: AppBar(
            title: Text(widget.title),
            centerTitle: true,
            elevation: 0,
            backgroundColor: Colors.deepPurple,
            foregroundColor: Colors.white,
          ),
          body: artes.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : RefreshIndicator(
                  onRefresh: () async {
                  },
                  child: ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: artes.length,
                    itemBuilder: (context, index) {
                      final arte = artes[index];
                      final expanded = _expandedCards.contains(arte.id);

                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOut,
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: Card(
                          elevation: expanded ? 8 : 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                if (expanded) {
                                  _expandedCards.remove(arte.id);
                                } else {
                                  _expandedCards.add(arte.id);
                                }
                              });
                            },
                            splashColor: Colors.deepPurple.withOpacity(0.1),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Imagem
                                if (arte.urlImage != null &&
                                    arte.urlImage!.isNotEmpty)
                                  Hero(
                                    tag: arte.id.toString(),
                                    child: Image.network(
                                      arte.urlImage!,
                                      height: 180,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, _, __) =>
                                          Container(
                                        height: 180,
                                        color: Colors.grey[300],
                                        alignment: Alignment.center,
                                        child: const Icon(Icons.broken_image,
                                            size: 60, color: Colors.grey),
                                      ),
                                    ),
                                  ),
                                // Informações básicas
                                Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              arte.nome ?? 'Sem título',
                                              style: const TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.deepPurple,
                                              ),
                                            ),
                                          ),
                                          Icon(
                                            expanded
                                                ? Icons.expand_less
                                                : Icons.expand_more,
                                            color: Colors.deepPurple,
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        arte.autor?.authorName ??
                                            'Artista desconhecido',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey[700],
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // Área expansível
                                AnimatedCrossFade(
                                  duration: const Duration(milliseconds: 400),
                                  crossFadeState: expanded
                                      ? CrossFadeState.showFirst
                                      : CrossFadeState.showSecond,
                                  firstChild: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 8),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        if (arte.descricao != null &&
                                            arte.descricao!.isNotEmpty)
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const Text(
                                                "Descrição:",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                  color: Colors.deepPurple,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                arte.descricao!,
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                ),
                                              ),
                                              const SizedBox(height: 12),
                                            ],
                                          ),
                                        if (arte.curiosidades != null &&
                                            arte.curiosidades!.isNotEmpty)
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const Text(
                                                "Curiosidades:",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                  color: Colors.deepPurple,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                arte.curiosidades!,
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                ),
                                              ),
                                              const SizedBox(height: 12),
                                            ],
                                          ),
                                        if (arte.autor?.authorBio != null &&
                                            arte.autor!.authorBio!.isNotEmpty)
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const Text(
                                                "Biografia do autor:",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                  color: Colors.deepPurple,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                arte.autor!.authorBio!,
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                ),
                                              ),
                                              const SizedBox(height: 12),
                                            ],
                                          ),
                                        Center(
                                          child: TextButton.icon(
                                            onPressed: () {
                                              if (arte.urlImage != null &&
                                                  arte.urlImage!.isNotEmpty) {
                                                _abrirLink(
                                                    context, arte.urlImage!);
                                              }
                                            },
                                            icon: const Icon(Icons.open_in_new),
                                            label: const Text(
                                                'Ver imagem completa'),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  secondChild: const SizedBox.shrink(),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
        );
      },
    );
  }
}
