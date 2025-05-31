class Book {
  final String id;
  final String title;
  final String author;
  final String description;
  final String coverUrl;
  final double price;
  final double rating;
  final List<String> categories;
  final bool isAvailable;
  final String? coverAsset;
  final String? audioAsset;

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.description,
    required this.coverUrl,
    required this.price,
    required this.rating,
    required this.categories,
    this.isAvailable = true,
    this.coverAsset,
    this.audioAsset,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id'] as String,
      title: json['title'] as String,
      author: json['author'] as String,
      description: json['description'] as String,
      coverUrl: json['coverUrl'] as String,
      price: (json['price'] as num).toDouble(),
      rating: (json['rating'] as num).toDouble(),
      categories: List<String>.from(json['categories'] as List),
      isAvailable: json['isAvailable'] as bool? ?? true,
      coverAsset: json['coverAsset'] as String?,
      audioAsset: json['audioAsset'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'description': description,
      'coverUrl': coverUrl,
      'price': price,
      'rating': rating,
      'categories': categories,
      'isAvailable': isAvailable,
      'coverAsset': coverAsset,
      'audioAsset': audioAsset,
    };
  }
} 