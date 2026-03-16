import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:smart_assistance_app/providers/suggestion_provider.dart';
import 'package:smart_assistance_app/screens/home_screen.dart';

void main() {
  testWidgets('HomeScreen loads and displays suggestions',
      (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => SuggestionProvider()),
        ],
        child: const MaterialApp(home: HomeScreen()),
      ),
    );

    // Wait for initial load
    await tester.pumpAndSettle();

    // Verify that suggestions are displayed (assuming mock data)
    expect(find.text('Suggestions'), findsOneWidget);
  });
}
