import 'package:flutter_test/flutter_test.dart';
import 'mock_coffee_bean_provider.dart';

void main() {
  group('CoffeBeanDBProvider Tests', () {
    late MockCoffeBeanDBProvider provider;

    setUp(() {
      provider = MockCoffeBeanDBProvider();
    });

    group('State Management', () {
      test('should initialize with correct default values', () {
        expect(provider.isLoading, false);
        expect(provider.error, null);
        expect(provider.coffeeBeans, isEmpty);
        expect(provider.currentCoffeeBean, null);
      });

      test('should clear error when clearError is called', () {
        provider.clearError();
        expect(provider.error, null);
      });
    });

    group('Input Validation', () {
      test('should throw ArgumentError for empty bean maker', () async {
        expect(
          () => provider.addCoffeBeanType('', 'test type'),
          throwsA(isA<ArgumentError>()),
        );
      });

      test('should throw ArgumentError for empty bean type', () async {
        expect(
          () => provider.addCoffeBeanType('test maker', ''),
          throwsA(isA<ArgumentError>()),
        );
      });

      test('should throw ArgumentError for whitespace-only inputs', () async {
        expect(
          () => provider.addCoffeBeanType('  ', '  '),
          throwsA(isA<ArgumentError>()),
        );
      });

      test('should throw ArgumentError for rating below 1', () async {
        expect(
          () => provider.addRatingsToCoffeBeanType('test-id', 0),
          throwsA(isA<ArgumentError>()),
        );
      });

      test('should throw ArgumentError for rating above 5', () async {
        expect(
          () => provider.addRatingsToCoffeBeanType('test-id', 6),
          throwsA(isA<ArgumentError>()),
        );
      });

      test('should accept valid ratings 1-5', () {
        for (int rating = 1; rating <= 5; rating++) {
          expect(
            () => provider.addRatingsToCoffeBeanType('test-id', rating),
            returnsNormally,
          );
        }
      });
    });
  });
} 