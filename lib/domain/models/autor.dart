class Autor {
  final int id;
  final String? authorName; 
  final String? authorBio;
  final DateTime? lastUpdatedAt;

  Autor({
    required this.id,
    this.authorName,
    this.authorBio,
    this.lastUpdatedAt,
  });

  // Converter um Autor em JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'authorName': authorName,
      'authorBio': authorBio,
      'lastUpdatedAt': lastUpdatedAt?.toIso8601String(),
    };
  }

  // Criar um Autor a partir de JSON
  factory Autor.fromJson(Map<String, dynamic> json) {
    return Autor(
      id: json['id'],
      authorName: json['authorName'],
      authorBio: json['authorBio'],
      lastUpdatedAt: json['lastUpdatedAt'] != null ? DateTime.parse(json['lastUpdatedAt']) : null,
    );
  }
}
