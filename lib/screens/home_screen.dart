import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/suggestion_provider.dart';
import '../providers/theme_provider.dart';
import '../widgets/suggestion_card.dart';
import 'chat_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<SuggestionProvider>().fetchSuggestions();
    });

    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      context.read<SuggestionProvider>().fetchSuggestions();
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SuggestionProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Suggestions"),
        actions: [
          IconButton(
            icon: Icon(
              Theme.of(context).brightness == Brightness.dark ? Icons.light_mode : Icons.dark_mode,
            ),
            onPressed: () {
              context.read<ThemeProvider>().toggleTheme();
            },
          ),
        ],
      ),
      body: provider.suggestions.isEmpty && provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                if (provider.error != null)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(provider.error!, style: const TextStyle(color: Colors.red)),
                  ),
                Expanded(
                  child: NotificationListener<ScrollNotification>(
                    onNotification: (scrollNotification) {
                      if (scrollNotification is ScrollEndNotification &&
                          scrollNotification.metrics.pixels == scrollNotification.metrics.maxScrollExtent) {
                        context.read<SuggestionProvider>().fetchSuggestions();
                      }
                      return false;
                    },
                    child: ListView.builder(
                      controller: _scrollController,
                      itemCount: provider.suggestions.length + (provider.isLoading ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == provider.suggestions.length) {
                          return const Center(child: CircularProgressIndicator());
                        }
                        return SuggestionCard(
                          suggestion: provider.suggestions[index],
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.chat),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ChatScreen()),
          );
        },
      ),
    );
  }
}
