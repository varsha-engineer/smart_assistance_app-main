import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_assistance_app/providers/history_provider.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _listController;

  @override
  void initState() {
    super.initState();
    _listController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    Future.microtask(() {
      context.read<HistoryProvider>().fetchHistory().then((_) {
        if (mounted) _listController.forward();
      });
    });
  }

  @override
  void dispose() {
    _listController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<HistoryProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDark ? const Color(0xFF1A1A2E) : const Color(0xFFF0F4FF),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: isDark ? const Color(0xFF16213E) : Colors.white,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: isDark ? Colors.white10 : Colors.grey.shade100,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              Icons.arrow_back_ios_rounded,
              size: 16,
              color: isDark ? Colors.white70 : Colors.grey.shade700,
            ),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Chat History",
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
            if (!provider.isLoading && provider.history.isNotEmpty)
              Text(
                "${provider.history.length} messages",
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12,
                  color: isDark ? Colors.white54 : Colors.black45,
                ),
              ),
          ],
        ),
        actions: [
          if (!provider.isLoading && provider.history.isNotEmpty)
            IconButton(
              icon: Icon(
                Icons.delete_outline_rounded,
                color: Colors.red.shade400,
              ),
              onPressed: () => _showClearDialog(context),
            ),
          const SizedBox(width: 8),
        ],
      ),
      body: provider.isLoading
          ? _buildLoadingState(isDark)
          : provider.error != null
              ? _buildErrorState(provider.error!, isDark)
              : provider.history.isEmpty
                  ? _buildEmptyState(isDark)
                  : RefreshIndicator(
                      onRefresh: () => provider.fetchHistory(),
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: provider.history.length,
                        itemBuilder: (context, index) {
                          return _buildAnimatedItem(
                            context,
                            index,
                            provider.history[index],
                            isDark,
                          );
                        },
                      ),
                    ),
    );
  }

  Widget _buildAnimatedItem(
    BuildContext context,
    int index,
    Map<String, String> msg,
    bool isDark,
  ) {
    final isUser = msg['sender'] == 'user';

    return AnimatedBuilder(
      animation: _listController,
      builder: (context, child) {
        final delay = (index * 0.1).clamp(0.0, 0.9);
        final animValue = Curves.easeOut
            .transform((_listController.value - delay).clamp(0.0, 1.0));
        return Opacity(
          opacity: animValue,
          child: Transform.translate(
            offset: Offset(0, 30 * (1 - animValue)),
            child: child,
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF252545) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isUser
                        ? [const Color(0xFF6C63FF), const Color(0xFF3B82F6)]
                        : [Colors.green.shade400, Colors.teal.shade400],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  isUser ? Icons.person_rounded : Icons.auto_awesome,
                  color: Colors.white,
                  size: 18,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isUser ? "You" : "AI Assistant",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: isUser
                            ? const Color(0xFF6C63FF)
                            : Colors.teal.shade600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      msg['message'] ?? '',
                      style: TextStyle(
                        fontSize: 14,
                        color: isDark ? Colors.white70 : Colors.black87,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingState(bool isDark) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 5,
      itemBuilder: (context, index) => Container(
        margin: const EdgeInsets.only(bottom: 10),
        height: 80,
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF252545) : Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Center(child: CircularProgressIndicator()),
      ),
    );
  }

  Widget _buildErrorState(String error, bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline_rounded,
              size: 56, color: Colors.red.shade300),
          const SizedBox(height: 16),
          Text(
            "Something went wrong",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            error,
            style: TextStyle(
                fontSize: 13, color: isDark ? Colors.white54 : Colors.black45),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: isDark ? Colors.white10 : Colors.grey.shade100,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Icon(
              Icons.history_rounded,
              size: 40,
              color: isDark ? Colors.white38 : Colors.grey.shade400,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            "No history yet",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Start chatting to see your conversation history",
            style: TextStyle(
              fontSize: 13,
              color: isDark ? Colors.white54 : Colors.black45,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _showClearDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text("Clear History"),
        content: const Text("Are you sure you want to clear all chat history?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text("Clear", style: TextStyle(color: Colors.red.shade400)),
          ),
        ],
      ),
    );
  }
}
