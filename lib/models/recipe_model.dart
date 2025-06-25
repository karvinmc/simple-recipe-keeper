class Recipe {
  final String? id;
  final String name;
  final String description;
  final String ingredients;
  final DateTime? createdAt;

  Recipe({
    this.id,
    required this.name,
    required this.description,
    required this.ingredients,
    this.createdAt,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      id: json['id'],
      name: json['name'],
      description: json['description'] ?? '',
      ingredients: json['ingredients'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'ingredients': ingredients,
    };
  }
}
