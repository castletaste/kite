class Category {
  final String name;
  final String file;

  const Category({required this.name, required this.file});

  factory Category.fromJson(Map<String, dynamic> json) =>
      Category(name: json['name'] as String, file: json['file'] as String);

  Map<String, dynamic> toJson() => {'name': name, 'file': file};

  @override
  String toString() => 'Category(name: $name, file: $file)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Category &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          file == other.file;

  @override
  int get hashCode => name.hashCode ^ file.hashCode;
}

class CategoriesResponse {
  final int timestamp;
  final List<Category> categories;

  const CategoriesResponse({required this.timestamp, required this.categories});

  factory CategoriesResponse.fromJson(Map<String, dynamic> json) =>
      CategoriesResponse(
        timestamp: json['timestamp'] as int,
        categories:
            (json['categories'] as List<dynamic>)
                .map((e) => Category.fromJson(e as Map<String, dynamic>))
                .toList(),
      );

  Map<String, dynamic> toJson() => {
    'timestamp': timestamp,
    'categories': categories.map((c) => c.toJson()).toList(),
  };
  @override
  String toString() =>
      'CategoriesResponse(timestamp: $timestamp, categories: $categories)';
}
