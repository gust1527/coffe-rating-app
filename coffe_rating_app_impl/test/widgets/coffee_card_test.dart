import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:coffe_rating_app_impl/core/widgets/coffee_card.dart';
import 'package:coffe_rating_app_impl/core/theme/nordic_theme.dart';

void main() {
  group('CoffeeCard Widget Tests', () {
    testWidgets('should display coffee name', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: NordicTheme.lightTheme,
          home: const Scaffold(
            body: CoffeeCard(
              name: 'Ethiopian Yirgacheffe',
            ),
          ),
        ),
      );

      expect(find.text('Ethiopian Yirgacheffe'), findsOneWidget);
    });

    testWidgets('should display rating when provided', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: NordicTheme.lightTheme,
          home: const Scaffold(
            body: CoffeeCard(
              name: 'Test Coffee',
              rating: 4.5,
            ),
          ),
        ),
      );

      expect(find.text('4.5'), findsOneWidget);
      expect(find.byIcon(Icons.star), findsOneWidget);
    });

    testWidgets('should display roast level when provided', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: NordicTheme.lightTheme,
          home: const Scaffold(
            body: CoffeeCard(
              name: 'Test Coffee',
              roastLevel: 'Medium Roast',
            ),
          ),
        ),
      );

      expect(find.text('Medium Roast'), findsOneWidget);
    });

    testWidgets('should show "In Machine" indicator when isInMachine is true', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: NordicTheme.lightTheme,
          home: const Scaffold(
            body: CoffeeCard(
              name: 'Test Coffee',
              isInMachine: true,
            ),
          ),
        ),
      );

      expect(find.text('In Machine'), findsOneWidget);
    });

    testWidgets('should not show "In Machine" indicator when isInMachine is false', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: NordicTheme.lightTheme,
          home: const Scaffold(
            body: CoffeeCard(
              name: 'Test Coffee',
              isInMachine: false,
            ),
          ),
        ),
      );

      expect(find.text('In Machine'), findsNothing);
    });

    testWidgets('should display placeholder when no image provided', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: NordicTheme.lightTheme,
          home: const Scaffold(
            body: CoffeeCard(
              name: 'Test Coffee',
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.coffee), findsOneWidget);
    });

    testWidgets('should trigger onTap callback when tapped', (WidgetTester tester) async {
      bool tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          theme: NordicTheme.lightTheme,
          home: Scaffold(
            body: CoffeeCard(
              name: 'Test Coffee',
              onTap: () {
                tapped = true;
              },
            ),
          ),
        ),
      );

      await tester.tap(find.byType(CoffeeCard));
      expect(tapped, isTrue);
    });

    testWidgets('should display both rating and roast level with separator', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: NordicTheme.lightTheme,
          home: const Scaffold(
            body: CoffeeCard(
              name: 'Test Coffee',
              rating: 4.2,
              roastLevel: 'Dark Roast',
            ),
          ),
        ),
      );

      expect(find.text('4.2'), findsOneWidget);
      expect(find.text('•'), findsOneWidget);
      expect(find.text('Dark Roast'), findsOneWidget);
    });

    testWidgets('should have correct card dimensions', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: NordicTheme.lightTheme,
          home: const Scaffold(
            body: CoffeeCard(
              name: 'Test Coffee',
            ),
          ),
        ),
      );

      final cardFinder = find.byType(CoffeeCard);
      expect(cardFinder, findsOneWidget);

      final card = tester.widget<CoffeeCard>(cardFinder);
      expect(card.name, equals('Test Coffee'));
    });
  });
} 