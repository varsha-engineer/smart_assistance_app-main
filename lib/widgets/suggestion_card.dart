import 'package:flutter/material.dart';
import '../models/suggestion_model.dart';

class SuggestionCard extends StatelessWidget {
  final SuggestionModel suggestion;

  const SuggestionCard({super.key, required this.suggestion});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      child: ListTile(
        title: Text(suggestion.title),
        subtitle: Text(suggestion.description),
      ),
    );
  }
}
