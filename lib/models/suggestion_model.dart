class SuggestionModel {
  final int id;
  final String title;
  final String description;

  SuggestionModel({
    required this.id,
    required this.title,
    required this.description,
  });

  factory SuggestionModel.fromJson(Map<String, dynamic> json) {
    return SuggestionModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
    );
  }
}
