import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_assistance_app/providers/history_provider.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<HistoryProvider>().fetchHistory();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<HistoryProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text("Chat History")),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : provider.error != null
              ? Center(child: Text(provider.error!))
              : provider.history.isEmpty
                  ? const Center(child: Text("No history yet"))
                  : ListView.builder(
                      itemCount: provider.history.length,
                      itemBuilder: (context, index) {
                        final msg = provider.history[index];
                        return ListTile(
                          title: Text("${msg['sender']}: ${msg['message']}"),
                        );
                      },
                    ),
    );
  }
}
